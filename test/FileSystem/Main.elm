module Main exposing (main)

import Node.Buffer as Buffer
import Node.Error as Common exposing (Error(..))
import Node.Encoding as Encoding
import Node.FileSystem as FileSystem
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
        filename =
            "test/output.txt"

        data =
            "data"

        encoding =
            Encoding.Utf8

        buffer =
            Buffer.fromString encoding data
                |> Result.extract (\_ -> Debug.crash "Failed to create buffer")
    in
        model
            ! [ Task.succeed ()
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "writeFile"
                            in
                                FileSystem.writeFile filename buffer
                                    |> Task.map (always (Debug.log "Complete" "writeFile") >> always ())
                        )
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "readFile"
                            in
                                FileSystem.readFile filename
                                    |> Task.andThen
                                        (\buffer ->
                                            let
                                                string =
                                                    Buffer.toString encoding buffer
                                                        |> Result.extract (\_ -> Debug.crash "Failed to create string")
                                            in
                                                if string == data then
                                                    let
                                                        message =
                                                            Debug.log "Complete" "readFile"
                                                    in
                                                        Task.succeed ()
                                                else
                                                    Task.fail <| Error "Failed" "readFile"
                                        )
                        )
                    |> Task.andThen
                        (\string ->
                            let
                                log =
                                    Debug.log "Testing" "writeFileFromString"
                            in
                                FileSystem.writeFileFromString filename "666" encoding "writeFileFromString"
                                    |> Task.map (always (Debug.log "Complete" "writeFileFromString") >> always ())
                        )
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "readFileAsString"
                            in
                                FileSystem.readFileAsString filename encoding
                                    |> Task.andThen
                                        (\string ->
                                            if string == "writeFileFromString" then
                                                let
                                                    message =
                                                        Debug.log "Complete" "readFileAsString"
                                                in
                                                    Task.succeed ()
                                            else
                                                Task.fail <| Error "Failed" "readFile"
                                        )
                        )
                    |> Task.andThen
                        (\_ ->
                            FileSystem.writeFileFromBuffer filename "666" buffer
                                |> Task.map (always (Debug.log "Complete" "writeFileFromString") >> always ())
                        )
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
