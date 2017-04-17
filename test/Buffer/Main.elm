module Main exposing (main)

import Node.Buffer as Buffer exposing (Buffer)
import Node.Encoding as Encoding
import Node.Error as Error
import Result.Extra as Result
import Task exposing (Task)


type Msg
    = TestComplete (Result Error.Error ())


type alias Model =
    {}


model : Model
model =
    {}


init : ( Model, Cmd Msg )
init =
    let
        string =
            "hello"

        encoding =
            Encoding.Utf8
    in
        model
            ! [ Ok ()
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "Buffer.fromString"
                            in
                                Buffer.fromString Encoding.Utf8 string
                        )
                    |> Result.andThen
                        (\buffer ->
                            let
                                message =
                                    Debug.log "Testing" "Buffer.toString"
                            in
                                Buffer.toString Encoding.Utf8 buffer
                        )
                    |> Result.andThen
                        (\bufferString ->
                            if bufferString /= string then
                                Err <| Error.Error ("Buffer.toString failed: " ++ bufferString) ""
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
