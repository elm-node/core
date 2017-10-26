const _elm_node$core$Native_Process = function () {
    if (!process) throw Error("Process requires a Node.js compatible runtime: `process` global not found.")


    const { nativeBinding, succeed, fail } = _elm_lang$core$Native_Scheduler


    // cwd : () -> Task Decode.Value String
    const cwd = () => nativeBinding(callback => {
        // NOT pure since cwd can be changed by `process.chdir` => Task
        try {
            const dirname = process.cwd()
            return callback(succeed(dirname))
        } catch (error) { return callback(fail(error)) }
    })


    // env : Decode.Value
    const env = process.env


    const exports =
        { cwd
        , env
        }
    return exports
}()
