const _elm_node$core$Native_FileSystem = (_ => {
    const cpr = require( "cpr" )
    const fs = require( "fs" )
    const mkdirp = require("mkdirp")
    const path = require("path")
    const rm = require("rimraf")
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple0 } = _elm_lang$core$Native_Utils


    // COPY


    // copy : Bool -> String -> String -> Task Decode.Value Decode.Value
    const copy = F3((overwrite, to, from) => nativeBinding(callback => {
        const extractFilename = message => {
            const match = (/(?:File ){0,1}(.*) exists/).exec(message)
            return match ? match[1] : null
        }
        try {
            cpr(from, to, { overwrite }, (error, files) => {
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
        } catch (error) { return callback(fail(error)) }
    }))


    // READ


    const readFile = (filename, encoding) => nativeBinding(callback => {
        try {
            fs.readFile(filename, encoding, (error, data) => {
                if (error) return callback(fail(error))
                return callback(succeed(data))
            })
        } catch (error) { return callback(fail(error)) }
    })


    // readFileAsString : String -> String -> Task Decode.Value String
    const readFileAsString = F2(readFile)


    // readFileAsBuffer : String -> Task Decode.Value Buffer
    const readFileAsBuffer = filename => readFile(filename, null)


    // REMOVE


    // remove : String -> Task Decode.Value ()
    const remove = filename => nativeBinding(callback => {
        try {
            rm(filename, error => {
                if (error) return callback(fail(error))
                return callback(succeed(Tuple0))
            })
        } catch (error) { return callback(fail(error)) }
    })


    // WRITE


    const writeFile = (filename, mode, encoding, data) => nativeBinding(callback => {
        const octalStringToInt = string => parseInt(string, 8)
        try {
            const dirname = path.dirname(filename)
            mkdirp(dirname, error => {
                if (error) return callback(fail(error))
                const options =
                    { encoding : encoding
                    , mode : octalStringToInt(mode)
                    }
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

    const exists = filename => nativeBinding(callback => {
        try {
            fs.access(filename, fs.constants.F_OK, err => callback(err ? succeed(false) : succeed(true)))
        }
        catch (error) { return callback(fail(error)) }
    })

    const mkdirp_ = filename => nativeBinding(callback => {
        try {
            mkdirp(filename, err => callback(err ? fail(err) : succeed()))
        }
        catch (error) { return callback(fail(error)) }
    })

    const rename = F2((from, to) => nativeBinding(callback => {
        try {
            fs.rename(from, to, err => callback(err ? fail(err) : succeed()))
        }
        catch (error) { return callback(fail(error)) }
    }))

    const isSymlink = filename => nativeBinding(callback => {
        try {
            fs.lstat(filename, (err, stats) => callback(err ? fail(err) : succeed(stats.isSymbolicLink())))
        }
        catch (error) { return callback(fail(error)) }
    })

    const makeSymlink = F3((target, filename, type) => nativeBinding(callback => {
        try {
            fs.symlink(target, filename, type, err => callback(err ? fail(err) : succeed()))
        }
        catch (error) { return callback(fail(error)) }
    }))

    const exports =
        { copy
        , exists
        , isSymlink
        , makeSymlink : makeSymlink
        , mkdirp : mkdirp_
        , readFileAsString
        , readFileAsBuffer
        , remove
        , rename : rename
        , writeFileFromString
        , writeFileFromBuffer
        }
    return exports
})()
