module Main exposing (main)

import Node.Buffer as Buffer exposing (Buffer)
import Node.Common as Common
import Result.Extra as Result
import Task exposing (Task)


type Msg
    = TestComplete (Result String ())


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
            Common.Utf8
    in
        model
            ! [ Ok ()
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "Buffer.fromString"
                            in
                                Buffer.fromString Common.Utf8 string
                        )
                    |> Result.andThen
                        (\buffer ->
                            let
                                message =
                                    Debug.log "Testing" "Buffer.toString"
                            in
                                Buffer.toString Common.Utf8 buffer
                        )
                    |> Result.andThen
                        (\bufferString ->
                            if bufferString /= string then
                                Err <| "Buffer.toString failed: " ++ bufferString
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
