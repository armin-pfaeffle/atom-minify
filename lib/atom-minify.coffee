AtomMinifyOptions = require('./options')
AtomMinifyView = require('./atom-minify-view')
AtomMinifier = require('./minifier')

module.exports =

    config:

        # General settings

        minifyOnSave:
            title: 'Minify on save'
            description: 'This option en-/disables minification on save.'
            type: 'boolean'
            default: false
            order: 1

        showSavingInfo:
            title: 'Show saving info'
            description: 'This option en-/disables showing some information about saving (percental & absolute).'
            type: 'boolean'
            default: true
            order: 2

        checkOutputFileAlreadyExists:
            title: 'Ask for overwriting already existent minified files'
            description: 'If target file already exists, atom-minify will ask you, if you want to overwrite this file'
            type: 'boolean'
            default: false
            order: 3

        checkAlreadyMinifiedFile:
            title: 'Ask for minification of already minified files'
            description: 'If filename contains \'.min.\', \'.minified.\' or \'.compressed.\', atom-minify will ask you, if you want to minify this file again'
            type: 'boolean'
            default: true
            order: 4

        showMinifyItemInTreeViewContextMenu:
            title: 'Show Minify-item in Tree View context menu'
            description: 'If enbaled, Tree View context menu contains a \'Minify\' item that allows you to minify that file via context menu.'
            type: 'string'
            default: 'Only on CSS and JS files'
            enum: ['Only on CSS and JS files', 'On every file', 'No']
            order: 5


        # Extended options for all minifier

        outputPath:
            title: 'General output path'
            description: 'General output path for every minification. Can be an absolute or relative path. Inline parameters can overwrite this option.'
            type: 'string'
            default: ''
            order: 20

        buffer:
            title: 'Buffer'
            description: 'Only modify the buffer size when you have to compile large files.'
            type: 'integer'
            default: 1024 * 1024
            order: 21


        # Parameters for CSS minifiers

        cssMinifier:
            title: 'CSS → Minifier'
            description: 'Select which CSS minifier you want to use.'
            type: 'string'
            default: 'YUI Compressor'
            enum: ['YUI Compressor', 'clean-css', 'CSSO', 'Sqwish']
            order: 40

        cssMinifiedFilenamePattern:
            title: 'CSS → Filename pattern for minified file'
            description: 'Define the replacement pattern for minified CSS filename. If you want to minify \'Foo.CSS\', you can use $1 for \'Foo\' and $2 for \'CSS\'; The result of pattern \$1.minified.$2\' would be \'Foo.minified.CSS\'.'
            type: 'string'
            default: '$1.min.$2'
            order: 41

        cssParametersForYUI:
            title: 'CSS → Parameters for YUI Compressor'
            description: 'Additional parameters for CSS minifier \'YUI Compressor\'.'
            type: 'string'
            default: ''
            order: 42

        cssParametersForCleanCSS:
            title: 'CSS → Parameters for clean-css'
            description: 'Additional parameters for CSS minifier \'clean-css\'.'
            type: 'string'
            default: ''
            order: 43

        cssParametersForCSSO:
            title: 'CSS → Parameters for CSSO'
            description: 'Additional parameters for CSS minifier \'CSSO\'.'
            type: 'string'
            default: ''
            order: 44

        cssParametersForSqwish:
            title: 'CSS → Parameters for Sqwish'
            description: 'Additional parameters for CSS minifier \'Sqwish\'.'
            type: 'string'
            default: ''
            order: 45


        # Parameters for JS minifiers

        jsMinifier:
            title: 'JS → Minifier'
            description: 'Select which JavaScript minifier you want to use.'
            type: 'string'
            default: 'YUI Compressor'
            enum: ['YUI Compressor', 'Google Closure Compiler', 'UglifyJS2']
            order: 60

        jsMinifiedFilenamePattern:
            title: 'JS → Filename pattern for minified file'
            description: 'Define the replacement pattern for minified JS filename. If you want to minify \'Bar.JS\', you can use $1 for \'Bar\' and $2 for \'JS\'; The result of pattern \$1.xyz.$2\' would be \'Bar.xyz.JS\'.'
            type: 'string'
            default: '$1.min.$2'
            order: 61

        jsParametersForYUI:
            title: 'JS → Parameters for YUI Compressor'
            description: 'Additional parameters for JS minifier \'YUI Compressor\'.'
            type: 'string'
            default: ''
            order: 62

        jsParametersForGCC:
            title: 'JS → Parameters for Google Closure Compiler'
            description: 'Additional parameters for JS minifier \'Google Closure Compiler\'.'
            type: 'string'
            default: ''
            order: 63

        jsParametersForUglifyJS2:
            title: 'JS → Parameters for UglifyJS2'
            description: 'Additional parameters for JS minifier \'UglifyJS2\'.'
            type: 'string'
            default: ''
            order: 64


        # Notification options

        notifications:
            title: 'Notification type'
            description: 'Select which types of notifications you wish to see.'
            type: 'string'
            default: 'Panel'
            enum: ['Panel', 'Notifications', 'Panel, Notifications']
            order: 80

        autoHidePanel:
            title: 'Automatically hide panel on ...'
            description: 'Select on which event the panel should automatically disappear.'
            type: 'string'
            default: 'Success'
            enum: ['Never', 'Success', 'Error', 'Success, Error']
            order: 81

        autoHidePanelDelay:
            title: 'Panel-auto-hide delay'
            description: 'Delay after which panel is automatically hidden'
            type: 'integer'
            default: 3000
            order: 82

        autoHideNotifications:
            title: 'Automatically hide notifications on ...'
            description: 'Select which types of notifications should automatically disappear.'
            type: 'string'
            default: 'Info, Success'
            enum: ['Never', 'Info, Success', 'Error', 'Info, Success, Error']
            order: 83

        showStartMinificationNotification:
            title: 'Show \'Start Minification\' Notification'
            description: 'If enabled a \'Start Minification\' notification is shown.'
            type: 'boolean'
            default: false
            order: 84


        # Advanced options

        absoluteJavaPath:
            title: 'Advanced → Java path'
            description: 'Please only use if you need this option! You can enter an absolute path to your Java executable. Useful when you have more than one Java installation'
            type: 'string'
            default: ''
            order: 100


    atomMinifyView: null
    mainSubmenu: null
    contextMenuItem: null


    activate: (state) ->
        @atomMinifyView = new AtomMinifyView(new AtomMinifyOptions(), state.atomMinifyViewState)

        atom.commands.add 'atom-workspace',
            'atom-minify:toggle-minify-on-save': =>
                @toggleMinifyOnSave()

            'atom-minify:minify-to-min-file': (evt) =>
                @minifyToFile(evt)

            'atom-minify:minify-direct': =>
                @minify(AtomMinifier.MINIFY_DIRECT)

            'atom-minify:close-panel': (e) =>
                @closePanel()
                e.abortKeyBinding()

            'atom-minify:css-minifier-yui': =>
                @selectCssMinifier('YUI Compressor')

            'atom-minify:css-minifier-clean-css': =>
                @selectCssMinifier('clean-css')

            'atom-minify:css-minifier-csso': =>
                @selectCssMinifier('CSSO')

            'atom-minify:css-minifier-sqwish': =>
                @selectCssMinifier('Sqwish')

            'atom-minify:js-minifier-yui': =>
                @selectJsMinifier('YUI Compressor')

            'atom-minify:js-minifier-gcc': =>
                @selectJsMinifier('Google Closure Compiler')

            'atom-minify:js-minifier-uglifyjs2': =>
                @selectJsMinifier('UglifyJS2')

        @registerTextEditorSaveCallback()
        @registerConfigObserver()
        @registerContextMenuItem()


    deactivate: ->
        @atomMinifyView.destroy()


    serialize: ->
        atomMinifyViewState: @atomMinifyView.serialize()


    toggleMinifyOnSave: ->
        AtomMinifyOptions.set('minifyOnSave', !AtomMinifyOptions.get('minifyOnSave'))
        if AtomMinifyOptions.get('minifyOnSave')
            atom.notifications.addInfo('Minify: Enabled minification on save')
        else
            atom.notifications.addWarning('Minify: Disabled minification on save')
        @updateMenuItems()


    selectCssMinifier: (minifier) ->
        validCssMinifiers = ['YUI Compressor', 'clean-css', 'CSSO', 'Sqwish']
        if minifier in validCssMinifiers
            AtomMinifyOptions.set('cssMinifier', minifier)
            atom.notifications.addInfo("Minify: #{minifier} is new CSS minifier")
        @updateMenuItems()


    selectJsMinifier: (minifier) ->
        validJsMinifiers = ['YUI Compressor', 'Google Closure Compiler', 'UglifyJS2']
        if minifier in validJsMinifiers
            AtomMinifyOptions.set('jsMinifier', minifier)
            atom.notifications.addInfo("Minify: #{minifier} is new JS minifier")
        @updateMenuItems()


    registerTextEditorSaveCallback: ->
        @isProcessing = false
        atom.workspace.observeTextEditors (editor) =>
            editor.onDidSave =>
                if AtomMinifyOptions.get('minifyOnSave') and !@isProcessing
                    @minify(AtomMinifier.MINIFY_TO_MIN_FILE, true)


    registerConfigObserver: ->
        atom.config.observe AtomMinifyOptions.OPTIONS_PREFIX + 'cssMinifier', (newValue) =>
            @updateMenuItems()
        atom.config.observe AtomMinifyOptions.OPTIONS_PREFIX + 'jsMinifier', (newValue) =>
            @updateMenuItems()
        atom.config.observe AtomMinifyOptions.OPTIONS_PREFIX + 'minifyOnSave', (newValue) =>
            @updateMenuItems()


    registerContextMenuItem: ->
        menuItem = @getContextMenuItem()
        menuItem.shouldDisplay = (evt) ->
            showItemOption = AtomMinifyOptions.get('showMinifyItemInTreeViewContextMenu')
            if showItemOption in ['Only on CSS and JS files', 'On every file']
                isFileItem = evt.target.getAttribute('class').split(' ').indexOf('file') >= 0
                if isFileItem
                    if showItemOption is 'On every file'
                        return true
                    else
                        path = require('path')

                        child = evt.target.firstElementChild
                        basename = path.basename(child.getAttribute('data-name'))
                        fileExtension = path.extname(basename).replace('.', '').toLowerCase()

                        return fileExtension in ['css', 'js']

            return false


    minifyToFile: (evt) ->
        # Detect if it's a call by Tree View context menu, and if so, extract the file path
        filename = undefined
        if typeof evt is 'object'
            if evt.target.getAttribute('class').split(' ').indexOf('file') >= 0
                child = evt.target.firstElementChild
                tmpFilename = child.getAttribute('data-path')
                fs = require('fs')
                if tmpFilename and fs.existsSync(tmpFilename)
                    filename = tmpFilename
        @minify(AtomMinifier.MINIFY_TO_MIN_FILE, false, tmpFilename)


    minify: (mode, minifyOnSave = false, filename = null) ->
        options = new AtomMinifyOptions()

        @atomMinifyView.updateOptions(options)
        @atomMinifyView.hidePanel(false, true)

        minifier = new AtomMinifier(options)
        minifier.onStart( (args) =>
            @atomMinifyView.startMinification(args)
        )
        minifier.onSuccess( (args) =>
            @atomMinifyView.successfullMinification(args)
            @isProcessing = false
        )
        minifier.onError( (args) =>
            @atomMinifyView.erroneousMinification(args)
            isProcessing = false
        )
        minifier.minify(mode, minifyOnSave, filename)


    updateMenuItems: ->
        menu = @getMainMenuSubmenu()
        menu.submenu[2].label = (if AtomMinifyOptions.get('minifyOnSave') then 'Disable' else 'Enable') + ' minification on save'

        # Update checked minifier item
        for submenu in menu.submenu
            switch submenu.label
                when 'CSS minifier' then type = 'css'
                when 'JS minifier' then type = 'js'
                else type = false
            if type
                minifierSelector = type + 'Minifier'
                minifierName = AtomMinifyOptions.get(minifierSelector)
                for minifierItem in submenu.submenu
                    minifierItem.checked = minifierItem.label is minifierName
        atom.menu.update()


    getMainMenuSubmenu: ->
        if @mainSubmenu is null
            found = false
            for menu in atom.menu.template
                if menu.label is 'Packages' || menu.label is '&Packages'
                    found = true
                    for submenu in menu.submenu
                        if submenu.label is 'Minify'
                            @mainSubmenu = submenu
                            break
                if found
                    break
        return @mainSubmenu


    getContextMenuItem: ->
        if @contextMenuItem is null
            found = false
            for items in atom.contextMenu.itemSets
                if items.selector is '.tree-view'
                    found = true
                    for item in items.items
                        if item.id is 'atom-minify-context-menu-minify'
                            @contextMenuItem = item
                            break

                if found
                    break
        return @contextMenuItem


    closePanel: ->
        @atomMinifyView.hidePanel()
