module Page exposing (Msg, State, init, update, view)

import Data.SeanceMsg exposing (SeanceMsg)
import Data.Session exposing (Session)
import Html exposing (Html)
import Page.Home
import Page.NotFound
import Page.ThingItem
import Page.ThingRoll
import Route exposing (Route)
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
    | NotFoundState Page.NotFound.State
    | ThingRollState Page.ThingRoll.State
    | ThingItemState Page.ThingItem.State


init : Route -> Session -> ( State, Cmd Msg )
init route session =
    case route of
        Route.Home ->
            Util.dispatch HomeMsg HomeState (Page.Home.init session)

        Route.NotFound ->
            Util.dispatch NotFoundMsg NotFoundState (Page.NotFound.init session)

        Route.ThingRoll ->
            Util.dispatch ThingRollMsg ThingRollState (Page.ThingRoll.init session)

        Route.ThingItem uuid ->
            Util.dispatch ThingItemMsg ThingItemState (Page.ThingItem.init session)



-- VIEW --


view : Session -> State -> Html Msg
view session state =
    let
        dispatch fMsg subState pageView =
            pageView session subState |> Html.map fMsg
    in
    case state of
        HomeState subState ->
            dispatch HomeMsg subState Page.Home.view

        NotFoundState subState ->
            dispatch NotFoundMsg subState Page.NotFound.view

        ThingRollState subState ->
            dispatch ThingRollMsg subState Page.ThingRoll.view

        ThingItemState subState ->
            dispatch ThingItemMsg subState Page.ThingItem.view



-- SUBSCRIPTIONS --


subscriptions : Session -> State -> Sub Msg
subscriptions session state =
    let
        dispatch fMsg subState pageSubscriptions =
            pageSubscriptions session subState |> Sub.map fMsg
    in
    case state of
        HomeState subState ->
            dispatch HomeMsg subState Page.Home.subscriptions

        NotFoundState subState ->
            dispatch NotFoundMsg subState Page.NotFound.subscriptions

        ThingRollState subState ->
            dispatch ThingRollMsg subState Page.ThingRoll.subscriptions

        ThingItemState subState ->
            dispatch ThingItemMsg subState Page.ThingItem.subscriptions



-- UPDATE --


type Msg
    = HomeMsg Page.Home.Msg
    | NotFoundMsg Page.NotFound.Msg
    | ThingRollMsg Page.ThingRoll.Msg
    | ThingItemMsg Page.ThingItem.Msg


seanceMsg : SeanceMsg -> State -> Maybe Msg
seanceMsg msg state =
    let
        dispatch fMsg pageSeanceMsg =
            pageSeanceMsg msg |> Maybe.map fMsg
    in
    case state of
        HomeState _ ->
            dispatch HomeMsg Page.Home.seanceMsg

        NotFoundState _ ->
            dispatch NotFoundMsg Page.NotFound.seanceMsg

        ThingRollState _ ->
            dispatch ThingRollMsg Page.ThingRoll.seanceMsg

        ThingItemState _ ->
            dispatch ThingItemMsg Page.ThingItem.seanceMsg


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
            ( state, Cmd.none )
