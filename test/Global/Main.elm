module Main exposing (main)

import Node.Global exposing (parseInt)
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
            "4033903d"
    in
        model
            ! [ Ok ()
                    |> Result.andThen
                        (\_ ->
                            let
                                message =
                                    Debug.log "Testing" "parseInt"
                            in
                                parseInt string 16
                                    |> Result.andThen
                                        (\value ->
                                            if value == 1077121085 then
                                                let
                                                    message =
                                                        Debug.log "Complete" "parseInt"
                                                in
                                                    Ok ()
                                            else
                                                Err <| Error.Error "Failed" "Wrong value."
                                        )
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
