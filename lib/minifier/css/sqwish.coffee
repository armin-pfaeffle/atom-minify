{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class SqwishMinifier extends BaseMinifier

    getName: ()->
        return 'Sqwish'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        fs = require('fs')
        sqwish = require('sqwish')

        # read file content because CleanCSS cannot handle files
        css = fs.readFileSync(inputFilename).toString()

        try
            strictMode = @options.minifierOptions.strict
            minified = sqwish.minify(css, strictMode)
        catch e
            error = e.message

        if minified
            fs.writeFileSync(outputFilename, minified, "utf8")

        callback(minified, error)
