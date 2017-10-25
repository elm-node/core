module Main exposing (main)

import Node.Buffer as Buffer
import Node.Error as Common exposing (Error(..))
import Node.Encoding as Encoding
import Node.FileSystem as FileSystem
import Result.Extra as Result
import Task exposing (Task)
import Utils.Ops exposing (..)


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
            "output.txt"

        testRoot =
            "test/FileSystem/tmp/"

        filenamePath =
            testRoot ++ filename

        symLink =
            "link"

        symlinkPath =
            testRoot ++ symLink

        data =
            "data"

        encoding =
            Encoding.Utf8

        buffer =
            Buffer.fromString encoding data
                |> Result.extract (\_ -> Debug.crash "Failed to create buffer")

        testing =
            Debug.log "Testing"

        completed msg =
            Debug.log "\x1B[32mCompleted" (msg ++ "\x1B[0m")

        completedTask msg =
            Task.map (always (completed msg) >> always ())

        failedTask =
            Task.fail << Error "Failed"
    in
        model
            ! [ Task.succeed ()
                    |> Task.andThen
                        (\_ ->
                            testing "mkdirp"
                                |> (\_ -> FileSystem.mkdirp "test/test1/test2")
                                |> completedTask "mkdirp"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "remove directory"
                                |> (\_ -> FileSystem.remove "test/test1")
                                |> completedTask "remove directory"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "writeFile"
                                |> (\_ -> FileSystem.writeFile filenamePath FileSystem.defaultMode buffer)
                                |> completedTask "writeFile"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "rename"
                                |> (\_ ->
                                        FileSystem.rename filenamePath (filenamePath ++ "r")
                                            |> Task.andThen (\_ -> FileSystem.rename (filenamePath ++ "r") filenamePath)
                                   )
                                |> completedTask "rename"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "symlink"
                                |> (\_ -> FileSystem.symlink filename symlinkPath)
                                |> completedTask "symlink"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "isSymlink"
                                |> (\_ -> FileSystem.isSymlink symlinkPath)
                                |> Task.andThen
                                    (flip (?)
                                        ( Task.succeed ()
                                        , failedTask (symlinkPath ++ " is NOT a symlink")
                                        )
                                    )
                                |> completedTask "isSymlink"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "exists symlink"
                                |> (\_ -> FileSystem.exists symlinkPath)
                                |> Task.andThen
                                    (flip (?)
                                        ( Task.succeed ()
                                        , failedTask (symlinkPath ++ " doesn't exist")
                                        )
                                    )
                                |> completedTask "exists symlink"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "remove symlink"
                                |> (\_ -> FileSystem.remove symlinkPath)
                                |> completedTask "remove symlink"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "readFile"
                                |> (\_ -> FileSystem.readFile filenamePath)
                                |> Task.andThen
                                    (\buffer ->
                                        Buffer.toString encoding buffer
                                            |> Result.extract (\_ -> Debug.crash "Failed to create string")
                                            |> (\string ->
                                                    (string == data)
                                                        ? ( Task.succeed ()
                                                                |> completedTask "readFile"
                                                          , failedTask "readFile"
                                                          )
                                               )
                                    )
                        )
                    |> Task.andThen
                        (\string ->
                            testing "writeFileFromString"
                                |> (\_ -> FileSystem.writeFileFromString filenamePath "666" encoding "writeFileFromString")
                                |> completedTask "writeFileFromString"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "readFileAsString"
                                |> (\_ -> FileSystem.readFileAsString filenamePath encoding)
                                |> Task.andThen
                                    (\string ->
                                        (string == "writeFileFromString")
                                            ? ( Task.succeed ()
                                                    |> completedTask "readFileAsString"
                                              , failedTask "readFile"
                                              )
                                    )
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "writeFileFromBuffer"
                                |> (\_ -> FileSystem.writeFileFromBuffer filenamePath "666" buffer)
                                |> completedTask "writeFileFromBuffer"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "copy"
                                |> (\_ -> FileSystem.copy False (filenamePath ++ "c") filenamePath)
                                |> completedTask "copy"
                        )
                    |> Task.andThen
                        (\_ ->
                            testing "remove"
                                |> (\_ -> FileSystem.remove testRoot)
                                |> completedTask "remove"
                        )
                    |> Task.attempt TestComplete
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TestComplete (Err nodeError) ->
            case nodeError of
                Error _ error ->
                    Debug.log "Test Failed" ("\x1B[31m" ++ error ++ "\x1B[0m")
                        |> always (model ! [])

                SystemError _ _ ->
                    Debug.crash "Bug"

        TestComplete (Ok ()) ->
            Debug.log ("\n\x1B[32m" ++ "ALL Tests Passed" ++ "\x1B[0m") ""
                |> always (model ! [])



-- MAIN


main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        }
