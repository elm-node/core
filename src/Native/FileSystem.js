const _elm_node$core$Native_FileSystem = (_ => {
    const cpr = require( "cpr" )
    const fs = require( "fs" )
    const mkdirp_ = require("mkdirp")
    const path = require("path")
    const rm = require("rimraf")
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple0 } = _elm_lang$core$Native_Utils


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


    // readFile : String -> Task Decode.Value Buffer
    const readFile = filename => nativeBinding(callback => {
        try {
            fs.readFile(filename, (error, buffer) => {
                if (error) return callback(fail(error))
                return callback(succeed(buffer))
            })
        } catch (error) { return callback(fail(error)) }
    })


    // remove : String -> Task Decode.Value ()
    const remove = filename => nativeBinding(callback => {
        try {
            rm(filename, error => {
                if (error) return callback(fail(error))
                return callback(succeed(Tuple0))
            })
        } catch (error) { return callback(fail(error)) }
    })


    // writeFile : String -> Int -> Buffer -> Task Decode.Value ()
    const writeFile = F3((filename, mode, buffer) => nativeBinding(callback => {
        try {
            const options = { mode }
            fs.writeFile(filename, buffer, options, error => {
                if (error) return callback(fail(error))
                return callback(succeed(Tuple0))
            })
        } catch (error) { return callback(fail(error)) }
    }))


    // exists : String -> Task Decode.Value Bool
    const exists = filename => nativeBinding(callback => {
        try {
            fs.access(filename, fs.constants.F_OK, err => callback(err ? succeed(false) : succeed(true)))
        }
        catch (error) { return callback(fail(error)) }
    })


    // mkdirp : String -> Task Decode.Value ()
    const mkdirp = filename => nativeBinding(callback => {
        try {
            mkdirp_(filename, error => callback(error ? fail(error) : succeed(Tuple0)))
        }
        catch (error) { return callback(fail(error)) }
    })


    // rename : String -> String -> Task Decode.Value ()
    const rename = F2((from, to) => nativeBinding(callback => {
        try {
            fs.rename(from, to, error => callback(error ? fail(error) : succeed(Tuple0)))
        }
        catch (error) { return callback(fail(error)) }
    }))


    // isSymlink : String -> Task Decode.Value Bool
    const isSymlink = filename => nativeBinding(callback => {
        try {
            fs.lstat(filename, (error, stats) => callback(error ? fail(error) : succeed(stats.isSymbolicLink())))
        }
        catch (error) { return callback(fail(error)) }
    })


    // symlink : String -> String -> Task Decode.Value ()
    const symlink = F2((target, filename) => nativeBinding(callback => {
        try {
            fs.symlink(target, filename, error => callback(error ? fail(error) : succeed(Tuple0)))
        }
        catch (error) { return callback(fail(error)) }
    }))


    const exports =
        { copy
        , exists
        , isSymlink
        , symlink
        , mkdirp
        , readFile
        , remove
        , rename
        , writeFile
        }
    return exports
})()
