const _elm_node$core$Native_FileSystem = function () {
    const fs = require( "fs" )
    const R = require( "ramda" )
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple0 } = _elm_lang$core$Native_Utils


    // INTERNAL


    // octalStringToInt : String -> Int
    const octalStringToInt = string => parseInt(string, 8)


    // toError : Node.Error -> Error
    const toError = error => {
        // errorMap : List ( Error.ctor, List Node.Error.code )
        const errorMap =
            [ [ "PermissionDenied", [ "EACCES" ] ]
            , [ "OperationNotPermitted", [ "EPERM" ] ]
            , [ "NoSuchFileOrDirectory", [ "ENOENT" ] ]
            , [ "NotADirectory", [ "ENOTDIR" ] ]
            , [ "IsADirectory", [ "EISDIR" ] ]
            , [ "DirectoryNotEmpty", [ "ENOTEMPTY" ] ]
            , [ "FileExists", [ "EEEXIST" ] ]
            , [ "FileTooLarge", [ "EFBIG" ] ]
            , [ "FilenameTooLong", [ "ENAMETOOLONG" ] ]
            , [ "TooManyOpenFiles", [ "EMFILE", "ENFILE" ] ]
            , [ "NotEnoughSpace", [ "ENOMEM", "ENOSPC" ] ]
            , [ "DiskQuotaExceeded", [ "EDQUOT" ] ]
            , [ "ReadOnlyFileSystem", [ "EROFS" ] ]
            ]
        const generic = "Error"
        const ctor = R.find(item => R.contains(error.code, item[1]), errorMap)
        return ctor ? { ctor } : { ctor : generic, _0 : error.message }
    }


    // READ


    const readFile = (filename, encoding) => nativeBinding(callback => {
        try {
            fs.readFile(filename, encoding, (error, data) => {
                if (error) return callback(fail(toError(error)))
                return callback(succeed(data))
            })
        } catch (error) { callback(fail(toError(error))) }
    })


    // readFileAsString : String -> Encoding -> Task Error String
    const readFileAsString = F2(readFile)


    // readFileAsBuffer : String -> Task Error Buffer
    const readFileAsBuffer = filename => readFile(filename, null)


    // WRITE


    const writeFile = (filename, mode, encoding, data) => nativeBinding(callback => {
        try {
            const options =
                { encoding : encoding
                , mode : octalStringToInt(mode)
                }
            fs.writeFile(filename, data, options, error => {
                if (error) return callback(fail(toError(error)))
                return callback(succeed(Tuple0))
            })
        } catch (error) { return callback(fail(toError(error))) }
    })


    // writeFileFromString : String -> String -> String -> String -> Task Error ()
    const writeFileFromString = F4(writeFile)


    // writeFileFromBuffer : String -> String -> Buffer -> Task Error ()
    const writeFileFromBuffer = F3((filename, mode, buffer) => writeFile(filename, mode, null, buffer))


    const exports =
        { readFileAsString
        , readFileAsBuffer
        , writeFileFromString
        , writeFileFromBuffer
        }
    return exports
}()
