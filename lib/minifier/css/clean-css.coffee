{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class CleanCssMinifier extends BaseMinifier

    getName: ()->
        return 'clean-css'


    minify: (inputFilename, outputFilename, options, callback) ->
        minified = undefined
        error = undefined

        fs = require('fs')
        CleanCSS = require('clean-css')

        # read file content because CleanCSS cannot handle files
        css = fs.readFileSync(inputFilename).toString()
        result = new CleanCSS().minify(css)

        if result.errors.length == 0
            minified = result.styles
            fs.writeFileSync(outputFilename, minified, "utf8")
        else
            error = result.errors.join("\n")

        callback(minified, error)
