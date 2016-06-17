{$, $$, View} = require('atom-space-pen-views')

File = require('./helper/file')

fs = require('fs')


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
                    @div outlet: 'panelRightTopOptions', class: 'inline-block pull-right right-top-options', =>
                        @button
                            outlet: 'panelClose'
                            class: 'btn btn-close'
                            click: 'hidePanel'
                            'Close'
                @div
                    outlet: 'panelBody'
                    class: 'panel-body padded hide'


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
        @hasError = false

        if @options.showStartMinificationNotification
            if args.isMinifyDirect
                @showInfoNotification('Direct minification started')
            else
                @showInfoNotification('Minification started', args.inputFilename)

        if @options.showPanel
            @showPanel()
            if @options.showStartMinificationNotification
                if args.isMinifyToFile
                    @addText(args.inputFilename, 'terminal', 'info', (evt) => @openFile(args.inputFilename, evt.target) )
                else
                    @addText('Direct minification started', 'terminal', 'info',)


    warning: (args) ->
        if @options.showWarningNotification
            @showWarningNotification('Warning', args.message)

        if @options.showPanel
            @showPanel()
            if args.inputFilename
                @addText(args.message, 'issue-opened', 'warning', (evt) => @openFile(args.inputFilename, evt.target))
            else
                @addText(args.message, 'issue-opened', 'warning')


    successfullMinification: (args) ->
        saving = @obtainSaving(args)

        successMessage = "Successfully minified"
        if @options.showSavingInfo
            successMessage = "Minification saved <strong>#{saving.percentage}%</strong> in #{args.statistics.duration}ms"
            successMessage += " / before: #{saving.before} #{saving.unit}"
            successMessage += ", after:  #{saving.after} #{saving.unit}"
        if args.isMinifyDirect
            details = "Compressor: #{args.minifierName}"
        else
            details = args.outputFilename + "\n(Compressor: #{args.minifierName})"
        @showSuccessNotification(successMessage, details)

        if @options.showPanel
            @showPanel()

            # We have to store this value in a local variable, beacuse $$ methods can not see @options
            showSavingInfo = @options.showSavingInfo

            message = $$ ->
                @div class: 'success-text-wrapper', =>
                    @p class: 'icon icon-check text-success', =>
                        if args.isMinifyToFile
                            @span class: '', args.outputFilename
                        else
                            @span class: '', 'Successfully minified!'

                    if showSavingInfo
                        @p class: 'success-details text-info', =>
                            @span class: 'success-saved-percentage', =>
                                @span 'Saved: '
                                @span class: 'value', saving.percentage + '%'
                            @span class: 'success-duration', =>
                                @span 'Duration: '
                                @span class: 'value', args.statistics.duration + ' ms'
                            @span class: 'success-size-before', =>
                                @span 'Size before: '
                                @span class: 'value', saving.before + ' ' + saving.unit
                            @span class: 'success-size-after', =>
                                @span 'Size after: '
                                @span class: 'value', saving.after + ' ' + saving.unit
                            @span class: 'success-minifier', =>
                                @span 'Minifier: '
                                @span class: 'value', args.minifierName

            @addText(message, 'check', 'success', (evt) => @openFile(args.outputFilename, evt.target))


    erroneousMinification: (args) ->
        @hasError = true
        caption = 'Minification error' + if args.minifierName then ' — ' + args.minifierName else ''
        @showErrorNotification(caption, args.message)

        if @options.showPanel
            @showPanel()

            @addText(args.message, 'alert', 'error')


    obtainSaving: (args) ->
        saving =
            percentage: Math.round((args.statistics.before - args.statistics.after) / args.statistics.before * 100)
            before: args.statistics.before
            after: args.statistics.after
            unit: if args.isMinifyToFile then 'Byte' else 'chars'

        # If minified to a file we can reduce used space, rounded to two decimals
        if args.isMinifyToFile
            tmpSaving = File.fileSizeToReadable([saving.before, saving.after])
            saving.before = tmpSaving.size[0]
            saving.after = tmpSaving.size[1]
            saving.unit = tmpSaving.unit

        return saving


    finished: (args) ->
        if @hasError
            @setCaption('Minification error')
            if @options.autoHidePanelOnError
                @hidePanel(true)
        else
            @setCaption('Successfully minified')
            if @options.autoHidePanelOnSuccess
                @hidePanel(true)

        @hideThrobber()
        @showRightTopOptions()


    openFile: (filename, targetElement = null) ->
        fs.exists filename, (exists) =>
            if exists
                atom.workspace.open filename
            else if targetElement
                target = $(targetElement)
                if not target.is('p.clickable')
                    target = target.parent()

                target
                    .addClass('target-file-does-not-exist')
                    .removeClass('clickable')
                    .append($('<span>File does not exist!</span>').addClass('hint'))
                    .off('click')
                    .children(':first')
                        .removeClass('text-success text-warning text-info')


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
        @hideRightTopOptions()
        @panelBody.addClass('hide').empty()


    showPanel: (reset = false) ->
        clearTimeout(@automaticHidePanelTimeout)

        if reset
            @resetPanel()

        @panel.show()


    hidePanel: (withDelay = false, reset = false)->
        clearTimeout(@automaticHidePanelTimeout)

        # We have to compare it to true because if close button is clicked, the withDelay
        # parameter is a reference to the button
        if withDelay == true
            @automaticHidePanelTimeout = setTimeout =>
                @hideThrobber()
                @panel.hide()
                if reset
                    @resetPanel()
            , @options.autoHidePanelDelay
        else
            @hideThrobber()
            @panel.hide()
            if reset
                @resetPanel()


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

        if typeof text is 'object'
            wrapper = $$ ->
                @div class: wrapperClass
            wrapper.append(text)
            @panelBody.removeClass('hide').append(wrapper)
        else
            @panelBody.removeClass('hide').append $$ ->
                @p class: wrapperClass, =>
                    @span class: spanClass, text

        if clickCallback
            @find(".clickable-#{clickCounter}").on 'click', (evt) => clickCallback(evt)


    hideRightTopOptions: ->
        @panelRightTopOptions.addClass('hide')


    showRightTopOptions: ->
        @panelRightTopOptions.removeClass('hide')


    hideThrobber: ->
        @panelLoading.addClass('hide')


    showThrobber: ->
        @panelLoading.removeClass('hide')
