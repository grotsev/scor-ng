module Rpc exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Postgrest
import Uuid exposing (Uuid)


channelSeance :
    { a
        | seance : Uuid
    }
    -> Http.Request String
channelSeance =
    Postgrest.rpc
        { url = "http://localhost:3001/rpc/channel_seance"
        , encode =
            \{ seance } ->
                Encode.object
                    [ ( "seance", Uuid.encode seance )
                    ]
        , decoder = Decode.string
        }
        Nothing


auth :
    { a
        | seance : Uuid
        , login : String
        , password : String
    }
    -> Http.Request ()
auth =
    Postgrest.rpc
        { url = "http://localhost:3001/rpc/auth"
        , encode =
            \{ seance, login, password } ->
                Encode.object
                    [ ( "seance", Uuid.encode seance )
                    , ( "login", Encode.string login )
                    , ( "password", Encode.string password )
                    ]
        , decoder = Decode.succeed ()
        }
        Nothing
