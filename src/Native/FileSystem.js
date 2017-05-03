const _elm_node$core$Native_FileSystem = function () {
    const cpr = require( "cpr" )
    const fs = require( "fs" )
    const mkdirp = require("mkdirp")
    const path = require("path")
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple0 } = _elm_lang$core$Native_Utils


    // INTERNAL


    // octalStringToInt : String -> Int
    const octalStringToInt = string => parseInt(string, 8)


    // COPY


    // copy : String -> String -> Task Decode.Value Decode.Value
    const copy = F2((to, from) => nativeBinding(callback => {
        const extractFilename = message => {
            const match = (/(?:File ){0,1}(.*) exists/).exec(message)
            return match ? match[1] : null
        }
        try {
            cpr(from, to, (error, files) => {
                // single file case
                if (error && !files) {
                    const filename = extractFilename(error.message)
                    if (filename) return callback(succeed({ errors : [ error ], files : [ filename ] }))
                    return callback(fail(error))
                }
                // multiple file case
                if (error && files) return callback(succeed({ errors : error.list, files }))
                // copying a single file with no errors returns files and error undefined ...
                return callback(succeed({ errors : [], files : files || [ to ] }))
            })
        } catch (error) { callback(fail(error)) }
    }))


    // READ


    const readFile = (filename, encoding) => nativeBinding(callback => {
        try {
            fs.readFile(filename, encoding, (error, data) => {
                if (error) return callback(fail(error))
                return callback(succeed(data))
            })
        } catch (error) { callback(fail(error)) }
    })


    // readFileAsString : String -> String -> Task Decode.Value String
    const readFileAsString = F2(readFile)


    // readFileAsBuffer : String -> Task Decode.Value Buffer
    const readFileAsBuffer = filename => readFile(filename, null)


    // WRITE


    const writeFile = (filename, mode, encoding, data) => nativeBinding(callback => {
        try {
            const options =
                { encoding : encoding
                , mode : octalStringToInt(mode)
                }
            // TODO mkdirp first
            // then writeFile
            const dirname = path.dirname(filename)
            mkdirp(dirname, error => {
                if (error) return callback(fail(error))
                fs.writeFile(filename, data, options, error => {
                    if (error) return callback(fail(error))
                    return callback(succeed(Tuple0))
                })
            })
        } catch (error) { return callback(fail(error)) }
    })


    // writeFileFromString : String -> String -> String -> String -> Task Decode.Value ()
    const writeFileFromString = F4(writeFile)


    // writeFileFromBuffer : String -> String -> Buffer -> Task Decode.Value ()
    const writeFileFromBuffer = F3((filename, mode, buffer) => writeFile(filename, mode, null, buffer))


    const exports =
        { copy
        , readFileAsString
        , readFileAsBuffer
        , writeFileFromString
        , writeFileFromBuffer
        }
    return exports
}()
