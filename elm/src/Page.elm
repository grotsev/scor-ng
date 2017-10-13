module Page exposing (Msg, State, update, view)

import Data.Page exposing (SeanceMsg, Session)
import Html exposing (Html)
import Page.Home
import Page.ThingItem
import Page.ThingRoll
import Rocket exposing ((=>))
import Util


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
    | ThingRollState Page.ThingRoll.State
    | ThingItemState Page.ThingItem.State



--init : Session -> Route -> ( State, Cmd Msg )
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

        ThingRollState subState ->
            do ThingRollMsg subState Page.ThingRoll.view

        ThingItemState subState ->
            do ThingItemMsg subState Page.ThingItem.view



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

        ThingRollState subState ->
            do ThingRollMsg subState Page.ThingRoll.subscriptions

        ThingItemState subState ->
            do ThingItemMsg subState Page.ThingItem.subscriptions



-- UPDATE --


type Msg
    = HomeMsg Page.Home.Msg
    | ThingRollMsg Page.ThingRoll.Msg
    | ThingItemMsg Page.ThingItem.Msg


seanceMsg : SeanceMsg -> State -> Maybe Msg
seanceMsg msg state =
    let
        do fMsg pageSeanceMsg =
            pageSeanceMsg msg |> Maybe.map fMsg
    in
    case state of
        HomeState _ ->
            do HomeMsg Page.Home.seanceMsg

        ThingRollState _ ->
            do ThingRollMsg Page.ThingRoll.seanceMsg

        ThingItemState _ ->
            do ThingItemMsg Page.ThingItem.seanceMsg


update : Msg -> Session -> State -> ( State, Cmd Msg )
update msg session state =
    case ( msg, state ) of
        ( HomeMsg subMsg, HomeState subState ) ->
            Util.dispatch HomeMsg HomeState (Page.Home.update session subMsg subState)

        ( ThingRollMsg subMsg, ThingRollState subState ) ->
            Util.dispatch ThingRollMsg ThingRollState (Page.ThingRoll.update session subMsg subState)

        ( ThingItemMsg subMsg, ThingItemState subState ) ->
            Util.dispatch ThingItemMsg ThingItemState (Page.ThingItem.update session subMsg subState)

        _ ->
            state => Cmd.none
