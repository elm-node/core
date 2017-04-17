module Main exposing (main)

import Node.Buffer as Buffer exposing (Buffer)
import Node.Encoding as Encoding
import Node.Error as Error exposing (Error(..))
import Node.Crypto as Crypto
import Result.Extra as Result
import Task exposing (Task)


type Msg
    = TestComplete (Result Error ())


type alias Model =
    {}


model : Model
model =
    {}


init : ( Model, Cmd Msg )
init =
    let
        cipher =
            Crypto.Aes128

        password =
            "test"

        string =
            "hello"

        encoding =
            Encoding.Utf8

        buffer =
            Buffer.fromString encoding string
    in
        case buffer of
            Err error ->
                Debug.crash (toString error)

            Ok buffer ->
                model
                    ! [ Ok ()
                            |> Result.andThen
                                (\_ ->
                                    let
                                        message =
                                            Debug.log "Testing" "Crypto.encrypt"
                                    in
                                        Crypto.encrypt cipher password buffer
                                )
                            |> Result.andThen
                                (\buffer ->
                                    let
                                        encryptedString =
                                            Buffer.toString encoding buffer
                                                |> Result.withDefault ""
                                    in
                                        if encryptedString == string then
                                            Err <| Error ("Encryption failed: " ++ encryptedString) ""
                                        else
                                            let
                                                message =
                                                    Debug.log "Testing" "Crypto.decrypt"
                                            in
                                                Crypto.decrypt cipher password buffer
                                )
                            |> Result.andThen
                                (\buffer ->
                                    let
                                        decryptedString =
                                            Buffer.toString encoding buffer
                                                |> Result.withDefault ""
                                    in
                                        if decryptedString /= string then
                                            Err <| Error ("Decryption failed: " ++ decryptedString) ""
                                        else
                                            Ok ()
                                )
                            |> Result.unpack Task.fail Task.succeed
                            |> Task.attempt TestComplete
                      ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TestComplete result ->
            let
                message =
                    Debug.log "TestComplete" result
            in
                model ! []



-- MAIN


main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        }
