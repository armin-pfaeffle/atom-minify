# Because of an Windows issue (https://github.com/yui/yuicompressor/issues/78), we have to use
# version 2.4.7 instead of 2.4.8.

{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class YuiJsMinifier extends BaseMinifier

    getName: ()->
        return 'YUI Compressor'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        @checkJavaInstalled (javaIsInstalled, version) =>
            if not javaIsInstalled
                error = 'You need to install Java in order to use YUI compressor or set a correct path to Java exectuable in options.'
                callback(minified, error)
            else
                exec = require('child_process').exec

                java = if @options.absoluteJavaPath then '"' + @options.absoluteJavaPath + '"' else 'java'
                command = java + ' -jar -Xss2048k "' + __dirname + '/../_bin/yuicompressor-2.4.7.jar"'

                minifierOptions = @prepareMinifierOptions()
                command += ' ' + minifierOptions

                command += ' --type js'
                command += ' -o "' + outputFilename + '"'
                command += ' "' + inputFilename + '"'

                exec command,
                    maxBuffer: @options.buffer,
                    (err, stdout, stderr) =>
                        if err
                            error = err.toString()
                        else
                            fs = require('fs')
                            minified = fs.readFileSync(outputFilename).toString()

                        callback(minified, error)


    prepareMinifierOptions: () ->
        options = ''

        if @options.minifierOptions.charset isnt undefined
            options += ' --charset ' + @options.minifierOptions.charset

        if @options.minifierOptions['line-break'] isnt undefined
            options += ' --line-break ' + @options.minifierOptions['line-break']

        if @options.minifierOptions.nomunge isnt undefined
            options += ' --nomunge'

        if @options.minifierOptions['preserve-semi'] isnt undefined
            options += ' --preserve-semi'
            options += ' --nomunge'

        if @options.minifierOptions['disable-optimizations'] isnt undefined
            options += ' --disable-optimizations'

        return options
