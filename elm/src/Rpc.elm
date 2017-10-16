module Rpc exposing (..)

import Data.Session as Session exposing (Session)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Postgrest
import Uuid exposing (Uuid)


seanceChannel :
    { a
        | seance : Uuid
    }
    -> Http.Request String
seanceChannel =
    Postgrest.rpc
        { url = "http://localhost:3001/rpc/seance_channel"
        , encode =
            \{ seance } ->
                Encode.object
                    [ ( "seance", Uuid.encode seance )
                    ]
        , decoder = Decode.string
        }
        Nothing


login :
    { a
        | seance : Uuid
        , login : String
        , password : String
    }
    -> Http.Request Session
login =
    Postgrest.rpc
        { url = "http://localhost:3001/rpc/login"
        , encode =
            \{ seance, login, password } ->
                Encode.object
                    [ ( "seance", Uuid.encode seance )
                    , ( "login", Encode.string login )
                    , ( "password", Encode.string password )
                    ]
        , decoder = Session.decoder
        }
        Nothing
