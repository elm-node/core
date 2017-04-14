const _elm_node$core$Native_Buffer = function () {
    const { StringDecoder } = require( "string_decoder" )
    const Result =
        { Ok : value => ({ ctor : "Ok", _0 : value })
        , Err : error => ({ ctor : "Err", _0 : error })
        }

    // toString : Encoding -> Buffer -> Result String String
    const toString = F2((encoding, buffer) => {
        try {
            const decoder = new StringDecoder(encoding)
            const string = decoder.end(buffer)
            return Result.Ok(string)
        } catch (error) { return Result.Err(error.message) }
    })

    const exports =
        { toString
        }
    return exports
}()
