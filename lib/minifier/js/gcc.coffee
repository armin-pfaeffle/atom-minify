{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class GccMinifier extends BaseMinifier

    getName: ()->
        return 'Google Closure Compiler'


    minify: (inputFilename, outputFilename, options, callback) ->
        minified = undefined
        error = undefined

        @checkJavaInstalled((javaIsInstalled, version) =>
            if not javaIsInstalled
                error = 'You need to install Java in order to use Google Closure Compiler.'
                callback(minified, error)
            else
                exec = require('child_process').exec
                command = 'java -server -XX:+TieredCompilation -jar -Xss2048k "' + __dirname + '/../_bin/gcc-20150609.jar" --js "' + inputFilename + '" --js_output_file "' + outputFilename + '"'
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
