module Page.Other exposing (..)

import Data.Page exposing (SeanceMsg, Session)
import Html exposing (Html)
import Rocket exposing ((=>))


type alias State =
    ()


type alias Msg =
    Never


init : Session -> ( State, Cmd Msg )
init session =
    () => Cmd.none


view : Session -> State -> Html Msg
view session state =
    Html.text "Hello, you are at Home!"


subscriptions : Session -> State -> Sub Msg
subscriptions session state =
    Sub.none


update : Msg -> Session -> State -> ( State, Cmd Msg )
update msg session state =
    state => Cmd.none


seanceMsg : SeanceMsg -> Maybe Msg
seanceMsg seanceMsg =
    Nothing
