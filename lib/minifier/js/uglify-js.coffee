{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class UglifyJsMinifier extends BaseMinifier

    getName: ()->
        return 'UglifyJS2'


    minify: (inputFilename, outputFilename, options, callback) ->
        minified = undefined
        error = undefined

        uglifyJs = require('uglify-js')
        fs = require('fs')
        result = uglifyJs.minify(inputFilename)

        if not result.error
            minified = result.code
            fs.writeFileSync(outputFilename, minified, "utf8")
        else
            error = result.error

        callback(minified, error)
