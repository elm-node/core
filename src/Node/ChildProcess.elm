module Node.ChildProcess
    exposing
        ( Output(..)
        , Exit(..)
        , spawn
        )

{-| Child Process

@docs Output , Exit , spawn

-}

import Node.ChildProcess.LowLevel as LowLevel
import Node.Error as Error exposing (Error)
import Regex
import Task exposing (Task)


{-| Output type.
-}
type Output
    = Silent
    | Verbose


{-| Exit type.
-}
type Exit
    = Code Int
    | Signal String


{-| Spawn a child process by running the given command.
-}
spawn : String -> Output -> Task Error Exit
spawn command output =
    --QUESTION flip signature to read `spawn output command`?
    let
        silent =
            case output of
                Silent ->
                    True

                Verbose ->
                    False

        ( cmd, args ) =
            case Regex.split Regex.All (Regex.regex "\\s+") command of
                [] ->
                    ( "", [] )

                cmd :: args ->
                    ( cmd, args )
    in
        LowLevel.spawn cmd args silent
            |> Task.mapError Error.fromValue
            |> Task.andThen
                (\( code, signal ) ->
                    case ( code, signal ) of
                        ( Just code, Nothing ) ->
                            Task.succeed <| Code code

                        ( Nothing, Just signal ) ->
                            Task.succeed <| Signal signal

                        ( Nothing, Nothing ) ->
                            Task.fail <| Error.Error "Invalid response: Both code and signal are Nothing. Please report this as a bug." ""

                        ( Just code, Just signal ) ->
                            Task.fail <| Error.Error ("Invalid response: Both code and signal have values: ( code, signal ) = ( " ++ toString code ++ ", " ++ toString signal ++ " ). Please report this as a bug.") ""
                )
