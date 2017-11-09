module Main exposing (main)

import Node.Error as Error
import Node.OperatingSystem as OperatingSystem
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
    model
        ! [ Ok ()
                |> Result.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "home"
                        in
                            case OperatingSystem.home of
                                Ok dirname ->
                                    let
                                        message =
                                            Debug.log "Complete" "home"
                                    in
                                        Ok ()

                                Err error ->
                                    Err error
                    )
                |> Result.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "temp"
                        in
                            case OperatingSystem.temp of
                                Ok dirname ->
                                    let
                                        message =
                                            Debug.log "Complete" "temp"
                                    in
                                        Ok ()

                                Err error ->
                                    Err error
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