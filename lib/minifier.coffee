{Emitter} = require('event-kit')
AtomMinifyOptions = require('./options')

module.exports =
class AtomMinifier

    @MINIFY_DIRECT = 'direct'
    @MINIFY_TO_MIN_FILE = 'to-min-file'

    defaultOutputFilenamePattern = '$1.min.$2'


    constructor: (options) ->
        @options = options
        @emitter = new Emitter()


    # If filename is null then active text editor is used for minification
    minify: (mode, minifyOnSave = false, filename = null) ->
        @mode = mode

        if @detectContentType(minifyOnSave)
            # If a file should be minified to another, the file must be saved, else only direct
            # minifcation is available. The reason for this is that building a minified filename
            # is based on the existant filename
            if @isMinifyToFile() and not @ensureFileIsSaved()
                return

            inputFilename = @getInputFilename(filename)
            outputFilename = @getOutputFilename(inputFilename)

            minifier = @getMinifier()
            try
                @emitter.emit('start', {isMinifyToFile: @isMinifyToFile(), isMinifyDirect: @isMinifyDirect(), contentType: @contentType, minifierName: minifier.getName(), inputFilename: inputFilename, outputFilename: outputFilename })

                startTimestamp = new Date().getTime()
                minifier.minify(inputFilename, outputFilename, @options, (minifiedText, error) =>
                    statistics =
                        duration: new Date().getTime() - startTimestamp

                    # Delete temporary created file, even if there was an error
                    if @isMinifyDirect()
                        @deleteTemporaryFiles([inputFilename, outputFilename])

                    if error
                        @emitter.emit('error', {error: error, isMinifyToFile: @isMinifyToFile(), isMinifyDirect: @isMinifyDirect(), contentType: @contentType, minifierName: minifier.getName(), inputFilename: inputFilename, outputFilename: outputFilename })
                    else
                        if @isMinifyDirect()
                            # Calc saving BEFORE we edit the text editors text
                            statistics.before = atom.workspace.getActiveTextEditor().getText().length
                            statistics.after = minifiedText.length

                            # Apply text but do NOT save it
                            atom.workspace.getActiveTextEditor().setText(minifiedText)
                        else
                            statistics.before = @getFileSizeInByte(inputFilename)
                            statistics.after = @getFileSizeInByte(outputFilename)

                        @emitter.emit('success', {statistics: statistics, isMinifyToFile: @isMinifyToFile(), isMinifyDirect: @isMinifyDirect(), contentType: @contentType, minifierName: minifier.getName(), inputFilename: inputFilename, outputFilename: outputFilename })
                )
            catch e
                error = e.toString()
                @emitter.emit('error', {error: error, isMinifyToFile: @isMinifyToFile, isMinifyDirect: @isMinifyDirect, contentType: @contentType, minifierName: minifier.getName(), inputFilename: inputFilename, outputFilename: outputFilename })


    detectContentType: (minifyOnSave) ->
        @contentType = null

        activeEditor = atom.workspace.getActiveTextEditor()
        if activeEditor and activeEditor.getURI
            path = require('path')
            filename = activeEditor.getURI()
            fileExtension = path.extname(filename).toLowerCase()

            # Detect content type by file extension or ask user
            # BUT we only ask the user to select content type, if minification is not startet via
            # saving file
            switch fileExtension
                when '.css' then @contentType = 'css'
                when '.js' then @contentType = 'js'
                else
                    if not minifyOnSave
                        result = atom.confirm
                            message: "Can not detect content type. Tell me which minifier should be used for minification?"
                            buttons: ["Cancel", "CSS", "JS"]
                        switch result
                            when 1 then @contentType = 'css'
                            when 2 then @contentType = 'js'

        return @contentType isnt null


    ensureFileIsSaved: () ->
        activeEditor = atom.workspace.getActiveTextEditor()
        if activeEditor.isModified()
            result = atom.confirm
                message: "'#{activeEditor.getTitle()}' has changes, do you want to save them?"
                detailedMessage: 'In order to minify a file you have to save changes.'
                buttons: ["Save and minify", "Cancel"]
            if result is 0
                activeEditor.save()
            return result is 0
        else
            return true


    getInputFilename: (filename = null) ->
        activeEditor = atom.workspace.getActiveTextEditor()
        if @isMinifyDirect()
            fs = require('fs')
            inputFilename = @getTemporaryFilename('input')
            fs.writeFileSync(inputFilename, activeEditor.getText())
        else
            inputFilename = if filename then filename else activeEditor.getURI()

        return inputFilename


    getOutputFilename: (filename) ->
        if @isMinifyDirect()
            minifiedFilename = @getTemporaryFilename('output')
        else
            path = require('path')
            basename = path.basename(filename)
            # we need the file extension without the dot!
            fileExtension = path.extname(basename).replace('.', '')

            switch @contentType
                when 'css' then pattern = @options.cssMinifiedFilenamePattern
                when 'js' then pattern = @options.jsMinifiedFilenamePattern
                else pattern = @defaultOutputFilenamePattern
            basename = basename.replace(new RegExp('^(.*?)\.(' + fileExtension + ')$', 'gi'), pattern)

            # If there is no file extension at the source filename, we add the correct extension to
            # the output filename
            if fileExtension is ''
                basename += @contentType

            minifiedFilename = path.join(path.dirname(filename), basename)

        return minifiedFilename


    getTemporaryFilename: (filenameAddition) ->
        os = require('os')
        path = require('path')
        uuid = require('node-uuid')
        uniqueId = uuid.v4()
        filename = "atom-minify.#{uniqueId}.#{filenameAddition}.tmp"
        filename = path.join(os.tmpdir(), filename)
        return filename


    deleteTemporaryFiles: (files) ->
        fs = require('fs')
        for file in files
            if fs.existsSync
                fs.unlinkSync(file)


    getMinifier: () ->
        switch @contentType
            when 'css' then moduleName = @options.cssMinifier
            when 'js' then moduleName = @options.jsMinifier

        minifierClass = require("./minifier/#{@contentType}/#{moduleName}")
        minifier = new minifierClass()

        return minifier


    isMinifyDirect: ->
        return @mode is AtomMinifier.MINIFY_DIRECT


    isMinifyToFile: ->
        return @mode is AtomMinifier.MINIFY_TO_MIN_FILE


    getFileSizeInByte: (filename) ->
        fs = require('fs')
        statistics = fs.statSync(filename)
        fileSize = statistics['size']
        return fileSize


    onStart: (callback) ->
        @emitter.on 'start', callback


    onError: (callback) ->
        @emitter.on 'error', callback


    onSuccess: (callback) ->
        @emitter.on 'success', callback
