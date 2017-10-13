module Main exposing (main)

import Navigation exposing (Location)
import Page exposing (Page)
import Page.Home


{-| Main gathers Data.Session and passes it to Page
-}



-- MODEL --


type alias State =
    { navbarState : Navbar.State
    , maybeRoute : Maybe Route
    , page : Page

    --, authState : Page.Auth.State
    --, seance : Maybe Uuid
    , seanceChannel : Maybe String
    }



-- VIEW --
-- SUBSCRIPTIONS --
-- UPDATE --
-- MAIN --


main : Program Value State Msg
main =
    Navigation.programWithFlags (SetRoute << Route.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
