module Data.Session exposing (Session, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as DP
import Uuid exposing (Uuid)


type alias Session =
    { rol : String -- TODO Data.Rol
    , actor : Uuid
    , login : String
    , surname : String
    , name : String
    , token : String
    }


decoder : Decoder Session
decoder =
    DP.decode Session
        |> DP.required "rol" Decode.string
        |> DP.required "actor" Uuid.decoder
        |> DP.required "login" Decode.string
        |> DP.required "surname" Decode.string
        |> DP.required "name" Decode.string
        |> DP.required "token" Decode.string
