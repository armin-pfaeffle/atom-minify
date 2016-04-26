{BaseMinifier} = require('./../BaseMinifier.coffee')
{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'


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
            structureMinimizationOff  = @options.minifierOptions.restructureOff
            allowUnsafeNewFunction () =>
                minified = csso.justDoIt(css, structureMinimizationOff)
        catch e
            error = e.message

        if minified
            fs.writeFileSync(outputFilename, minified, "utf8")

        callback(minified, error)
