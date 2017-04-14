module Main exposing (main)

import Node.Buffer as Buffer
import Node.Common as Common
import Node.FileSystem as FileSystem
import Result.Extra as Result
import Task exposing (Task)


type Msg
    = TestComplete (Result FileSystem.Error ())


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
    in
        model
            ! [ Task.succeed ()
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "writeFile"
                            in
                                FileSystem.writeFile filename "writeFile"
                        )
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "readFile"
                            in
                                FileSystem.readFile filename
                        )
                    |> Task.andThen
                        (\string ->
                            let
                                log =
                                    Debug.log "Testing" "writeFileFromString"
                            in
                                if string /= "writeFile" then
                                    Task.fail <| FileSystem.Error "readFile"
                                else
                                    FileSystem.writeFileFromString filename "666" Common.Utf8 "writeFileFromString"
                        )
                    |> Task.andThen
                        (\_ ->
                            let
                                log =
                                    Debug.log "Testing" "readFileAsString"
                            in
                                FileSystem.readFileAsString filename Common.Utf8
                        )
                    |> Task.andThen
                        (\string ->
                            let
                                log =
                                    Debug.log "Testing" "readFileAsBuffer"
                            in
                                if string /= "writeFileFromString" then
                                    Task.fail <| FileSystem.Error "readFileAsString"
                                else
                                    FileSystem.readFileAsBuffer filename
                        )
                    |> Task.andThen
                        (\buffer ->
                            let
                                log =
                                    Debug.log "Testing" "bufferToString"
                            in
                                Buffer.toString Common.Utf8 buffer
                                    |> Result.unpack
                                        (FileSystem.Error >> Task.fail)
                                        (\string ->
                                            let
                                                log =
                                                    Debug.log "Testing" "writeFileFromBuffer"
                                            in
                                                if string /= "writeFileFromString" then
                                                    Task.fail <| FileSystem.Error "readFileAsString"
                                                else
                                                    FileSystem.writeFileFromBuffer filename "666" buffer
                                        )
                        )
                    |> Task.andThen
                        (\_ ->
                            FileSystem.readFile filename
                        )
                    |> Task.andThen
                        (\string ->
                            if string /= "writeFileFromString" then
                                Task.fail <| FileSystem.Error "readFileAsString"
                            else
                                Task.succeed ()
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
