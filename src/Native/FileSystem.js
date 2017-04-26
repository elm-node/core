const _elm_node$core$Native_FileSystem = function () {
    const fs = require( "fs" )
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple0 } = _elm_lang$core$Native_Utils


    // INTERNAL


    // octalStringToInt : String -> Int
    const octalStringToInt = string => parseInt(string, 8)


    // READ


    const readFile = (filename, encoding) => nativeBinding(callback => {
        try {
            fs.readFile(filename, encoding, (error, data) => {
                if (error) return callback(fail(error))
                return callback(succeed(data))
            })
        } catch (error) { callback(fail(error)) }
    })


    // readFileAsString : String -> String -> Task Error String
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
                if (error) return callback(fail(error))
                return callback(succeed(Tuple0))
            })
        } catch (error) { return callback(fail(error)) }
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
