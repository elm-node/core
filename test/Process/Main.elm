module Main exposing (main)

import Dict
import Node.Error as Error
import Node.Process as Process
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
    model
        ! [ Task.succeed ()
                |> Task.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "cwd"
                        in
                            Process.cwd ()
                                |> Task.andThen
                                    (\dirname ->
                                        let
                                            message =
                                                Debug.log "Complete" "cwd"
                                        in
                                            Task.succeed ()
                                    )
                    )
                |> Task.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "environment"

                            value =
                                Process.environment
                        in
                            case value of
                                Ok value ->
                                    if Dict.isEmpty value then
                                        Task.fail <| Error.Error "Failed" (toString value)
                                    else
                                        let
                                            message =
                                                Debug.log "Complete" "environment"
                                        in
                                            Task.succeed ()

                                Err error ->
                                    Task.fail <| Error.Error "Failed" (toString value)
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
