const _elm_node$core$Native_OperatingSystem = function () {
    const Err = _elm_lang$core$Result$Err
    const Ok = _elm_lang$core$Result$Ok
    const os = require("os")


    // homedir : Result Decode.Value String
    const homedir = function () {
        try {
            const dirname = os.homedir()
            return Ok(dirname)
        } catch (error) { return Err(error) }
    }()


    // tmpdir : Result Decode.Value String
    const tmpdir = function () {
        try {
            const dirname = os.tmpdir()
            return Ok(dirname)
        } catch (error) { return Err(error) }
    }()


    const exports =
        { homedir
        , tmpdir
        }
    return exports
}()
