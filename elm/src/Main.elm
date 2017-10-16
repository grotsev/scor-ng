module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Data.Session exposing (Session)
import Field
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
import Validate


{-| Main gathers Data.Session and passes it to Page
-}



-- MODEL --


type Step
    = Init
    | Seance Uuid
    | Channel
        { seance : Uuid
        , channel : String
        , login : String
        , password : String
        , loading : Bool
        , response : Postgrest.Response ()
        }
    | Session { channel : String, session : Session, page : Page.State }
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
            Html.text "Channel requesting..."

        Channel { channel, login, password, loading, response } ->
            let
                loginField =
                    { id = "register-login"
                    , title = "Логин"
                    , help = Just "Уникальный идентификатор пользователя"
                    , validation = Validate.filled login
                    , input = Field.text LoginMsg login
                    }

                passwordField =
                    { id = "register-password"
                    , title = "Пароль"
                    , help = Nothing
                    , validation = Validate.secure password
                    , input = Field.password PasswordMsg password
                    }
            in
            Grid.container [ Attr.class "mt-sm-5" ]
                [ Field.form loading response LoginRequest "Войти" <|
                    [ loginField
                    , passwordField
                    ]
                ]

        Session { channel, session, page } ->
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
--TODO


subscriptions : State -> Sub Msg
subscriptions state =
    Sub.none



-- UPDATE --


type Msg
    = SeanceResult Uuid
    | ChannelResult (Postgrest.Result String)
    | LoginMsg String
    | PasswordMsg String
    | LoginRequest
    | LoginResult (Postgrest.Result Session)
    | PageMsg Page.Msg
    | LogoutMsg
    | RouteMsg Route
    | NavbarMsg Navbar.State


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case ( state.step, msg ) of
        ( Init, SeanceResult seance ) ->
            { state | step = Seance seance }
                => Postgrest.send ChannelResult (Rpc.seanceChannel { seance = seance })

        ( Seance seance, ChannelResult channelResult ) ->
            { state
                | step =
                    case channelResult of
                        Ok channel ->
                            Channel
                                { seance = seance
                                , channel = channel
                                , login = ""
                                , password = ""
                                , loading = False
                                , response = Nothing
                                }

                        Err error ->
                            Error error
            }
                => Cmd.none

        ( Channel c, LoginMsg login ) ->
            { state | step = Channel { c | login = login } } => Cmd.none

        ( Channel c, PasswordMsg password ) ->
            { state | step = Channel { c | password = password } } => Cmd.none

        ( Channel c, LoginRequest ) ->
            { state | step = Channel { c | loading = True } }
                => Postgrest.send LoginResult (Rpc.login c)

        ( Channel c, LoginResult result ) ->
            case result of
                Ok session ->
                    Util.dispatch PageMsg
                        (\page -> { state | step = Session { channel = c.channel, session = session, page = page } })
                        (Page.init state.route session)

                Err error ->
                    { state | step = Channel { c | loading = False, response = Just (Err error) } } => Cmd.none

        ( Session s, RouteMsg route ) ->
            Util.dispatch PageMsg
                (\page -> { state | route = route, step = Session { s | page = page } })
                (Page.init route s.session)

        ( _, RouteMsg route ) ->
            { state | route = route } => Cmd.none

        ( _, NavbarMsg navbar ) ->
            { state | navbar = navbar } => Cmd.none

        ( step, msg ) as pair ->
            Basics.always state (Debug.log "Unhandled" pair) => Cmd.none



{- TODO cmd -}
-- MAIN --


main : Program Value State Msg
main =
    Navigation.programWithFlags (RouteMsg << Route.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
