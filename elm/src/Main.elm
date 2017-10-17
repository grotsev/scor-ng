module Main exposing (main)

import Auth
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Data.Session as Session exposing (Session)
import Html exposing (Html)
import Html.Attributes as Attr
import I18n.Rus as I18n
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Page
import Postgrest
import Random.Pcg as Random
import Rocket exposing ((=>))
import Route exposing (Route)
import Rpc
import Util
import Uuid exposing (Uuid)
import WebSocket


{-| Main gathers Data.Session and passes it to Page
-}



-- MODEL --


type Step
    = Init
    | Seance Uuid
    | Auth
        { seance : Uuid
        , channel : String
        , auth : Auth.State
        }
    | Session
        { seance : Uuid
        , channel : String
        , session : Session
        , page : Page.State
        }
    | Error Postgrest.Error


type alias State =
    { navbar : Navbar.State
    , route : Route
    , step : Step
    }


init : Value -> Location -> ( State, Cmd Msg )
init flags location =
    let
        ( navbar, navbarCmd ) =
            Navbar.initialState NavbarMsg

        state =
            { navbar = navbar
            , route = Route.fromLocation location
            , step = Init
            }

        randomSeanceCmd =
            Random.generate SeanceResult Uuid.uuidGenerator
    in
    state ! [ navbarCmd, randomSeanceCmd ]



-- VIEW --


view : State -> Html Msg
view state =
    case state.step of
        Init ->
            Html.text "Seance generating..."

        Seance seance ->
            Html.text "Auth requesting..."

        Auth { auth } ->
            Html.map LoginMsg (Auth.view auth)

        Session { session, page } ->
            Html.div []
                [ Navbar.config NavbarMsg
                    |> Navbar.withAnimation
                    |> Navbar.container
                    |> Navbar.brand [ Attr.href "#" ] [ Html.text "Scoring" ]
                    |> Navbar.items
                        [ Navbar.itemLink [ Route.href Route.ThingRoll ] [ Html.text "Things" ]
                        ]
                    |> Navbar.customItems
                        [ Navbar.textItem [ Attr.class "mr-sm-2" ] [ Html.text <| session.surname ]
                        , Navbar.textItem [ Attr.class "mr-sm-3" ] [ Html.text <| session.name ]
                        , Navbar.formItem []
                            [ Button.button [ Button.small, Button.onClick LogoutMsg ] [ Html.text "Log out" ]
                            ]
                        ]
                    |> Navbar.view state.navbar
                , Grid.containerFluid [ Attr.class "mt-sm-5" ]
                    [ Page.view session page |> Html.map PageMsg ]
                ]

        Error error ->
            Html.text <| I18n.postgrestError error



-- SUBSCRIPTIONS --


subscriptions : State -> Sub Msg
subscriptions state =
    case state.step of
        Auth { channel } ->
            WebSocket.listen ("ws://localhost:3002/" ++ channel) ChannelMsg

        Session { channel } ->
            WebSocket.listen ("ws://localhost:3002/" ++ channel) ChannelMsg

        _ ->
            Sub.none



-- UPDATE --


type Msg
    = SeanceResult Uuid
    | ChannelResult (Postgrest.Result String)
    | LoginMsg Auth.Msg
    | ChannelMsg String
    | PageMsg Page.Msg
    | LogoutMsg
    | RouteMsg Route
    | NavbarMsg Navbar.State


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    let
        default =
            Basics.always state (Debug.log "Unhandled" ( msg, state.step )) => Cmd.none
    in
    case msg of
        SeanceResult seance ->
            case state.step of
                Init ->
                    { state | step = Seance seance }
                        => Postgrest.send ChannelResult (Rpc.channelSeance { seance = seance })

                _ ->
                    default

        ChannelResult channelResult ->
            case state.step of
                Seance seance ->
                    { state
                        | step =
                            case channelResult of
                                Ok channel ->
                                    Auth
                                        { seance = seance
                                        , channel = channel
                                        , auth = Auth.init
                                        }

                                Err error ->
                                    Error error
                    }
                        => Cmd.none

                _ ->
                    default

        LoginMsg subMsg ->
            case state.step of
                Auth c ->
                    Util.dispatch LoginMsg
                        (\auth -> { state | step = Auth { c | auth = auth } })
                        (Auth.update c.seance subMsg c.auth)

                _ ->
                    default

        ChannelMsg payload ->
            case state.step of
                Auth c ->
                    case Decode.decodeString Session.decoder payload of
                        Ok session ->
                            Util.dispatch PageMsg
                                (\page ->
                                    { state
                                        | step =
                                            Session
                                                { seance = c.seance
                                                , channel = c.channel
                                                , session = session
                                                , page = page
                                                }
                                    }
                                )
                                (Page.init state.route session)

                        Err error ->
                            { state
                                | step = Auth { c | auth = Auth.error c.auth }
                            }
                                => Cmd.none

                _ ->
                    default

        PageMsg subMsg ->
            case state.step of
                Session s ->
                    Util.dispatch PageMsg
                        (\page -> { state | step = Session { s | page = page } })
                        (Page.update s.session subMsg s.page)

                _ ->
                    default

        LogoutMsg ->
            case state.step of
                Session s ->
                    { state
                        | step =
                            Auth
                                { seance = s.seance
                                , channel = s.channel
                                , auth = Auth.init
                                }
                    }
                        => Cmd.none

                _ ->
                    default

        RouteMsg route ->
            case state.step of
                Session s ->
                    Util.dispatch PageMsg
                        (\page -> { state | route = route, step = Session { s | page = page } })
                        (Page.init route s.session)

                _ ->
                    { state | route = route } => Cmd.none

        NavbarMsg navbar ->
            { state | navbar = navbar } => Cmd.none



-- MAIN --


main : Program Value State Msg
main =
    Navigation.programWithFlags (RouteMsg << Route.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
