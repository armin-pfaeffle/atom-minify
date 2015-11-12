{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class CleanCssMinifier extends BaseMinifier

    getName: ()->
        return 'clean-css'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        fs = require('fs')
        CleanCSS = require('clean-css')

        minifierOptions = @prepareMinifierOptions()

        # read file content because CleanCSS cannot handle files
        css = fs.readFileSync(inputFilename).toString()
        result = new CleanCSS(minifierOptions).minify(css)

        if result.errors.length == 0
            minified = result.styles
            fs.writeFileSync(outputFilename, minified, "utf8")
        else
            error = result.errors.join("\n")

        callback(minified, error)


    prepareMinifierOptions: ->
        options = []

        if @options.minifierOptions.advanced isnt undefined
            options.advanced = @options.minifierOptions.advanced

        if @options.minifierOptions.aggressiveMerging isnt undefined
            options.aggressiveMerging = @options.minifierOptions.aggressiveMerging

        if @options.minifierOptions.compatibility isnt undefined
            options.compatibility = @options.minifierOptions.compatibility

        if @options.minifierOptions.inliner isnt undefined
            options.inliner = @options.minifierOptions.inliner

        if @options.minifierOptions.keepBreaks isnt undefined
            options.keepBreaks = @options.minifierOptions.keepBreaks

        if @options.minifierOptions.keepSpecialComments isnt undefined
            options.keepSpecialComments = @options.minifierOptions.keepSpecialComments

        if @options.minifierOptions.mediaMerging isnt undefined
            options.mediaMerging = @options.minifierOptions.mediaMerging

        if @options.minifierOptions.processImport isnt undefined
            options.processImport = @options.minifierOptions.processImport

        if @options.minifierOptions.processImportFrom isnt undefined
            options.processImportFrom = @options.minifierOptions.processImportFrom

        if @options.minifierOptions.rebase isnt undefined
            options.rebase = @options.minifierOptions.rebase

        if @options.minifierOptions.relativeTo isnt undefined
            options.relativeTo = @options.minifierOptions.relativeTo

        if @options.minifierOptions.restructuring isnt undefined
            options.restructuring = @options.minifierOptions.restructuring

        if @options.minifierOptions.root isnt undefined
            options.root = @options.minifierOptions.root

        if @options.minifierOptions.roundingPrecision isnt undefined
            options.roundingPrecision = @options.minifierOptions.roundingPrecision

        if @options.minifierOptions.semanticMerging isnt undefined
            options.semanticMerging = @options.minifierOptions.semanticMerging

        if @options.minifierOptions.shorthandCompacting isnt undefined
            options.shorthandCompacting = @options.minifierOptions.shorthandCompacting

        if @options.minifierOptions.sourceMap isnt undefined
            options.sourceMap = @options.minifierOptions.sourceMap

        if @options.minifierOptions.sourceMapInlineSources isnt undefined
            options.sourceMapInlineSources = @options.minifierOptions.sourceMapInlineSources

        if @options.minifierOptions.target isnt undefined
            options.target = @options.minifierOptions.target

        return options
