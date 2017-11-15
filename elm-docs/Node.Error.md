# Node.Error

Error type.

- [Error](#error)
- [message](#message)
- [decoder](#decoder)
- [fromValue](#fromvalue)
- [Code](#code)

### **type Error**
```elm
type Error   
    = Error String String  
    | SystemError Node.Error.Code { message : String , stack : String , syscall : String , path : Maybe String , address : Maybe String , port_ : Maybe String }
```

Error union type.

---

### **message**
```elm
message : Node.Error.Error -> String
```

Extract the message from an Error.

---

### **decoder**
```elm
decoder : Json.Decode.Decoder Node.Error.Error
```

Error decoder.

---

### **fromValue**
```elm
fromValue : Json.Decode.Value -> Node.Error.Error
```

Decode an Error from a Value.

---

### **type Code**
```elm
type Code   
    = ArgumentListTooLong   
    | PermissionDenied   
    | AddressInUse   
    | AddressNotAvailable   
    | AddressFamilyNotSupported   
    | ResourceTemporarilyUnavailable   
    | ConnectionAlreadyInProgress   
    | InvalidExchange   
    | BadFileDescriptor   
    | FileDescriptorInBadState   
    | BadMessage   
    | InvalidRequestDescriptor   
    | InvalidRequestCode   
    | InvalidSlot   
    | DeviceOrResourceBusy   
    | OperationCancelled   
    | NoChildProcesses   
    | ChannelNumberOutOfRange   
    | CommunicationErrorOnSend   
    | ConnectionAborted   
    | ConnectionRefused   
    | ConnectionReset   
    | ResourceDeadlockAvoided   
    | DestinationAddressRequired   
    | ArgumentOutOfDomain   
    | DiskQuotaExceeded   
    | FileExists   
    | BadAddress   
    | FileTooLarge   
    | HostDown   
    | HostUnreachable   
    | IdentifierRemoved   
    | IllegalByteSequence   
    | OperationInProgress   
    | InteruptedFunctionCall   
    | InvalidArgument   
    | InputOutput   
    | SocketConnected   
    | IsADirectory   
    | NamedTypeFile   
    | KeyExpired   
    | KeyRejected   
    | KeyRevoked   
    | Level2Halted   
    | Level2NotSynchronized   
    | Level3Halted   
    | CannotAccessLibrary   
    | LibraryCorrupted   
    | TooManyLibraries   
    | LibSectionCorrupted   
    | CannotExecuteLibrary   
    | TooManyLevelsOfSymbolicLinks   
    | WrongMediumType   
    | TooManyOpenFiles   
    | TooManyLinks   
    | MessageTooLong   
    | MultihopAttempted   
    | FilenameTooLong   
    | NetworkDown   
    | ConnectionAbortedByNetwork   
    | NetworkUnreachable   
    | NoBufferSpaceAvailable   
    | NoDataAvailable   
    | NoDevice   
    | NoSuchFileOrDirectory   
    | ExecuteFormatError   
    | RequiredKeyNotAvailable   
    | NoLocksAvailable   
    | NoLink   
    | NoMedium   
    | NotEnoughSpace   
    | NoMessage   
    | NotOnNetwork   
    | PackageNotInstalled   
    | ProtocolNotAvailable   
    | NoStreamResources   
    | NotStream   
    | FunctionNotImplemented   
    | BlockDeviceRequired   
    | SocketNotConnected   
    | NotADirectory   
    | DirectoryNotEmpty   
    | NotSocket   
    | OperationNotSupported   
    | InappropriateIOControlOperation   
    | NameNotUniqueOnNetwork   
    | NoDeviceOrAddress   
    | OperationNotSupportedOnSocket   
    | ValueTooLarge   
    | OperationNotPermitted   
    | ProtocolFamilyNotAvailable   
    | BrokenPipe   
    | Protocol   
    | ProtocolNotSupported   
    | WrongProtocolForSocket   
    | ResultTooLarge   
    | RemoteAddressChanged   
    | ObjectRemote   
    | RemoteIO   
    | RestartCall   
    | ReadOnlyFileSystem   
    | TransportEndpointShutdown   
    | InvalidSeek   
    | SocketNotSupported   
    | NoProcess   
    | StaleFileHandle   
    | StreamPipe   
    | TimerExpired   
    | ConnectionTimedOut   
    | TextFileBusy   
    | StructureNeedsCleaning   
    | ProtocolDriverNotAttached   
    | TooManyUsers   
    | OperationWouldBlock   
    | ImproperLink   
    | ExchangeFull 
```

Error code union type.

