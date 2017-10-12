module Data.Page exposing (SeanceMsg, Session)

import Uuid exposing (Uuid)


type alias Session =
    { rol : String -- TODO Data.Rol
    , actor : Uuid
    , login : String
    , surname : String
    , name : String
    , token : String
    }


type SeanceMsg
    = Login
