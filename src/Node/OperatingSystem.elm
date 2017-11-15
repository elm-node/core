module Node.OperatingSystem
    exposing
        ( Platform(..)
        , homeDirectory
        , platform
        , tempDirectory
        )

{-| Operating system information.

@docs Platform , homeDirectory , platform , tempDirectory

-}

import Node.Error as Error exposing (Error(..))
import Node.OperatingSystem.LowLevel as LowLevel


{-| Current user's home directory.
-}
homeDirectory : String
homeDirectory =
    LowLevel.homedir


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
        |> stringToPlatform
        |> Result.mapError (\message -> Error message "")


{-| Current user's temporary directory.
-}
tempDirectory : String
tempDirectory =
    LowLevel.tmpdir
