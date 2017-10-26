module Main exposing (main)

import Node.Error as Error
import Node.Path as Path
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
        path =
            "/test/directory/file.txt"
    in
        model
            ! [ Ok ()
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "basename"

                                value =
                                    Path.basename path
                            in
                                if value == "file.txt" then
                                    let
                                        message =
                                            Debug.log "Complete" "basename"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
                        )
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "delimiter"

                                value =
                                    Path.delimiter
                            in
                                if value == ":" || value == ";" then
                                    let
                                        message =
                                            Debug.log "Complete" "delimiter"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
                        )
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "dirname"

                                value =
                                    Path.dirname path
                            in
                                if value == "/test/directory" then
                                    let
                                        message =
                                            Debug.log "Complete" "dirname"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
                        )
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "extname"

                                value =
                                    Path.extname path
                            in
                                if value == ".txt" then
                                    let
                                        message =
                                            Debug.log "Complete" "extname"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
                        )
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "join"

                                value =
                                    Path.join [ "/test", "directory", "file.txt" ]
                            in
                                if value == path then
                                    let
                                        message =
                                            Debug.log "Complete" "join"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
                        )
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "separator"

                                value =
                                    Path.separator
                            in
                                if value == "/" || value == "\\" then
                                    let
                                        message =
                                            Debug.log "Complete" "separator"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed" value
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
