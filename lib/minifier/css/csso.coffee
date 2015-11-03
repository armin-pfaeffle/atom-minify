{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class CssoMinifier extends BaseMinifier

    getName: ()->
        return 'CSSO'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        fs = require('fs')
        csso = require('csso')

        # read file content because CSSO cannot handle files
        css = fs.readFileSync(inputFilename).toString()

        try
            # TODO Use csso.justDoIt(css, true) to turn structure minimization off.
            minified = csso.justDoIt(css)
        catch e
            error = e.message

        if minified
            fs.writeFileSync(outputFilename, minified, "utf8")

        callback(minified, error)
