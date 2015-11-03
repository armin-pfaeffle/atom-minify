class BaseMinifier

    constructor: (options) ->
        @options = options


    checkJavaInstalled: (callback) ->
        exec = require('child_process').exec

        java = if @options.absoluteJavaPath then '"' + @options.absoluteJavaPath + '"' else 'java'
        command = java + ' -version'

        result = exec command, {}, (err, stdout, stderr) ->
            isInstalled = err is null
            version = undefined
            if isInstalled
                matches = stderr.match(/"(.+?)"/)
                if matches
                    version = matches[1]
            callback(isInstalled, version)



module.exports.BaseMinifier = BaseMinifier
