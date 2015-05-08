AtomMinifyView = require './atom-minify-view'

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

        cssMinifier:
            title: 'CSS minifier'
            description: 'Select which CSS minifier you want to use.'
            type: 'string'
            default: 'YUI Compressor'
            enum: ['YUI Compressor', 'clean-css', 'CSSO', 'Sqwish']
            order: 3

        jsMinifier:
            title: 'JS minifier'
            description: 'Select which JavaScript minifier you want to use.'
            type: 'string'
            default: 'YUI Compressor'
            enum: ['YUI Compressor', 'Google Closure Compiler', 'UglifyJS2']
            order: 4

        cssMinifiedFilenamePattern:
            title: 'Filename pattern for minified CSS file'
            description: 'Define the replacement pattern for minified CSS filename. If you want to minify \'Foo.CSS\', you can use $1 for \'Foo\' and $2 for \'CSS\'; The result of pattern \$1.minified.$2\' would be \'Foo.minified.CSS\'.'
            type: 'string'
            default: '$1.min.$2'
            order: 5

        jsMinifiedFilenamePattern:
            title: 'Filename pattern for minified JS file'
            description: 'Define the replacement pattern for minified JS filename. If you want to minify \'Bar.JS\', you can use $1 for \'Bar\' and $2 for \'JS\'; The result of pattern \$1.xyz.$2\' would be \'Bar.xyz.JS\'.'
            type: 'string'
            default: '$1.min.$2'
            order: 6


        # Notification options

        notifications:
            title: 'Notifications'
            description: 'Select which types of notifications you wish to see.'
            type: 'string'
            default: 'Panel'
            enum: ['Panel', 'Notifications', 'Panel, Notifications']
            order: 7

        autoHidePanel:
            title: 'Automatically hide panel on ...'
            description: 'Select on which event the panel should automatically disappear.'
            type: 'string'
            default: 'Success'
            enum: ['Never', 'Success', 'Error', 'Success, Error']
            order: 8

        autoHidePanelDelay:
            title: 'Panel-auto-hide delay'
            description: 'Delay after which panel is automatically hidden'
            type: 'integer'
            default: 3000
            order: 9

        autoHideNotifications:
            title: 'Automatically hide notifications on ...'
            description: 'Select which types of notifications should automatically disappear.'
            type: 'string'
            default: 'Info, Success'
            enum: ['Never', 'Info, Success', 'Error', 'Info, Success, Error']
            order: 10

        showStartMinificationNotification:
            title: 'Show \'Start Minification\' Notification'
            description: 'If enabled a \'Start Minification\' notification is shown.'
            type: 'boolean'
            default: false
            order: 11


        # Extended options

        buffer:
            title: 'Buffer'
            description: 'Only modify the buffer size when you have to compile large files.'
            type: 'integer'
            default: 1000 * 1024
            order: 12


        # Parameters for CSS minifiers

        cssParametersForYUI:
            title: 'CSS → parameters for YUI Compressor'
            description: 'Additional parameters for CSS minifier \'YUI Compressor\'.'
            type: 'string'
            default: ''
            order: 13

        cssParametersForCleanCSS:
            title: 'CSS → parameters for clean-css'
            description: 'Additional parameters for CSS minifier \'clean-css\'.'
            type: 'string'
            default: ''
            order: 14

        cssParametersForCSSO:
            title: 'CSS → parameters for CSSO'
            description: 'Additional parameters for CSS minifier \'CSSO\'.'
            type: 'string'
            default: ''
            order: 15

        cssParametersForSqwish:
            title: 'CSS → parameters for Sqwish'
            description: 'Additional parameters for CSS minifier \'Sqwish\'.'
            type: 'string'
            default: ''
            order: 16


        # Parameters for JS minifiers

        jsParametersForYUI:
            title: 'JS → parameters for YUI Compressor'
            description: 'Additional parameters for JS minifier \'YUI Compressor\'.'
            type: 'string'
            default: ''
            order: 17

        jsParametersForGCC:
            title: 'JS → parameters for Google Closure Compiler'
            description: 'Additional parameters for JS minifier \'Google Closure Compiler\'.'
            type: 'string'
            default: ''
            order: 18

        jsParametersForUglifyJS2:
            title: 'JS → parameters for UglifyJS2'
            description: 'Additional parameters for JS minifier \'UglifyJS2\'.'
            type: 'string'
            default: ''
            order: 19


    atomMinifyView: null


    activate: (state) ->
        @atomMinifyView = new AtomMinifyView(state.atomMinifyViewState)

        atom.commands.add 'atom-workspace',
            'atom-minify:toggle-minify-on-save': =>
                @toggleMinifyOnSave()

            'atom-minify:minify-to-min-file': =>
                @minify(AtomMinifyView.MINIFY_TO_MIN_FILE)

            'atom-minify:minify-direct': =>
                @minify(AtomMinifyView.MINIFY_DIRECT)

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

        @addMenuItems()


    deactivate: ->
        @atomMinifyView.destroy()


    serialize: ->
        atomMinifyViewState: @atomMinifyView.serialize()


    toggleMinifyOnSave: ->
        AtomMinifyView.setOption('minifyOnSave', !AtomMinifyView.getOption('minifyOnSave'))
        if AtomMinifyView.getOption('minifyOnSave')
            atom.notifications.addInfo('Minify: Enabled minification on save')
        else
            atom.notifications.addWarning('Minify: Disabled minification on save')
        @updateMenuItems()


    minify: (method) ->
        @atomMinifyView.minify(method, true)


    selectCssMinifier: (minifier) ->
        validCssMinifiers = ['YUI Compressor', 'clean-css', 'CSSO', 'Sqwish']
        if minifier in validCssMinifiers
            AtomMinifyView.setOption('cssMinifier', minifier)
            atom.notifications.addInfo("Minify: #{minifier} is new CSS minifier")


    selectJsMinifier: (minifier) ->
        validJsMinifiers = ['YUI Compressor', 'Google Closure Compiler', 'UglifyJS2']
        if minifier in validJsMinifiers
            AtomMinifyView.setOption('jsMinifier', minifier)
            atom.notifications.addInfo("Minify: #{minifier} is new JS minifier")


    addMenuItems: ->
        atom.menu.add [ {
            label: 'Packages'
            submenu : [
                {
                    label: 'Minify'
                    submenu : [

                        { label : 'Minify to minified file', command: 'atom-minify:minify-to-min-file' }
                        { label : 'Direct Minification', command: 'atom-minify:minify-direct' }
                        { label : 'Enable minification on save', command: 'atom-minify:toggle-minify-on-save' }
                        {
                            label : 'CSS minifier'
                            submenu : [
                                    { label : 'YUI Compressor', command: 'atom-minify:css-minifier-yui' }
                                    { label : 'clean-css', command: 'atom-minify:css-minifier-clean-css' }
                                    { label : 'CSSO', command: 'atom-minify:css-minifier-csso' }
                                    { label : 'Sqwish', command: 'atom-minify:css-minifier-sqwish' }
                            ]
                        }
                        {
                            label : 'JS minifier'
                            submenu : [
                                    { label : 'YUI Compressor', command: 'atom-minify:js-minifier-yui' }
                                    { label : 'Google Closure Compiler', command: 'atom-minify:js-minifier-gcc' }
                                    { label : 'UglifyJS2', command: 'atom-minify:js-minifier-uglifyjs2' }
                            ]
                        }
                    ]
                }
            ]
        } ]
        @updateMenuItems()


    updateMenuItems: ->
        for menu in atom.menu.template
            if menu.label == 'Packages' || menu.label == '&Packages'
                for submenu in menu.submenu
                    if submenu.label == 'Minify'
                        item = submenu.submenu[2]
                        item.label = (if AtomMinifyView.getOption('minifyOnSave') then 'Disable' else 'Enable') + ' minification on save'

        atom.menu.update()


    closePanel: ->
        @atomMinifyView.hidePanel()
