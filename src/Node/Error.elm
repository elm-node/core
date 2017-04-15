module Node.Error
    exposing
        ( Error(..)
        , fromValue
        )

{-| Common types across node packages

@docs Error , fromValue

-}

import Json.Decode as Decode
import Result.Extra as Result


{-| -}
type Error
    = Error String String
    | SystemError
        { message : String
        , stack : String
        , code : String
        , syscall : String
        , path : Maybe String
        , address : Maybe String
        , port_ : Maybe String
        }


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.maybe (Decode.field "code" Decode.string)
        |> Decode.andThen
            (\code ->
                case code of
                    Just code ->
                        Decode.map7
                            (\message stack code syscall path address port_ ->
                                SystemError
                                    { message = message
                                    , stack = stack
                                    , code = code
                                    , syscall = syscall
                                    , path = path
                                    , address = address
                                    , port_ = port_
                                    }
                            )
                            (Decode.field "message" Decode.string)
                            (Decode.field "stack" Decode.string)
                            (Decode.field "code" Decode.string)
                            (Decode.field "syscall" Decode.string)
                            (Decode.maybe <| Decode.field "path" Decode.string)
                            (Decode.maybe <| Decode.field "address" Decode.string)
                            (Decode.maybe <| Decode.field "port" Decode.string)

                    Nothing ->
                        Decode.map2 Error
                            (Decode.field "message" Decode.string)
                            (Decode.field "stack" Decode.string)
            )


{-| -}
fromValue : Decode.Value -> Error
fromValue value =
    Decode.decodeValue errorDecoder value
        |> Result.extract (\error -> Error "Decoding Node Error failed." "")



-- {-| -}
-- type ErrorCode
--     = PermissionDenied -- EACCES
--     | OperationNotPermitted -- EPERM
--     | NoSuchFileOrDirectory -- ENOENT
--     | NotADirectory -- ENOTDIR
--     | IsADirectory -- EISDIR
--     | DirectoryNotEmpty -- ENOTEMPTY
--     | FileExists -- EEEXIST
--     | FileTooLarge -- EFBIG
--     | FilenameTooLong -- ENAMETOOLONG
--     | TooManyOpenFiles -- EMFILE, ENFILE
--     | NotEnoughSpace -- ENOMEM, ENOSPC
--     | DiskQuotaExceeded -- EDQUOT
--     | ReadOnlyFileSystem -- EROFS
--
--
-- errorMap : List ( Error, List String )
-- errorMap =
--     [ ( PermissionDenied, [ "EACCES" ] )
--     , ( OperationNotPermitted, [ "EPERM" ] )
--     , ( NoSuchFileOrDirectory, [ "ENOENT" ] )
--     , ( NotADirectory, [ "ENOTDIR" ] )
--     , ( IsADirectory, [ "EISDIR" ] )
--     , ( DirectoryNotEmpty, [ "ENOTEMPTY" ] )
--     , ( FileExists, [ "EEEXIST" ] )
--     , ( FileTooLarge, [ "EFBIG" ] )
--     , ( FilenameTooLong, [ "ENAMETOOLONG" ] )
--     , ( TooManyOpenFiles, [ "EMFILE", "ENFILE" ] )
--     , ( NotEnoughSpace, [ "ENOMEM", "ENOSPC" ] )
--     , ( DiskQuotaExceeded, [ "EDQUOT" ] )
--     , ( ReadOnlyFileSystem, [ "EROFS" ] )
--     ]
