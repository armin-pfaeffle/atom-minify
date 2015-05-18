{$$, View} = require 'atom-space-pen-views'

module.exports =
class AtomMinifyView extends View

    @OPTIONS_PREFIX = 'atom-minify.'
    @MINIFY_DIRECT = 'direct'
    @MINIFY_TO_MIN_FILE = 'to-min-file'


    @content: ->
        @div class: 'atom-minify atom-panel panel-bottom hide', =>
            @div class: 'inset-panel', =>
                @div outlet: 'panelHeading', class: 'panel-heading no-border', =>
                    @span
                        outlet: 'panelHeaderCaption'
                        class: 'header-caption'
                        'Minify: Processing...'
                    @span
                        outlet: 'panelLoading'
                        class: 'inline-block loading loading-spinner-tiny hide'
                        style: 'margin-left: 10px;'
                    @div class: 'inline-block pull-right', =>
                        @button
                            outlet: 'panelClose'
                            class: 'btn btn-close hide'
                            click: 'hidePanel'
                            'Close'
                @div outlet: 'panelBody', class: 'panel-body padded hide', =>


    @getOption: (name) ->
        return atom.config.get(AtomMinifyView.OPTIONS_PREFIX + name)


    @setOption: (name, value) ->
        atom.config.set(AtomMinifyView.OPTIONS_PREFIX + name, value)


    @unsetOption: (name) ->
        atom.config.unset(AtomMinifyView.OPTIONS_PREFIX + name)


    initialize: (serializeState) ->
        @inProgress = false
        @timeout = null

        atom.workspace.observeTextEditors (editor) =>
            editor.onDidSave =>
                if AtomMinifyView.getOption('minifyOnSave') and !@inProgress
                    @minify(AtomMinifyView.MINIFY_TO_MIN_FILE)


    destroy: ->
        @detach()


    prepareOptions: ->
        @options =
            showSavingInfo: AtomMinifyView.getOption('showSavingInfo')

            cssMinifier: @parseCssMinifier(AtomMinifyView.getOption('cssMinifier'))
            jsMinifier: @parseJsMinifier(AtomMinifyView.getOption('jsMinifier'))

            cssMinifiedFilenamePattern: AtomMinifyView.getOption('cssMinifiedFilenamePattern')
            jsMinifiedFilenamePattern: AtomMinifyView.getOption('jsMinifiedFilenamePattern')

            showInfoNotification: AtomMinifyView.getOption('notifications') in ['Notifications', 'Panel, Notifications']
            showSuccessNotification: AtomMinifyView.getOption('notifications') in ['Notifications', 'Panel, Notifications']
            showErrorNotification: AtomMinifyView.getOption('notifications') in ['Notifications', 'Panel, Notifications']

            autoHideInfoNotification: AtomMinifyView.getOption('autoHideNotifications') in ['Info, Success', 'Info, Success, Error']
            autoHideSuccessNotification: AtomMinifyView.getOption('autoHideNotifications') in ['Info, Success', 'Info, Success, Error']
            autoHideErrorNotification: AtomMinifyView.getOption('autoHideNotifications') in ['Error', 'Info, Success, Error']

            showPanel: AtomMinifyView.getOption('notifications') in ['Panel', 'Panel, Notifications']

            autoHidePanelOnSuccess: AtomMinifyView.getOption('autoHidePanel') in ['Success', 'Success, Error']
            autoHidePanelOnError: AtomMinifyView.getOption('autoHidePanel') in ['Error', 'Success, Error']
            autoHidePanelDelay: AtomMinifyView.getOption('autoHidePanelDelay')

            showStartMinificationNotification: AtomMinifyView.getOption('showStartMinificationNotification')

            # Extended options
            buffer: AtomMinifyView.getOption('buffer')

            cssParametersForYUI: AtomMinifyView.getOption('cssParametersForYUI')
            cssParametersForCleanCSS: AtomMinifyView.getOption('cssParametersForCleanCSS')
            cssParametersForCSSO: AtomMinifyView.getOption('cssParametersForCSSO')
            cssParametersForSqwish: AtomMinifyView.getOption('cssParametersForSqwish')

            jsParametersForYUI: AtomMinifyView.getOption('jsParametersForYUI')
            jsParametersForGCC: AtomMinifyView.getOption('jsParametersForGCC')
            jsParametersForUglifyJS2: AtomMinifyView.getOption('jsParametersForUglifyJS2')


    parseCssMinifier: (minifier) ->
        switch minifier
            when 'YUI Compressor' then return 'yui-css'
            when 'clean-css' then return 'clean-css'
            when 'CSSO' then return 'csso'
            when 'Sqwish' then return 'sqwish'
            else return null


    parseJsMinifier: (minifier) ->
        switch minifier
            when 'YUI Compressor' then return 'yui-js'
            when 'Google Closure Compiler' then return 'gcc'
            when 'UglifyJS2' then return 'uglifyjs'
            else return null


    minify: (method, byCommand) ->
        path = require 'path'

        activeEditor = atom.workspace.getActiveTextEditor()
        if activeEditor and activeEditor.getURI
            filename = activeEditor.getURI()
            fileExtension = path.extname(filename)

            if fileExtension.toLowerCase() == '.css'
                @minifyFile('css', method, filename)
            else if fileExtension.toLowerCase() == '.js'
                @minifyFile('js', method, filename)
            else if method is AtomMinifyView.MINIFY_DIRECT and byCommand == true
                atom.confirm
                    message: "Tell me which minifier should be used for unknown file?"
                    # detailedMessage: 'In order to minify a file you have to save changes.'
                    buttons:
                        "Cancel": =>
                            return false
                        "CSS": =>
                            @minifyFile('css', method, filename)
                        "JS": =>
                            @minifyFile('js', method, filename)



    getParams: (filename, callback) ->
        fs = require 'fs'
        path = require 'path'
        readline = require 'readline'

        params =
            file: filename
            out: null
            main: null
            compress: null
            sourceMap: null
            sourceMapEmbed: null
            sourceMapContents: null
            sourceComments: null
            includePath: null

        parse = (firstLine) =>
            firstLine.split(',').forEach (item) ->
                i = item.indexOf ':'

                if i < 0
                    return

                key = item.substr(0, i).trim()
                match = /^\s*\/\/\s*(.+)/.exec(key);

                if match
                    key = match[1]

                value = item.substr(i + 1).trim()

                params[key] = value

            if params.main isnt null
                parentFilename = path.resolve(path.dirname(filename), params.main)
                @getParams parentFilename, callback
            else
                callback params

        if !fs.existsSync filename
            @showErrorNotification 'Path does not exist:', "#{filename}", true
            @inProgress = false
            return null

        # Read and parse first line
        rl = readline.createInterface
            input: fs.createReadStream filename
            output: process.stdout
            terminal: false

        firstLine = null
        rl.on 'line', (line) ->
            if firstLine is null
                firstLine = line
                parse firstLine


    minifyFile: (fileType, method, filename) ->
        if method is AtomMinifyView.MINIFY_TO_MIN_FILE and not @checkFileIsSaved()
            return

        @prepareOptions()

        minifier = require('node-minify')
        fs = require('fs')

        atom.workspace.getActiveEditor().getText()

        if method is AtomMinifyView.MINIFY_DIRECT
            # We store the current input to a temporary file, so this file is minified.
            # The reason for this is that if a user has modified the content and wants
            # to minify it, we have to store the content to a file first, which then
            # gets minified.
            inputFilename = @obtainTemporaryFilename('input')
            fs.writeFileSync(inputFilename, atom.workspace.getActiveEditor().getText())
        else
            inputFilename = filename

        if fileType is 'css'
            pattern = @options.cssMinifiedFilenamePattern
        else
            pattern = @options.jsMinifiedFilenamePattern
        outputFilename = if method is AtomMinifyView.MINIFY_DIRECT then @obtainTemporaryFilename('output') else @obtainMinifiedFilename(filename, pattern)


        options = @obtainMinifierOptions(fileType, @options.jsMinifier)

        params =
            type: if fileType == 'css' then @options.cssMinifier else @options.jsMinifier,
            fileIn: inputFilename,
            fileOut: outputFilename,
            options: options,
            callback: (error, minifiedText) =>
                if error
                    @erroneousMinification(filename, error.message)
                else
                    if method is AtomMinifyView.MINIFY_DIRECT
                        # Delete temporary created file
                        fs.unlinkSync(inputFilename)
                        fs.unlinkSync(outputFilename)

                        # Calc saving BEFORE we edit the text editors text
                        statistics =
                            directMinification: true
                            before: atom.workspace.getActiveEditor().getText().length
                            after: minifiedText.length

                        # Apply text but do NOT save it
                        atom.workspace.getActiveEditor().setText(minifiedText)
                    else
                        statistics =
                            directMinification: false
                            before: @getFileSizeInByte(filename)
                            after: @getFileSizeInByte(outputFilename)

                    statistics.duration = new Date().getTime() - @startTimestamp
                    @startTimestamp = null
                    statistics.minifier = AtomMinifyView.getOption( if fileType is 'css' then 'cssMinifier' else 'jsMinifier' )

                    @successfullMinification(method, outputFilename, statistics)

        @startMinify(filename)
        @startTimestamp = new Date().getTime()
        try
            new minifier.minify(params)
        catch e
            errorMessage = "#{e.message} - index: #{e.index}, line: #{e.line}, file: #{e.filename}"
            @erroneousMinification(filename, errorMessage)


    checkFileIsSaved: ->
        editor = atom.workspace.getActiveEditor()
        if editor.isModified()
            atom.confirm
                message: "'#{editor.getTitle()}' has changes, do you want to save them?"
                detailedMessage: 'In order to minify a file you have to save changes.'
                buttons:
                    "Save and minify": =>
                        editor.save()
                        return true
                    "Cancel": =>
                        return false
        else
            return true


    obtainTemporaryFilename: (filenameAddition) ->
        os = require('os')
        path = require('path')
        timestamp = new Date().getTime()
        filename = "atom-minify.#{timestamp}.#{filenameAddition}.tmp"
        filename = path.join(os.tmpdir(), filename)
        return filename


    obtainMinifiedFilename: (filename, pattern) ->
        path = require('path')
        basename = path.basename(filename)
        basename = basename.replace(/^(.*?)\.(css|js)$/ig, pattern)
        minifiedFilename = path.join(path.dirname(filename), basename)
        return minifiedFilename


    obtainMinifierOptions: (fileType, minifier) ->
        options = null
        if fileType is 'css'
            switch minifier
                when 'yui-css' then options = @options.cssParametersForYUI
                when 'clean-css' then options = @options.cssParametersForCleanCSS
                when 'csso' then options = @options.cssParametersForCSSO
                when 'sqwish' then options = @options.cssParametersForSqwish
        else if fileType is 'js'
            switch minifier
                when 'yui-js' then options = @options.jsParametersForYUI
                when 'gcc' then options = @options.jsParametersForGCC
                when 'uglifyjs' then options = @options.jsParametersForUglifyJS2

        if options is null or options is ''
            options = []
        else
            options = [options]

        return options


    getFileSizeInByte: (filename) ->
        fs = require('fs');
        statistics = fs.statSync(filename)
        fileSize = statistics['size']
        return fileSize


    showInfoNotification: (title, message, forceShow = false) ->
        if !@options.showInfoNotification and !forceShow
            return

        atom.notifications.addInfo title,
            detail: message
            dismissable: !@options.autoHideInfoNotification


    showSuccessNotification: (title, message, forceShow = false) ->
        if !@options.showSuccessNotification and !forceShow
            return

        atom.notifications.addSuccess title,
            detail: message
            dismissable: !@options.autoHideSuccessNotification


    showErrorNotification: (title, message, forceShow = false) ->
        if !@options.showErrorNotification and !forceShow
            return

        atom.notifications.addError title,
            detail: message
            dismissable: !@options.autoHideErrorNotification


    startMinify: (filename) ->
        @inProgress = true

        if @options.showStartMinificationNotification
            @showInfoNotification 'Start minification', filename

        if @options.showPanel
            @showPanel()
            @setPanelCaption 'Minify: Processing...'
            if @options.showStartMinificationNotification
                @setPanelMessage filename, 'terminal'


    successfullMinification: (method, filename, statistics) ->
        saving = @obtainSaving(method, statistics)

        successMessage = "Successfully minified"
        if @options.showSavingInfo
            successMessage = "Minification saved #{saving.percentage}% in #{saving.duration}ms / #{saving.before} #{saving.unit} → #{saving.after} #{saving.unit}"
        if method is AtomMinifyView.MINIFY_DIRECT
            details = "Compressor: #{saving.minifier}"
        else
            details = filename + "\n(Compressor: #{saving.minifier})"
        @showSuccessNotification(successMessage, details)

        if @options.showPanel
            @setPanelCaption('Minify: Successfully minified')
            @setSuccessMessageToPanel(method, filename, saving)
            @showCloseButton()
            if @options.autoHidePanelOnSuccess
                @hidePanel(true)

        @inProgress = false


    obtainSaving: (method, statistics) ->
        saving =
            percentage: Math.round((statistics.before - statistics.after) / statistics.before * 100)
            before: statistics.before
            after: statistics.after
            unit: if method is AtomMinifyView.MINIFY_DIRECT then 'chars' else 'Byte'
            duration: statistics.duration
            minifier: statistics.minifier

        # If minified to a file we can reduce used space, rounded to two decimals
        if method is AtomMinifyView.MINIFY_TO_MIN_FILE
            if (statistics.before > 1024 * 1024)
                saving.before = Math.round(statistics.before / 10485.76) / 100
                saving.after = Math.round(statistics.after / 10485.76) / 100
                saving.unit = 'MB'
            else if (statistics.before > 1024)
                saving.before = Math.round(statistics.before / 10.24) / 100
                saving.after = Math.round(statistics.after / 10.24) / 100
                saving.unit = 'KB'

        return saving


    erroneousMinification: (filename, errorMessage) ->
        @showErrorNotification 'Error while minifying', errorMessage

        if @options.showPanel
            @setPanelCaption('Minify: Error while minifying')
            @setErrorMessageToPanel(errorMessage)
            @showCloseButton()
            if @options.autoHidePanelOnError
                @hidePanel(true)

        @inProgress = false


    setPanelCaption: (caption) ->
        @panelHeaderCaption.html(caption)


    setPanelMessage: (message, icon = "chevron-right") ->
        icon = if icon then 'icon-' + icon else ''
        @panelBody.removeClass('hide').append $$ ->
            @p =>
                @span class: "icon #{icon} text-info", message


    setSuccessMessageToPanel: (method, filename, saving) ->
        if method is AtomMinifyView.MINIFY_DIRECT
            @panelBody.removeClass('hide').append $$ ->
                @p =>
                    @span class: "icon icon-check text-success", "Successfully minified!"
        else
            @panelBody.removeClass('hide').append $$ ->
                @p class: 'open-file', =>
                    @span class: "icon icon-check text-success", filename

        if @options.showSavingInfo
            savingMessage = "Saved #{saving.percentage}% in #{saving.duration}ms — before: #{saving.before} #{saving.unit} / after: #{saving.after} #{saving.unit} — Minifier: #{saving.minifier}"
            @panelBody.removeClass('hide').append $$ ->
                @p class: (if method is AtomMinifyView.MINIFY_DIRECT then '' else 'open-file') , =>
                    @span class: "saving-info", savingMessage

        @find('.open-file').on 'click', (event) =>
            @openFile filename


    setErrorMessageToPanel: (error) ->
        @panelBody.removeClass('hide').append $$ ->
            @p class: "icon icon-alert text-error", =>
                @span class: "error-caption", 'Error:'
                @span class: "error-text", error


    openFile: (filename, line, column) ->
        atom.workspace.open filename,
            initialLine: if line then line - 1 else 0,
            initialColumn: if column then column - 1 else 0


    showPanel: ->
        @inProgress = true

        clearTimeout @timeout

        @panelHeading.addClass('no-border')
        @panelBody.addClass('hide').empty()
        @panelLoading.removeClass('hide')
        @panelClose.addClass('hide')

        atom.workspace.addBottomPanel
            item: this

        @removeClass 'hide'


    hidePanel: (withDelay = false) ->
        @panelLoading.addClass 'hide'

        clearTimeout @timeout

        if withDelay == true
            @timeout = setTimeout =>
                @addClass 'hide'
            , @options.autoHidePanelDelay
        else
            @addClass 'hide'


    showCloseButton: ->
        @panelLoading.addClass('hide')
        @panelClose.removeClass('hide')
