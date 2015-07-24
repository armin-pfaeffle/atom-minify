{$$, View} = require('atom-space-pen-views')

module.exports =
class AtomMinifyView extends View

    @captionPrefix = 'Minify: '
    @clickableLinksCounter = 0


    @content: ->
        @div class: 'atom-minify atom-panel panel-bottom', =>
            @div class: 'inset-panel', =>
                @div outlet: 'panelHeading', class: 'panel-heading no-border', =>
                    @span
                        outlet: 'panelHeaderCaption'
                        class: 'header-caption'
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


    constructor: (options, args...) ->
        super(args)
        @options = options
        @panel = atom.workspace.addBottomPanel
            item: this
            visible: false


    initialize: (serializeState) ->


    destroy: ->
        clearTimeout(@automaticHidePanelTimeout)
        @panel.destroy()
        @detach()


    updateOptions: (options) ->
        @options = options


    startMinification: (args) ->
        if @options.showStartMinificationNotification
            if args.isMinifyDirect
                @showInfoNotification('Start direct minification')
            else
                @showInfoNotification('Start minification', args.inputFilename)

        if @options.showPanel
            @showPanel(true)
            if @options.showStartMinificationNotification
                if args.isMinifyToFile
                    @addText(args.inputFilename, 'terminal', 'info', () => @openFile(args.inputFilename) )
                else
                    @addText('Start direct minification', 'terminal', 'info',)


    successfullMinification: (args) ->
        saving = @obtainSaving(args)

        successMessage = "Successfully minified"
        if @options.showSavingInfo
            successMessage = "Minification saved #{saving.percentage}% in #{args.statistics.duration}ms / #{saving.before} #{saving.unit} → #{saving.after} #{saving.unit}"
        if args.isMinifyDirect
            details = "Compressor: #{args.minifierName}"
        else
            details = args.outputFilename + "\n(Compressor: #{args.minifierName})"
        @showSuccessNotification(successMessage, details)

        if @options.showPanel
            @showPanel()
            @setCaption('Successfully minified')
            @hideThrobber()
            @showCloseButton()

            if args.isMinifyToFile
                @addText(args.outputFilename, 'check', 'success', () => @openFile(args.outputFilename) )
            else
                @addText('Successfully minified!', 'check', 'success')
            if @options.showSavingInfo
                savingMessage = "Saved #{saving.percentage}% in #{args.statistics.duration}ms — before: #{saving.before} #{saving.unit} / after: #{saving.after} #{saving.unit} — Minifier: #{args.minifierName}"
                @addText(savingMessage, undefined, 'saving-info')

            if @options.autoHidePanelOnSuccess
                @hidePanel(true)


    erroneousMinification: (args) ->
        @showErrorNotification('Minification error', args.error)

        if @options.showPanel
            @showPanel()
            @setCaption('Minification error')
            @hideThrobber()
            @showCloseButton()

            @addText(args.error, 'alert', 'error')

            if @options.autoHidePanelOnError
                @hidePanel(true)


    obtainSaving: (args) ->
        saving =
            percentage: Math.round((args.statistics.before - args.statistics.after) / args.statistics.before * 100)
            before: args.statistics.before
            after: args.statistics.after
            unit: if args.isMinifyToFile then 'Byte' else 'chars'

        # If minified to a file we can reduce used space, rounded to two decimals
        if args.isMinifyToFile
            if (saving.before > 1024 * 1024)
                saving.before = Math.round(saving.before / 10485.76) / 100
                saving.after = Math.round(saving.after / 10485.76) / 100
                saving.unit = 'MB'
            else if (saving.before > 1024)
                saving.before = Math.round(saving.before / 10.24) / 100
                saving.after = Math.round(saving.after / 10.24) / 100
                saving.unit = 'KB'

        return saving


    openFile: (filename) ->
        atom.workspace.open filename


    showInfoNotification: (title, message) ->
        if @options.showInfoNotification
            atom.notifications.addInfo title,
                detail: message
                dismissable: !@options.autoHideInfoNotification


    showSuccessNotification: (title, message) ->
        if @options.showSuccessNotification
            atom.notifications.addSuccess title,
                detail: message
                dismissable: !@options.autoHideSuccessNotification


    showWarningNotification: (title, message) ->
        if @options.showWarningNotification
            atom.notifications.addWarning title,
                detail: message
                dismissable: !@options.autoWarningInfoNotification


    showErrorNotification: (title, message) ->
        if @options.showErrorNotification
            atom.notifications.addError title,
                detail: message
                dismissable: !@options.autoHideErrorNotification


    resetPanel: ->
        @setCaption('Processing...')
        @showThrobber()
        @hideCloseButton()
        @panelBody.addClass('hide').empty()


    showPanel: (reset = false) ->
        clearTimeout(@automaticHidePanelTimeout)

        if reset
            @resetPanel()
	    
        @panel.show()


    hidePanel: (withDelay = false)->
        clearTimeout(@automaticHidePanelTimeout)

        # We have to compare it to true because if close button is clicked, the withDelay
        # parameter is a reference to the button
        if withDelay == true
            @automaticHidePanelTimeout = setTimeout =>
                @hideThrobber()
                @panel.hide()
            , @options.autoHidePanelDelay
        else
            @hideThrobber()
            @panel.hide()


    setCaption: (text) ->
        @panelHeaderCaption.html(AtomMinifyView.captionPrefix + text)


    addText: (text, icon, textClass, clickCallback) ->
        clickCounter = AtomMinifyView.clickableLinksCounter++
        wrapperClass = if clickCallback then "clickable clickable-#{clickCounter}" else ''

        spanClass = ''
        if icon
            spanClass = spanClass + (if spanClass isnt '' then ' ' else '') + "icon icon-#{icon}"
        if textClass
            spanClass = spanClass + (if spanClass isnt '' then ' ' else '') + "text-#{textClass}"

        @panelBody.removeClass('hide').append $$ ->
            @p class: wrapperClass, =>
                @span class: spanClass, text

        if clickCallback
            @find(".clickable-#{clickCounter}").on 'click', clickCallback


    hideCloseButton: ->
        @panelClose.addClass('hide')


    showCloseButton: ->
        @panelClose.removeClass('hide')


    hideThrobber: ->
        @panelLoading.addClass('hide')


    showThrobber: ->
        @panelLoading.removeClass('hide')
