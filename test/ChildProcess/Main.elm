module Main exposing (main)

import Node.Error as Error
import Node.ChildProcess as ChildProcess
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
                                Debug.log "Testing" "spawn"
                        in
                            ChildProcess.spawn "ls -al" ChildProcess.Verbose
                                |> Task.andThen
                                    (\exit ->
                                        let
                                            message =
                                                Debug.log "Complete" "spawn"
                                        in
                                            Task.succeed ()
                                    )
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
