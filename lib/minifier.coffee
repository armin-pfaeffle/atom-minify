{Emitter} = require('event-kit')
AtomMinifyOptions = require('./options')
AtomMinifyMinifierOptionsParser = require('./minifier-options-parser')

InlineParameters = require('./helper/inline-parameters')
File = require('./helper/file')

fs = require('fs')
path = require('path')


module.exports =
class AtomMinifier

    @MINIFY_DIRECT = 'direct'
    @MINIFY_TO_MIN_FILE = 'to-min-file'

    defaultOutputFilenamePattern = '$1.min.$2'


    constructor: (options) ->
        @options = options
        @emitter = new Emitter()


    destroy: () ->
        @emitter.dispose()
        @emitter = null


    # If filename is null then active text editor is used for minification
    minify: (mode, minifyOnSave = false, filename = null) ->
        @mode = mode
        @minifyOnSave = minifyOnSave
        @contentType = undefined
        @setupInputFile(filename)

        # If no inputFile.path is given, then we cannot compile the file or content, because something
        # is wrong
        if not @inputFile.path
            @throwMessageAndFinish('error', 'Invalid file: ' + @inputFile.path)
            return

        # Check file existance
        if not fs.existsSync(@inputFile.path)
            @throwMessageAndFinish('error', 'File does not exist: ' + @inputFile.path)
            return

        # If content type cannot automatically be detected, user is asked for content type. If he
        # cancels the request, no content type is given, so we MUST NOT show any messsage, we only
        # throw a finish event.
        if not @detectContentType()
            @emitter.emit('finished', @getBasicEmitterParameters())
            return

        @emitter.emit('start', @getBasicEmitterParameters())

        # If a file should be minified to another, the file must be saved, else only direct
        # minification is available. The reason for this is that building a minified
        # filename is based on the existant filename
        if @isMinifyToFile() and (not @ensureFileIsSaved() or not @checkAlreadyMinifiedFile())
            @throwMessageAndFinish('warning', 'Minification cancelled')
            return

        # Parse inline parameters and run minification :)
        parameters = new InlineParameters()
        parameters.parse @inputFile.path, (params, error) =>
            if error
                @throwMessageAndFinish('error', error)

            else
                @updateOptionsByInlineParameters(params)
                @setupOutputFile()

                if @isMinifyToFile() and not @checkOutputFileAlreadyExists()
                    @emitter.emit('finished', @getBasicEmitterParameters())
                else
                    @ensureOutputDirectoryExists()

                    if @options.compress isnt undefined and @options.compress is false
                        # Only write unminified text if target is a file, else it does not make
                        # any sense
                        if @isMinifyToFile()
                            @writeUnminifiedText()
                        else
                            @throwMessageAndFinish('warning', 'Do you think it makes sense to directly minify to uncompressed code? ;)')
                    else
                        @writeMinifiedText()


    setupInputFile: (filename = null) ->
        @inputFile =
            isTemporary: false

        if filename
            @inputFile.path = filename
        else
            activeEditor = atom.workspace.getActiveTextEditor()
            return unless activeEditor

            if @isMinifyDirect()
                @inputFile.path = File.getTemporaryFilename('atom-minify.input.')
                @inputFile.isTemporary = true
                fs.writeFileSync(@inputFile.path, activeEditor.getText())
            else
                @inputFile.path = activeEditor.getURI()
                if not @inputFile.path
                    @inputFile.path = @askForSavingUnsavedFileInActiveEditor()


    askForSavingUnsavedFileInActiveEditor: () ->
        activeEditor = atom.workspace.getActiveTextEditor()
        dialogResultButton = atom.confirm
            message: "You want to minify a unsaved file to a minified file, but you have to save it before. Do you want to save the file?"
            detailedMessage: "Alternativly you can use 'Direct Minification' for minifying file."
            buttons: ["Save", "Cancel"]
        if dialogResultButton is 0
            filename = atom.showSaveDialogSync()
            try
                activeEditor.saveAs(filename)
            catch error
                # do nothing if something fails because getURI() will return undefined, if
                # file is not saved

            filename = activeEditor.getURI()
            return filename

        return undefined


    detectContentType: ->
        @contentType = undefined

        # We don't return if inputFile.path is empty because user you should be able to minify
        # text of a new opened, but unsaved tab
        if @isMinifyDirect()
            activeEditor = atom.workspace.getActiveTextEditor()
            if activeEditor and activeEditor.getURI()
                filename = activeEditor.getURI()
                if filename and fs.existsSync(filename)
                    fileExtension = path.extname(filename).toLowerCase()
        else if @inputFile.path
            fileExtension = path.extname(@inputFile.path).toLowerCase()

        # Detect content type by file extension or ask user
        # BUT we only ask the user to select content type, if minification is not startet via
        # saving file
        switch fileExtension
            when '.css' then @contentType = 'css'
            when '.js' then @contentType = 'js'
            else
                if not @isMinifyOnSave()
                    @contentType = @askForContentType()

        return @contentType isnt undefined


    askForContentType: () ->
        dialogResultButton = atom.confirm
            message: "Can not detect content type. Tell me which minifier should be used for minification?"
            buttons: ["CSS", "JS", "Cancel"]
        switch dialogResultButton
            when 0 then type = 'css'
            when 1 then type = 'js'
            else type = undefined
        return type


    ensureFileIsSaved: () ->
        editors = atom.workspace.getTextEditors()
        for editor in editors
            if editor and editor.getURI and editor.getURI() is @inputFile.path and editor.isModified()
                filename = path.basename(@inputFile.path)
                dialogResultButton = atom.confirm
                    message: "'#{filename}' has changes, do you want to save them?"
                    detailedMessage: "In order to minify a file you have to save changes."
                    buttons: ["Save and minify", "Cancel"]
                if dialogResultButton is 0
                    editor.save()
                    break
                else
                    return false

        return true


    checkAlreadyMinifiedFile: () ->
        if @options.checkAlreadyMinifiedFile
            if /\.(?:min|minified|compressed)\./i.exec(@inputFile.path) isnt null
                dialogResultButton = atom.confirm
                    message: "The filename indicates that content is already minified. Minify again?"
                    detailedMessage: "The filename contains one of the following parts: '.min.', '.minified.', '.compressed.'"
                    buttons: ["Minify", "Cancel"]
                return dialogResultButton is 0
        return true


    # Available parameters
    #   compress: false / uncompressed
    #   filenamePattern
    #   outputPath
    #   minifier
    #   minifierOptions
    #   buffer
    updateOptionsByInlineParameters: (params) ->
        # compress / uncompressed
        if params.compress is false or params.uncompressed is true
            @options.compress = false

        # filename pattern
        if typeof params.filenamePattern is 'string' and params.filenamePattern.length > 0
            switch @contentType
                when 'css' then @options.cssMinifiedFilenamePattern = params.filenamePattern
                when 'js' then @options.jsMinifiedFilenamePattern = params.filenamePattern

        # output path
        if typeof params.outputPath is 'string' and params.outputPath.length > 0
            @options.outputPath = params.outputPath

        # minifier
        if typeof params.minifier is 'string'
            isUnknownMinifier = true
            switch @contentType
                when 'css'
                    if params.minifier in ['clean-css', 'csso', 'sqwish', 'yui-css']
                        @options.cssMinifier = params.minifier
                        isUnknownMinifier = false
                when 'js'
                    if params.minifier in ['gcc', 'uglify-js', 'yui-js']
                        @options.jsMinifier = params.minifier
                        isUnknownMinifier = false

            if isUnknownMinifier
                warningMessage = "Unknown minifier '#{params.minifier}' in first-line-parameters; using default minifier for minification"
                @emitter.emit('warning', @getBasicEmitterParameters({ message: warningMessage }))

        # minifier options
        minifierOptionsParser = new AtomMinifyMinifierOptionsParser()
        @options.minifierOptions = minifierOptionsParser.parse(@contentType, @options, params)

        # buffer
        if typeof params.buffer is 'number'
            if params.buffer >= 1024*1024
                @options.buffer = params.buffer
            else
                warningMessage = 'Parameter \'buffer\' must be greater or equal than 1024 * 1024'
                @emitter.emit('warning', @getBasicEmitterParameters({ message: warningMessage }))


    setupOutputFile: ->
        @outputFile =
            isTemporary: false

        if @isMinifyDirect()
            @outputFile.path = File.getTemporaryFilename('atom-minify.output.', null, @contentType)
            @outputFile.isTemporary = true
        else
            basename = path.basename(@inputFile.path)
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

            outputPath = path.dirname(@inputFile.path)
            if @options.outputPath
                if path.isAbsolute(@options.outputPath)
                    outputPath = @options.outputPath
                else
                    outputPath = path.join(outputPath, @options.outputPath)

            @outputFile.path = path.join(outputPath, basename)


    checkOutputFileAlreadyExists: () ->
        if @options.checkOutputFileAlreadyExists
            if fs.existsSync(@outputFile.path)
                dialogResultButton = atom.confirm
                    message: "The output file already exists. Do you want to overwrite it?"
                    detailedMessage: "Output file: '#{@outputFile.path}'"
                    buttons: ["Overwrite", "Cancel"]
                return dialogResultButton is 0
        return true


    ensureOutputDirectoryExists: () ->
        if @isMinifyToFile()
            outputPath = path.dirname(@outputFile.path)
            File.ensureDirectoryExists(outputPath)


    writeUnminifiedText: () ->
        dummyMinifierName = 'uncompressed'
        try
            startTimestamp = new Date().getTime()
            activeEditor = atom.workspace.getActiveTextEditor()
            fs.writeFileSync(@outputFile.path, activeEditor.getText())

            statistics =
                duration: new Date().getTime() - startTimestamp,
                before: File.getFileSize(@inputFile.path),
                after: File.getFileSize(@outputFile.path)

            @emitter.emit('success', @getBasicEmitterParameters({ minifierName: dummyMinifierName, statistics: statistics }))
        catch error
            @emitter.emit('error', @getBasicEmitterParameters({ minifierName: dummyMinifierName, message: error }))

        @emitter.emit('finished', @getBasicEmitterParameters())


    writeMinifiedText: () ->
        minifier = @buildMinifierInstance()
        try
            startTimestamp = new Date().getTime()
            minifier.minify @inputFile.path, @outputFile.path, (minifiedText, error) =>
                try
                    if error
                        @emitter.emit('error', @getBasicEmitterParameters({ message: error }))
                    else
                        statistics =
                            duration: new Date().getTime() - startTimestamp

                        if @isMinifyDirect()
                            # Calc saving BEFORE we edit the text editors text
                            statistics.before = atom.workspace.getActiveTextEditor().getText().length
                            statistics.after = minifiedText.length

                            # Apply text but do NOT save it
                            atom.workspace.getActiveTextEditor().setText(minifiedText)
                        else
                            statistics.before = File.getFileSize(@inputFile.path)
                            statistics.after = File.getFileSize(@outputFile.path)

                        @emitter.emit('success', @getBasicEmitterParameters({ minifierName : minifier.getName(), statistics: statistics }))
                finally
                    @deleteTemporaryFiles()
                    @emitter.emit('finished', @getBasicEmitterParameters())
        catch e
            @emitter.emit('error', @getBasicEmitterParameters({ minifierName : minifier.getName(), message: e.toString() }))
            @emitter.emit('finished', @getBasicEmitterParameters())


    throwMessageAndFinish: (type, message) ->
        @deleteTemporaryFiles()
        @emitter.emit(type, @getBasicEmitterParameters({ message: message }))
        @emitter.emit('finished', @getBasicEmitterParameters())


    deleteTemporaryFiles: ->
        if @inputFile and @inputFile.isTemporary
            File.delete(@inputFile.path)
        if @outputFile and @outputFile.isTemporary
            File.delete(@outputFile.path)


    getBasicEmitterParameters: (additionalParameters = {}) ->
        parameters =
            isMinifyToFile: @isMinifyToFile(),
            isMinifyDirect: @isMinifyDirect(),

        if @inputFile
            parameters.inputFilename = @inputFile.path
        if @contentType
            parameters.contentType = @contentType
        if @outputFile
            parameters.outputFilename = @outputFile.path

        for key, value of additionalParameters
            parameters[key] = value

        return parameters


    buildMinifierInstance: () ->
        switch @contentType
            when 'css' then moduleName = @options.cssMinifier
            when 'js' then moduleName = @options.jsMinifier

        minifierClass = require("./minifier/#{@contentType}/#{moduleName}")
        minifier = new minifierClass(@options)

        return minifier


    isMinifyOnSave: ->
        return @minifyOnSave


    isMinifyDirect: ->
        return @mode is AtomMinifier.MINIFY_DIRECT


    isMinifyToFile: ->
        return @mode is AtomMinifier.MINIFY_TO_MIN_FILE


    onStart: (callback) ->
        @emitter.on 'start', callback


    onSuccess: (callback) ->
        @emitter.on 'success', callback


    onWarning: (callback) ->
        @emitter.on 'warning', callback


    onError: (callback) ->
        @emitter.on 'error', callback


    onFinished: (callback) ->
        @emitter.on 'finished', callback
