const _elm_node$core$Native_Path = function () {
    const { fromList, toJSArray } = _elm_lang$core$Native_Array
    const path = require("path")


    // basename : String -> String
    const basename = path.basename


    // delimiter : String
    const delimiter = path.delimiter


    // dirname : String -> String
    const dirname = path.dirname


    // extname : String -> String
    const extname = path.extname


    // join : List String -> String
    const join = list => path.join.apply(path, toJSArray(fromList(list)))


    // sep : String
    const sep = path.sep


    const exports =
        { basename
        , delimiter
        , dirname
        , extname
        , join
        , sep
        }
    return exports
}()
