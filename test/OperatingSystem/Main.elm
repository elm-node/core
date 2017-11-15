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
                                Debug.log "Testing" "homeDirectory"
                        in
                            let
                                value =
                                    OperatingSystem.homeDirectory
                            in
                                if String.length value > 0 then
                                    let
                                        message =
                                            Debug.log "Complete" "homeDirectory"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed: 0 length" ""
                    )
                |> Result.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "platform"
                        in
                            case OperatingSystem.platform of
                                Ok _ ->
                                    let
                                        message =
                                            Debug.log "Complete" "platform"
                                    in
                                        Ok ()

                                Err error ->
                                    Err error
                    )
                |> Result.andThen
                    (\_ ->
                        let
                            message =
                                Debug.log "Testing" "tempDirectory"
                        in
                            let
                                value =
                                    OperatingSystem.tempDirectory
                            in
                                if String.length value > 0 then
                                    let
                                        message =
                                            Debug.log "Complete" "tempDirectory"
                                    in
                                        Ok ()
                                else
                                    Err <| Error.Error "Failed: 0 length" ""
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
