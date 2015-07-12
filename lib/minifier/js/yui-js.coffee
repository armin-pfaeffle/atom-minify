# Because of an Windows issue (https://github.com/yui/yuicompressor/issues/78), we have to use
# version 2.4.7 instead of 2.4.8.

{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class YuiJsMinifier extends BaseMinifier

    getName: ()->
        return 'YUI Compressor'


    minify: (inputFilename, outputFilename, options, callback) ->
        minified = undefined
        error = undefined

        @checkJavaInstalled((javaIsInstalled, version) =>
            if not javaIsInstalled
                error = 'You need to install Java in order to use YUI compressor.'
                callback(minified, error)
            else
                exec = require('child_process').exec
                command = 'java -jar -Xss2048k "' + __dirname + '/../_bin/yuicompressor-2.4.7.jar" "' + inputFilename + '" -o "' + outputFilename + '" --type js'
                exec(command,
                    maxBuffer: options.buffer,
                    (err, stdout, stderr) =>
                        if err
                            error = err.toString()
                        else
                            fs = require('fs')
                            minified = fs.readFileSync(outputFilename).toString()

                        callback(minified, error)
                )
        )
