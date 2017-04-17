module Node.Error
    exposing
        ( Error(..)
        , fromValue
        , Code(..)
        )

{-| Error type.

@docs Error , fromValue , Code

-}

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import List.Extra as List
import Result.Extra as Result


{-| -}
type Error
    = Error String String
    | SystemError
        { message : String
        , stack : String
        , code : Code
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
                            (Decode.field "code" <| Decode.andThen (codeFromString >> Decode.fromResult) Decode.string)
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
        |> Result.extract (\error -> Error "Decoding Error value failed." "")


{-| -}
type Code
    = ArgumentListTooLong --E2BIG
    | PermissionDenied --EACCES
    | AddressInUse --EADDRINUSE
    | AddressNotAvailable --EADDRNOTAVAIL
    | AddressFamilyNotSupported --EAFNOSUPPORT
    | ResourceTemporarilyUnavailable --EAGAIN
    | ConnectionAlreadyInProgress --EALREADY
    | InvalidExchange --EBADE
    | BadFileDescriptor --EBADF
    | FileDescriptorInBadState --EBADFD
    | BadMessage --EBADMSG
    | InvalidRequestDescriptor --EBADR
    | InvalidRequestCode --EBADRQC
    | InvalidSlot --EBADSLT
    | DeviceOrResourceBusy --EBUSY
    | OperationCancelled --ECANCELED
    | NoChildProcesses --ECHILD
    | ChannelNumberOutOfRange --ECHRNG
    | CommunicationErrorOnSend --ECOMM
    | ConnectionAborted --ECONNABORTED
    | ConnectionRefused --ECONNREFUSED
    | ConnectionReset --ECONNRESET
    | ResourceDeadlockAvoided --EDEADLK, EDEADLOCK
    | DestinationAddressRequired --EDESTADDRREQ
    | ArgumentOutOfDomain --EDOM
    | DiskQuotaExceeded --EDQUOT
    | FileExists -- EEEXIST
    | BadAddress --EFAULT
    | FileTooLarge --EFBIG
    | HostDown --EHOSTDOWN
    | HostUnreachable --EHOSTUNREACH
    | IdentifierRemoved --EIDRM
    | IllegalByteSequence --EILSEQ
    | OperationInProgress --EINPROGRESS
    | InteruptedFunctionCall --EINTR
    | InvalidArgument --EINVAL
    | InputOutput --EIO
    | SocketConnected --EISCONN
    | IsADirectory --EISDIR
    | NamedTypeFile --EISNAM
    | KeyExpired --EKEYEXPIRED
    | KeyRejected --EKEYREJECTED
    | KeyRevoked --EKEYREVOKED
    | Level2Halted --EL2HLT
    | Level2NotSynchronized --EL2NSYNC
    | Level3Halted --EL3HLT, EL3RST
    | CannotAccessLibrary --ELIBACCESS
    | LibraryCorrupted --ELIBBAD
    | TooManyLibraries --ELIBMAX
    | LibSectionCorrupted --ELIBSCN
    | CannotExecuteLibrary --ELIBEXEC
    | TooManyLevelsOfSymbolicLinks --ELOOP
    | WrongMediumType --EMEDIUMTYPE
    | TooManyOpenFiles --EMFILE, ENFILE
    | TooManyLinks --EMLINK
    | MessageTooLong --EMSGSIZE
    | MultihopAttempted --EMULTIHOP
    | FilenameTooLong --ENAMETOOLONG
    | NetworkDown --ENETDOWN
    | ConnectionAbortedByNetwork --ENETRESET
    | NetworkUnreachable --ENETUNREACH
    | NoBufferSpaceAvailable --ENOBUFS
    | NoDataAvailable --ENODATA
    | NoDevice --ENODEV
    | NoSuchFileOrDirectory --ENOENT
    | ExecuteFormatError --ENOEXEC
    | RequiredKeyNotAvailable --ENOKEY
    | NoLocksAvailable --ENOLCK
    | NoLink --ENOLINK
    | NoMedium --ENOMEDIUM
    | NotEnoughSpace -- ENOMEM, ENOSPC
    | NoMessage --ENOMSG
    | NotOnNetwork --ENONET
    | PackageNotInstalled --ENOPKG
    | ProtocolNotAvailable --ENOPROTOOPT
    | NoStreamResources --ENOSR
    | NotStream --ENOSTR
    | FunctionNotImplemented --ENOSYS
    | BlockDeviceRequired --ENOTBLK
    | SocketNotConnected --ENOTCONN
    | NotADirectory --ENOTDIR
    | DirectoryNotEmpty --ENOTEMPTY
    | NotSocket --ENOTSOCKET
    | OperationNotSupported --ENOTSUP
    | InappropriateIOControlOperation --ENOTTY
    | NameNotUniqueOnNetwork --ENOTUNIQ
    | NoDeviceOrAddress --ENXIO
    | OperationNotSupportedOnSocket --EOPNOTSUPP
    | ValueTooLarge --EOVERFLOW
    | OperationNotPermitted -- EPERM
    | ProtocolFamilyNotAvailable --EPFNOSUPPORT
    | BrokenPipe --EPIPE
    | Protocol --EPROTO
    | ProtocolNotSupported --EPROTONOSUPPORT
    | WrongProtocolForSocket --EPROTOTYPE
    | ResultTooLarge --ERANGE
    | RemoteAddressChanged --EREMCHG
    | ObjectRemote --EREMOTE
    | RemoteIO --EREMOTEIO
    | RestartCall --ERESTART
    | ReadOnlyFileSystem --EROFS
    | TransportEndpointShutdown --ESHUTDOWN
    | InvalidSeek --ESPIPE
    | SocketNotSupported --ESOCKTNOSUPPORT
    | NoProcess --ESRCH
    | StaleFileHandle --ESTALE
    | StreamPipe --ESTRPIPE
    | TimerExpired --ETIME
    | ConnectionTimedOut --ETIMEOUT
    | TextFileBusy --ETXTBUSY
    | StructureNeedsCleaning --EUCLEAN
    | ProtocolDriverNotAttached --EUNATCH
    | TooManyUsers --EUSERS
    | OperationWouldBlock --EWOULDBLOCK
    | ImproperLink --EXDEV
    | ExchangeFull --EXFULL


codeMap : List ( Code, List String )
codeMap =
    [ ( ArgumentListTooLong, [ "E2BIG" ] )
    , ( PermissionDenied, [ "EACCES" ] )
    , ( AddressInUse, [ "EADDRINUSE" ] )
    , ( AddressNotAvailable, [ "EADDRNOTAVAIL" ] )
    , ( AddressFamilyNotSupported, [ "EAFNOSUPPORT" ] )
    , ( ResourceTemporarilyUnavailable, [ "EAGAIN" ] )
    , ( ConnectionAlreadyInProgress, [ "EALREADY" ] )
    , ( InvalidExchange, [ "EBADE" ] )
    , ( BadFileDescriptor, [ "EBADF" ] )
    , ( FileDescriptorInBadState, [ "EBADFD" ] )
    , ( BadMessage, [ "EBADMSG" ] )
    , ( InvalidRequestDescriptor, [ "EBADR" ] )
    , ( InvalidRequestCode, [ "EBADRQC" ] )
    , ( InvalidSlot, [ "EBADSLT" ] )
    , ( DeviceOrResourceBusy, [ "EBUSY" ] )
    , ( OperationCancelled, [ "ECANCELED" ] )
    , ( NoChildProcesses, [ "ECHILD" ] )
    , ( ChannelNumberOutOfRange, [ "ECHRNG" ] )
    , ( CommunicationErrorOnSend, [ "ECOMM" ] )
    , ( ConnectionAborted, [ "ECONNABORTED" ] )
    , ( ConnectionRefused, [ "ECONNREFUSED" ] )
    , ( ConnectionReset, [ "ECONNRESET" ] )
    , ( ResourceDeadlockAvoided, [ "EDEADLK", "EDEADLOCK" ] )
    , ( DestinationAddressRequired, [ "EDESTADDRREQ" ] )
    , ( ArgumentOutOfDomain, [ "EDOM" ] )
    , ( DiskQuotaExceeded, [ "EDQUOT" ] )
    , ( FileExists, [ " EEEXIST" ] )
    , ( BadAddress, [ "EFAULT" ] )
    , ( FileTooLarge, [ "EFBIG" ] )
    , ( HostDown, [ "EHOSTDOWN" ] )
    , ( HostUnreachable, [ "EHOSTUNREACH" ] )
    , ( IdentifierRemoved, [ "EIDRM" ] )
    , ( IllegalByteSequence, [ "EILSEQ" ] )
    , ( OperationInProgress, [ "EINPROGRESS" ] )
    , ( InteruptedFunctionCall, [ "EINTR" ] )
    , ( InvalidArgument, [ "EINVAL" ] )
    , ( InputOutput, [ "EIO" ] )
    , ( SocketConnected, [ "EISCONN" ] )
    , ( IsADirectory, [ "EISDIR" ] )
    , ( NamedTypeFile, [ "EISNAM" ] )
    , ( KeyExpired, [ "EKEYEXPIRED" ] )
    , ( KeyRejected, [ "EKEYREJECTED" ] )
    , ( KeyRevoked, [ "EKEYREVOKED" ] )
    , ( Level2Halted, [ "EL2HLT" ] )
    , ( Level2NotSynchronized, [ "EL2NSYNC" ] )
    , ( Level3Halted, [ "EL3HLT", "EL3RST" ] )
    , ( CannotAccessLibrary, [ "ELIBACCESS" ] )
    , ( LibraryCorrupted, [ "ELIBBAD" ] )
    , ( TooManyLibraries, [ "ELIBMAX" ] )
    , ( LibSectionCorrupted, [ "ELIBSCN" ] )
    , ( CannotExecuteLibrary, [ "ELIBEXEC" ] )
    , ( TooManyLevelsOfSymbolicLinks, [ "ELOOP" ] )
    , ( WrongMediumType, [ "EMEDIUMTYPE" ] )
    , ( TooManyOpenFiles, [ "EMFILE", "ENFILE" ] )
    , ( TooManyLinks, [ "EMLINK" ] )
    , ( MessageTooLong, [ "EMSGSIZE" ] )
    , ( MultihopAttempted, [ "EMULTIHOP" ] )
    , ( FilenameTooLong, [ "ENAMETOOLONG" ] )
    , ( NetworkDown, [ "ENETDOWN" ] )
    , ( ConnectionAbortedByNetwork, [ "ENETRESET" ] )
    , ( NetworkUnreachable, [ "ENETUNREACH" ] )
    , ( NoBufferSpaceAvailable, [ "ENOBUFS" ] )
    , ( NoDataAvailable, [ "ENODATA" ] )
    , ( NoDevice, [ "ENODEV" ] )
    , ( NoSuchFileOrDirectory, [ "ENOENT" ] )
    , ( ExecuteFormatError, [ "ENOEXEC" ] )
    , ( RequiredKeyNotAvailable, [ "ENOKEY" ] )
    , ( NoLocksAvailable, [ "ENOLCK" ] )
    , ( NoLink, [ "ENOLINK" ] )
    , ( NoMedium, [ "ENOMEDIUM" ] )
    , ( NotEnoughSpace, [ "ENOMEM", "ENOSPC" ] )
    , ( NoMessage, [ "ENOMSG" ] )
    , ( NotOnNetwork, [ "ENONET" ] )
    , ( PackageNotInstalled, [ "ENOPKG" ] )
    , ( ProtocolNotAvailable, [ "ENOPROTOOPT" ] )
    , ( NoStreamResources, [ "ENOSR" ] )
    , ( NotStream, [ "ENOSTR" ] )
    , ( FunctionNotImplemented, [ "ENOSYS" ] )
    , ( BlockDeviceRequired, [ "ENOTBLK" ] )
    , ( SocketNotConnected, [ "ENOTCONN" ] )
    , ( NotADirectory, [ "ENOTDIR" ] )
    , ( DirectoryNotEmpty, [ "ENOTEMPTY" ] )
    , ( NotSocket, [ "ENOTSOCKET" ] )
    , ( OperationNotSupported, [ "ENOTSUP" ] )
    , ( InappropriateIOControlOperation, [ "ENOTTY" ] )
    , ( NameNotUniqueOnNetwork, [ "ENOTUNIQ" ] )
    , ( NoDeviceOrAddress, [ "ENXIO" ] )
    , ( OperationNotSupportedOnSocket, [ "EOPNOTSUPP" ] )
    , ( ValueTooLarge, [ "EOVERFLOW" ] )
    , ( OperationNotPermitted, [ " EPERM" ] )
    , ( ProtocolFamilyNotAvailable, [ "EPFNOSUPPORT" ] )
    , ( BrokenPipe, [ "EPIPE" ] )
    , ( Protocol, [ "EPROTO" ] )
    , ( ProtocolNotSupported, [ "EPROTONOSUPPORT" ] )
    , ( WrongProtocolForSocket, [ "EPROTOTYPE" ] )
    , ( ResultTooLarge, [ "ERANGE" ] )
    , ( RemoteAddressChanged, [ "EREMCHG" ] )
    , ( ObjectRemote, [ "EREMOTE" ] )
    , ( RemoteIO, [ "EREMOTEIO" ] )
    , ( RestartCall, [ "ERESTART" ] )
    , ( ReadOnlyFileSystem, [ "EROFS" ] )
    , ( TransportEndpointShutdown, [ "ESHUTDOWN" ] )
    , ( InvalidSeek, [ "ESPIPE" ] )
    , ( SocketNotSupported, [ "ESOCKTNOSUPPORT" ] )
    , ( NoProcess, [ "ESRCH" ] )
    , ( StaleFileHandle, [ "ESTALE" ] )
    , ( StreamPipe, [ "ESTRPIPE" ] )
    , ( TimerExpired, [ "ETIME" ] )
    , ( ConnectionTimedOut, [ "ETIMEOUT" ] )
    , ( TextFileBusy, [ "ETXTBUSY" ] )
    , ( StructureNeedsCleaning, [ "EUCLEAN" ] )
    , ( ProtocolDriverNotAttached, [ "EUNATCH" ] )
    , ( TooManyUsers, [ "EUSERS" ] )
    , ( OperationWouldBlock, [ "EWOULDBLOCK" ] )
    , ( ImproperLink, [ "EXDEV" ] )
    , ( ExchangeFull, [ "EXFULL" ] )
    ]


codeFromString : String -> Result String Code
codeFromString string =
    List.find (Tuple.second >> List.member string) codeMap
        |> Maybe.map (Tuple.first >> Ok)
        |> Maybe.withDefault (Err <| "Unrecognized system error code: " ++ string)
