module Login exposing (Msg, State, error, init, update, view)

import Bootstrap.Grid as Grid
import Field
import Html exposing (Html)
import Html.Attributes as Attr
import Postgrest
import Rocket exposing ((=>))
import Rpc
import Uuid exposing (Uuid)
import Validate


-- MODEL --


type alias State =
    { login : String
    , password : String
    , loading : Bool
    , response : Postgrest.Response ()
    }


init : State
init =
    { login = ""
    , password = ""
    , loading = False
    , response = Nothing
    }


error : State -> State
error state =
    { state
        | loading = False
        , response = Just (Err Postgrest.Decode)
    }



-- VIEW --


view : State -> Html Msg
view { login, password, loading, response } =
    let
        loginField =
            { id = "register-login"
            , title = "Логин"
            , help = Just "Уникальный идентификатор пользователя"
            , validation = Validate.filled login
            , input = Field.text LoginMsg login
            }

        passwordField =
            { id = "register-password"
            , title = "Пароль"
            , help = Nothing
            , validation = Validate.secure password
            , input = Field.password PasswordMsg password
            }
    in
    Grid.container [ Attr.class "mt-sm-5" ]
        [ Field.form loading response LoginRequest "Войти" <|
            [ loginField
            , passwordField
            ]
        ]



-- UPDATE --


type Msg
    = LoginMsg String
    | PasswordMsg String
    | LoginRequest
    | LoginResult (Postgrest.Result ())


update : Uuid -> Msg -> State -> ( State, Cmd Msg )
update seance msg ({ login, password, loading, response } as state) =
    case msg of
        LoginMsg login ->
            { state | login = login } => Cmd.none

        PasswordMsg password ->
            { state | password = password } => Cmd.none

        LoginRequest ->
            { state | loading = True }
                => Postgrest.send LoginResult (Rpc.login { seance = seance, login = login, password = password })

        LoginResult result ->
            case result of
                Ok () ->
                    state => Cmd.none

                Err error ->
                    { state | loading = False, response = Just (Err error) }
                        => Cmd.none
