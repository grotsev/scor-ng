module Page.Home exposing (..)

import Data.SeanceMsg exposing (SeanceMsg)
import Data.Session exposing (Session)
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


update : Session -> Msg -> State -> ( State, Cmd Msg )
update session msg state =
    state => Cmd.none


seanceMsg : SeanceMsg -> Maybe Msg
seanceMsg seanceMsg =
    Nothing
