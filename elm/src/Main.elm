module Main exposing (main)

import Navigation exposing (Location)
import Page exposing (Page)
import Page.Home


{-| Main gathers Data.Session and passes it to Page
-}



-- MODEL --


type PageObject
    = PageHome (Page Page.Home.State Page.Home.Msg)


type PageMsg
    = PageHomeMsg (Page a)


update msg state =
  case (msg, state) of
    (PageHomeMsg, PageHome ) ->

    _ ->



-- VIEW --
-- SUBSCRIPTIONS --
-- UPDATE --
-- MAIN --
{-
   main : Program Value Model Msg
   main =
       Navigation.programWithFlags (SetRoute << Route.fromLocation)
           { init = init
           , view = view
           , update = update
           , subscriptions = subscriptions
           }
-}
