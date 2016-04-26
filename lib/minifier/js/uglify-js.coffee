{BaseMinifier} = require('./../BaseMinifier.coffee')
{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

fs = require('fs')
path = require('path')


module.exports =
class UglifyJsMinifier extends BaseMinifier

    getName: ()->
        return 'UglifyJS2'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        minifierOptions = @prepareMinifierOptions()
        result = null

        allowUnsafeNewFunction () =>
            uglifyJs = require('uglify-js')
            @prepareSourceMap(minifierOptions)
            result = uglifyJs.minify(inputFilename, minifierOptions)

        if not result.error
            minified = result.code
            fs.writeFileSync(outputFilename, minified, "utf8")

            if @sourceMap isnt undefined
                @writeSourceMap(inputFilename, outputFilename)
        else
            error = result.error

        callback(minified, error)


    prepareMinifierOptions: () ->
        options = {}
        options.output = null
        options.compress = {}

        if @options.minifierOptions.mangle isnt undefined
            options.mangle = @options.minifierOptions.mangle


        # Output options

        if @options.minifierOptions.indent_start isnt undefined
            options.output || options.output = {}
            options.output.indent_start = @options.minifierOptions.indent_start

        if @options.minifierOptions.indent_level isnt undefined
            options.output || options.output = {}
            options.output.indent_level = @options.minifierOptions.indent_level

        if @options.minifierOptions.quote_keys isnt undefined
            options.output || options.output = {}
            options.output.quote_keys = @options.minifierOptions.quote_keys

        if @options.minifierOptions.space_colon isnt undefined
            options.output || options.output = {}
            options.output.space_colon = @options.minifierOptions.space_colon

        if @options.minifierOptions.ascii_only isnt undefined
            options.output || options.output = {}
            options.output.ascii_only = @options.minifierOptions.ascii_only



        if @options.minifierOptions.inline_script isnt undefined
            options.output || options.output = {}
            options.output.inline_script = @options.minifierOptions.inline_script

        if @options.minifierOptions.width isnt undefined
            options.output || options.output = {}
            options.output.width = @options.minifierOptions.width

        if @options.minifierOptions.max_line_len isnt undefined
            options.output || options.output = {}
            options.output.max_line_len = @options.minifierOptions.max_line_len

        if @options.minifierOptions.ie_proof isnt undefined
            options.output || options.output = {}
            options.output.ie_proof = @options.minifierOptions.ie_proof

        if @options.minifierOptions.beautify isnt undefined
            options.output || options.output = {}
            options.output.beautify = @options.minifierOptions.beautify

        if @options.minifierOptions.bracketize isnt undefined
            options.output || options.output = {}
            options.output.bracketize = @options.minifierOptions.bracketize

        if @options.minifierOptions.comments isnt undefined
            options.output || options.output = {}
            options.output.comments = @options.minifierOptions.comments

        if @options.minifierOptions.semicolons isnt undefined
            options.output || options.output = {}
            options.output.semicolons = @options.minifierOptions.semicolons


        # Compress options

        if @options.minifierOptions.compress is false
            options.compress = false

        else
            if @options.minifierOptions.sequences isnt undefined
                options.compress.sequences = @options.minifierOptions.sequences

            if @options.minifierOptions.properties isnt undefined
                options.compress.properties = @options.minifierOptions.properties

            if @options.minifierOptions.dead_code isnt undefined
                options.compress.dead_code = @options.minifierOptions.dead_code

            if @options.minifierOptions.drop_debugger isnt undefined
                options.compress.drop_debugger = @options.minifierOptions.drop_debugger

            if @options.minifierOptions.unsafe isnt undefined
                options.compress.unsafe = @options.minifierOptions.unsafe

            if @options.minifierOptions.conditionals isnt undefined
                options.compress.conditionals = @options.minifierOptions.conditionals

            if @options.minifierOptions.comparisons isnt undefined
                options.compress.comparisons = @options.minifierOptions.comparisons

            if @options.minifierOptions.evaluate isnt undefined
                options.compress.evaluate = @options.minifierOptions.evaluate

            if @options.minifierOptions.booleans isnt undefined
                options.compress.booleans = @options.minifierOptions.booleans

            if @options.minifierOptions.loops isnt undefined
                options.compress.loops = @options.minifierOptions.loops

            if @options.minifierOptions.unused isnt undefined
                options.compress.unused = @options.minifierOptions.unused

            if @options.minifierOptions.hoist_funs isnt undefined
                options.compress.hoist_funs = @options.minifierOptions.hoist_funs

            if @options.minifierOptions.hoist_vars isnt undefined
                options.compress.hoist_vars = @options.minifierOptions.hoist_vars

            if @options.minifierOptions.if_return isnt undefined
                options.compress.if_return = @options.minifierOptions.if_return

            if @options.minifierOptions.join_vars isnt undefined
                options.compress.join_vars = @options.minifierOptions.join_vars

            if @options.minifierOptions.cascade isnt undefined
                options.compress.cascade = @options.minifierOptions.cascade

            if @options.minifierOptions.side_effects isnt undefined
                options.compress.side_effects = @options.minifierOptions.side_effects

            if @options.minifierOptions.warnings isnt undefined
                options.compress.warnings = @options.minifierOptions.warnings

            if @options.minifierOptions.global_defs isnt undefined
                options.compress.global_defs = @options.minifierOptions.global_defs

        return options


    prepareSourceMap: (minifierOptions) ->
        if @options.minifierOptions.source_map isnt undefined
            uglifyJs = require('uglify-js')
            @sourceMap = uglifyJs.SourceMap({ file: @options.minifierOptions.source_map })
            minifierOptions.output || minifierOptions.output = {}
            minifierOptions.output.source_map = @sourceMap
        else
            @sourceMap = undefined


    writeSourceMap: (inputFilename, outputFilename) ->
        return unless @sourceMap
        filename = @prepareSourceMapFilename(inputFilename, outputFilename)
        fs.writeFileSync(filename, @sourceMap.toString(), "utf8")


    prepareSourceMapFilename: (inputFilename, outputFilename) ->
        pattern = @options.minifierOptions.source_map
        basename = path.basename(inputFilename)

        # we need the file extension without the dot!
        fileExtension = path.extname(basename).replace('.', '')
        filename = basename.replace(new RegExp('^(.*?)\.(' + fileExtension + ')$', 'gi'), pattern)

        outputPath = path.dirname(outputFilename)
        filename = path.join(outputPath, filename)

        return filename
