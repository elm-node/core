const _elm_node$core$Native_OperatingSystem = function () {
    const Err = _elm_lang$core$Result$Err
    const Ok = _elm_lang$core$Result$Ok
    const os = require("os")


    // homedir : String
    const homedir = os.homedir()


    // platform : String
    const platform = os.platform()


    // tmpdir : String
    const tmpdir = os.tmpdir()


    const exports =
        { homedir
        , platform
        , tmpdir
        }
    return exports
}()
