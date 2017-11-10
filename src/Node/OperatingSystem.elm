module Node.OperatingSystem
    exposing
        ( Platform(..)
        , home
        , platform
        , temp
        )

{-| Operating system information.

@docs Platform , home , platform , temp

-}

import Node.Error as Error exposing (Error(..))
import Node.OperatingSystem.LowLevel as LowLevel


{-| Current user's home directory.
-}
home : Result Error String
home =
    LowLevel.homedir
        |> Result.mapError Error.fromValue


{-| Platforms supported by Node.js.
-}
type Platform
    = Aix
    | Android
    | Darwin
    | FreeBsd
    | Linux
    | OpenBsd
    | SunOs
    | Windows


stringToPlatform : String -> Result String Platform
stringToPlatform string =
    case string of
        "aix" ->
            Ok Aix

        "android" ->
            Ok Android

        "darwin" ->
            Ok Darwin

        "freebsd" ->
            Ok FreeBsd

        "linux" ->
            Ok Linux

        "openbsd" ->
            Ok OpenBsd

        "sunos" ->
            Ok SunOs

        "win32" ->
            Ok Windows

        _ ->
            Err <| "Unrecognized platform: " ++ string


{-| Platform set at compile time of current running version of Node.js.
-}
platform : Result Error Platform
platform =
    LowLevel.platform
        |> Result.mapError Error.fromValue
        |> Result.andThen (stringToPlatform >> Result.mapError (\message -> Error message ""))


{-| Current user's temporary directory.
-}
temp : Result Error String
temp =
    LowLevel.tmpdir
        |> Result.mapError Error.fromValue
