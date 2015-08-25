{Emitter} = require('event-kit')
AtomMinifyOptions = require('./options')
AtomMinifyInlineParameters = require('./inline-parameters')

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


    # If filename is null then active text editor is used for minification
    minify: (mode, minifyOnSave = false, filename = null) ->
        @mode = mode
        @minifyOnSave = minifyOnSave
        @inputFilename = @getInputFilename(filename)

        # inputFilename is always set, it's not if valid content is the target
        if @inputFilename and @detectContentType()
            if @isMinifyToFile()
                #
                # TODO: den ensureFileIsSaved Check nur dann machen, wenn der Inhalt in einer Datei
                # gespeichert ist. Denn wenn der Inhalt in einem neuen Tab steht und dann minimiert
                # wird, sollte immer die Minimierung durchgeführt werden. Evtl. kann ja danach
                # dann der Save-Dialog erscheinen.
                #

                # If a file should be minified to another, the file must be saved, else only direct
                # minification is available. The reason for this is that building a minified
                # filename is based on the existant filename
                if not @ensureFileIsSaved()
                    return

                if not @checkAlreadyMinifiedFile()
                    return


            @updateOptionsWithInlineParameters () =>
                @outputFilename = @getOutputFilename()

                if @isMinifyToFile() and not @checkOutputFileAlreadyExists()
                    return

                # Ensure valid directory
                @ensureTargetDirectoryExists()

                if @options.compress isnt undefined and @options.compress is false
                    # Only write unminified text if target is a file, else it does not make
                    # any sense
                    if @isMinifyToFile()
                        @writeUnminifiedText()
                else
                    @writeMinifiedText()


    detectContentType: ->
        @contentType = null

        # We don't return if inputFilename is empty because user you should be aable to minify
        # text of a new opened, but unsaved tab
        if @isMinifyDirect()
            activeEditor = atom.workspace.getActiveTextEditor()
            if activeEditor and activeEditor.getURI()
                filename = activeEditor.getURI()
                if filename and fs.existsSync(filename)
                    fileExtension = path.extname(filename).toLowerCase()
        else if @inputFilename
            fileExtension = path.extname(@inputFilename).toLowerCase()

        # Detect content type by file extension or ask user
        # BUT we only ask the user to select content type, if minification is not startet via
        # saving file
        switch fileExtension
            when '.css' then @contentType = 'css'
            when '.js' then @contentType = 'js'
            else
                if not @isMinifyOnSave()
                    dialogResultButton = atom.confirm
                        message: "Can not detect content type. Tell me which minifier should be used for minification?"
                        buttons: ["Cancel", "CSS", "JS"]
                    switch dialogResultButton
                        when 1 then @contentType = 'css'
                        when 2 then @contentType = 'js'

        return @contentType isnt null


    ensureFileIsSaved: () ->
        editors = atom.workspace.getTextEditors()
        for editor in editors
            if editor and editor.getURI and editor.getURI() is @inputFilename and editor.isModified()
                dialogResultButton = atom.confirm
                    message: "'#{editor.getTitle()}' has changes, do you want to save them?"
                    detailedMessage: "In order to minify a file you have to save changes."
                    buttons: ["Save and minify", "Cancel"]
                if dialogResultButton is 0
                    editor.save()
                    break
                else
                    return false

        return true


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


    checkAlreadyMinifiedFile: () ->
        if @options.checkAlreadyMinifiedFile
            if /\.(?:min|minified|compressed)\./i.exec(@inputFilename) isnt null
                dialogResultButton = atom.confirm
                    message: "The filename indicates that content is already minified. Minify again?"
                    detailedMessage: "The filename contains one of the following parts: '.min.', '.minified.', '.compressed.'"
                    buttons: ["Minify", "Cancel"]
                return dialogResultButton is 0
        return true


    checkOutputFileAlreadyExists: () ->
        if @options.checkOutputFileAlreadyExists
            if fs.existsSync(@outputFilename)
                dialogResultButton = atom.confirm
                    message: "The output filename already exists. Do you want to overwrite it?"
                    detailedMessage: "Output filename: '#{@outputFilename}'"
                    buttons: ["Overwrite", "Cancel"]
                return dialogResultButton is 0
        return true


    ensureTargetDirectoryExists: () ->
        if @isMinifyToFile()
            finalOutputPath = path.dirname(@outputFilename)
            parts = finalOutputPath.split(path.sep)

            # If part[0] is an empty string, it's Darwin or Linux, so we set the tmpPath to
            # root directory as starting point
            tmpPath = ''
            if parts[0] is ''
                parts.shift()
                tmpPath = path.sep

            for folder in parts
                tmpPath += (if tmpPath in ['', path.sep] then '' else path.sep) + folder
                if not fs.existsSync(tmpPath)
                    fs.mkdirSync(tmpPath)


    getInputFilename: (filename = null) ->
        if filename
            inputFilename = filename
        else
            activeEditor = atom.workspace.getActiveTextEditor()
            return unless activeEditor

            if @isMinifyDirect()
                inputFilename = @getTemporaryFilename('input')
                fs.writeFileSync(inputFilename, activeEditor.getText())
            else
                inputFilename = activeEditor.getURI()
                if not inputFilename
                    inputFilename = @askForSavingUnsavedFileInActiveEditor()

        return inputFilename


    # Available parameters
    #   compress: false / uncompressed
    #   filenamePattern
    #   outputPath
    #   minifier
    #   minifierOptions
    #   buffer
    updateOptionsWithInlineParameters: (callback) ->
        parameters = new AtomMinifyInlineParameters()
        parameters.parse @inputFilename, (params, error) =>
            if error
                emitterParameters = @getBasicEmitterParameters('none', { error: error })
                @emitter.emit('error', emitterParameters)
                return

            if params
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
                if typeof params.minifier is 'string' and params.minifier.length > 0
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
                        error = "Unknown minifier '#{params.minifier}' in first-line-parameters"
                        emitterParameters = @getBasicEmitterParameters('none', { error: error })
                        @emitter.emit('error', emitterParameters)
                        return

                # minifier options
                if typeof params.minifierOptions is 'string' and params.minifierOptions.length > 0
                    switch @contentType
                        when 'css'
                            switch @options.cssMinifier
                                when 'clean-css' then @options.cssParametersForCleanCSS += ' ' + params.minifierOptions
                                when 'csso' then @options.cssParametersForCSSO += ' ' + params.minifierOptions
                                when 'sqwish' then @options.cssParametersForSqwish += ' ' + params.minifierOptions
                                when 'yui-css' then @options.cssParametersForYUI += ' ' + params.minifierOptions

                        when 'js'
                            switch @options.jsMinifier
                                when 'gcc' then @options.jsParametersForGCC += ' ' + params.minifierOptions
                                when 'uglify-js' then @options.jsParametersForUglifyJS2 += ' ' + params.minifierOptions
                                when 'yui-js' then @options.jsParametersForYUI += ' ' + params.minifierOptions

                # buffer
                if typeof params.buffer is 'number' and params.buffer >= 1024*1024
                    @options.buffer = params.buffer

            callback()


    getOutputFilename: ->
        if @isMinifyDirect()
            minifiedFilename = @getTemporaryFilename('output')
        else
            basename = path.basename(@inputFilename)
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

            outputPath = path.dirname(@inputFilename)
            if @options.outputPath
                if path.isAbsolute(@options.outputPath)
                    outputPath = @options.outputPath
                else
                    outputPath = path.join(outputPath, @options.outputPath)

            minifiedFilename = path.join(outputPath, basename)

        return minifiedFilename


    writeUnminifiedText: () ->
        dummyMinifierName = 'uncompressed'
        emitterParameters = @getBasicEmitterParameters(dummyMinifierName)

        @emitter.emit('start', emitterParameters)
        try
            startTimestamp = new Date().getTime()
            activeEditor = atom.workspace.getActiveTextEditor()
            fs.writeFileSync(@outputFilename, activeEditor.getText())

            statistics =
                duration: new Date().getTime() - startTimestamp,
                before: @getFileSizeInByte(@inputFilename),
                after: @getFileSizeInByte(@outputFilename)

            emitterParameters.statistics = statistics
            @emitter.emit('success', emitterParameters)
        catch error
            emitterParameters.error = error
            @emitter.emit('error', emitterParameters)


    writeMinifiedText: () ->
        minifier = @getMinifier()
        emitterParameters = @getBasicEmitterParameters(minifier.getName())
        try
            @emitter.emit('start', emitterParameters)

            startTimestamp = new Date().getTime()
            minifier.minify @inputFilename, @outputFilename, @options, (minifiedText, error) =>
                statistics =
                    duration: new Date().getTime() - startTimestamp

                # Delete temporary created file, even if there was an error
                if @isMinifyDirect()
                    @deleteTemporaryFiles([@inputFilename, @outputFilename])

                if error
                    emitterParameters.error = error
                    @emitter.emit('error', emitterParameters)
                else
                    if @isMinifyDirect()
                        # Calc saving BEFORE we edit the text editors text
                        statistics.before = atom.workspace.getActiveTextEditor().getText().length
                        statistics.after = minifiedText.length

                        # Apply text but do NOT save it
                        atom.workspace.getActiveTextEditor().setText(minifiedText)
                    else
                        statistics.before = @getFileSizeInByte(@inputFilename)
                        statistics.after = @getFileSizeInByte(@outputFilename)

                    emitterParameters.statistics = statistics
                    @emitter.emit('success', emitterParameters)
        catch e
            emitterParameters.error = e.toString()
            @emitter.emit('error', emitterParameters)


    getBasicEmitterParameters: (minifierName, furtherParameters = {}) ->
        parameters =
            isMinifyToFile: @isMinifyToFile(),
            isMinifyDirect: @isMinifyDirect(),
            contentType: @contentType,
            minifierName: minifierName,
            inputFilename: @inputFilename

        if @outputFilename
            parameters.outputFilename = @outputFilename

        for key, value of furtherParameters
            parameters[key] = value

        return parameters


    getTemporaryFilename: (filenameAddition) ->
        os = require('os')
        uuid = require('node-uuid')
        uniqueId = uuid.v4()
        filename = "atom-minify.#{uniqueId}.#{filenameAddition}.tmp"
        filename = path.join(os.tmpdir(), filename)
        return filename


    deleteTemporaryFiles: (files) ->
        for file in files
            if fs.existsSync
                try
                    fs.unlinkSync(file)
                catch e
                    # do nothing here, if an error occurs


    getMinifier: () ->
        switch @contentType
            when 'css' then moduleName = @options.cssMinifier
            when 'js' then moduleName = @options.jsMinifier

        minifierClass = require("./minifier/#{@contentType}/#{moduleName}")
        minifier = new minifierClass()

        return minifier


    isMinifyOnSave: ->
        return @minifyOnSave


    isMinifyDirect: ->
        return @mode is AtomMinifier.MINIFY_DIRECT


    isMinifyToFile: ->
        return @mode is AtomMinifier.MINIFY_TO_MIN_FILE


    getFileSizeInByte: (filename) ->
        statistics = fs.statSync(filename)
        fileSize = statistics['size']
        return fileSize


    onStart: (callback) ->
        @emitter.on 'start', callback


    onError: (callback) ->
        @emitter.on 'error', callback


    onSuccess: (callback) ->
        @emitter.on 'success', callback
