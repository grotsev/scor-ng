module Page exposing (Msg, State, update, view)

import Data.Page exposing (SeanceMsg, Session)
import Html exposing (Html)
import Page.Home
import Page.Other
import Rocket exposing ((=>))


{-
   type alias Page state msg =
       { init : Session -> ( state, Cmd msg )
       , view : Session -> state -> Html msg
       , subscriptions : Session -> state -> Sub msg
       , update : msg -> Session -> state -> ( state, Cmd msg )
       , seanceMsg : SeanceMsg -> Maybe msg
       }
-}
-- MODEL --


type State
    = HomeState Page.Home.State
    | OtherState Page.Other.State



--init : Session -> ( State, Cmd Msg )
-- VIEW --


view : Session -> State -> Html Msg
view session state =
    let
        do fMsg subState pageView =
            pageView session subState |> Html.map fMsg
    in
    case state of
        HomeState subState ->
            do HomeMsg subState Page.Home.view

        OtherState subState ->
            do OtherMsg subState Page.Other.view



-- SUBSCRIPTIONS --


subscriptions : Session -> State -> Sub Msg
subscriptions session state =
    let
        do fMsg subState pageSubscriptions =
            pageSubscriptions session subState |> Sub.map fMsg
    in
    case state of
        HomeState subState ->
            do HomeMsg subState Page.Home.subscriptions

        OtherState subState ->
            do OtherMsg subState Page.Other.subscriptions



-- UPDATE --


type Msg
    = HomeMsg Page.Home.Msg
    | OtherMsg Page.Other.Msg


seanceMsg : SeanceMsg -> State -> Maybe Msg
seanceMsg msg state =
    let
        do fMsg pageSeanceMsg =
            pageSeanceMsg msg |> Maybe.map fMsg
    in
    case state of
        HomeState _ ->
            do HomeMsg Page.Home.seanceMsg

        OtherState _ ->
            do OtherMsg Page.Other.seanceMsg


update : Msg -> Session -> State -> ( State, Cmd Msg )
update msg session state =
    let
        do fMsg subMsg fState subState pageUpdate =
            let
                ( subStateNew, subCmd ) =
                    pageUpdate subMsg session subState
            in
            fState subStateNew => Cmd.map fMsg subCmd
    in
    case ( msg, state ) of
        ( HomeMsg subMsg, HomeState subState ) ->
            do HomeMsg subMsg HomeState subState Page.Home.update

        ( OtherMsg subMsg, OtherState subState ) ->
            do OtherMsg subMsg OtherState subState Page.Other.update

        _ ->
            state => Cmd.none
