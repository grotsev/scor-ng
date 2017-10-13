module Util exposing (..)


dispatch :
    (subMsg -> msg)
    -> (subState -> state)
    -> ( subState, Cmd subMsg )
    -> ( state, Cmd msg )
dispatch toMsg toState ( subState, subCmd ) =
    ( toState subState, Cmd.map toMsg subCmd )
