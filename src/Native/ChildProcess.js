const _elm_node$core$Native_ChildProcess = function () {
    const ChildProcess = require("child_process")
    const Just = _elm_lang$core$Maybe$Just
    const Nothing = _elm_lang$core$Maybe$Nothing
    const { fromList, toJSArray } = _elm_lang$core$Native_Array
    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler
    const { Tuple2 } = _elm_lang$core$Native_Utils


    // spawn : String -> List String -> Bool -> Task Decode.Value (Maybe Int, Maybe String)
    const spawn = F3((command, argsList, silent) => nativeBinding(callback => {
        try {
            const args = toJSArray(fromList(argsList))
            const subprocess = ChildProcess.spawn(command, args)
            if (!silent) {
                subprocess.stderr.pipe(process.stderr)
                subprocess.stdout.pipe(process.stdout)
            }
            // error: process could not be spawned ...
            let error
            subprocess.on("error", error2 => {
                try {
                    error = error2
                } catch (error3) { error = error3 }
            })
            // close: all io streams closed, always emitted after error ...
            // one of code or signal will be non-null
            subprocess.on("close", (code, signal) => {
                try {
                    if (error) return callback(fail(error))
                    return callback(succeed(Tuple2(
                        code === null ? Just(code) : Nothing,
                        signal === null ? Just(signal) : Nothing
                    )))
                } catch (error2) { return callback(fail(error2)) }
            })
        } catch (error) { return callback(fail(error)) }
    }))


    const exports =
        { spawn
        }
    return exports
}()
