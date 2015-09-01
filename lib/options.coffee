module.exports =
class AtomMinifyOptions

    @OPTIONS_PREFIX = 'atom-minify.'


    constructor: () ->
        @initialize()


    @get: (name) ->
        return atom.config.get(AtomMinifyOptions.OPTIONS_PREFIX + name)


    @set: (name, value) ->
        atom.config.set(AtomMinifyOptions.OPTIONS_PREFIX + name, value)


    @unset: (name) ->
        atom.config.unset(AtomMinifyOptions.OPTIONS_PREFIX + name)


    initialize: () ->
        # General options
        @showSavingInfo = AtomMinifyOptions.get('showSavingInfo')
        @checkOutputFileAlreadyExists = AtomMinifyOptions.get('checkOutputFileAlreadyExists')
        @checkAlreadyMinifiedFile = AtomMinifyOptions.get('checkAlreadyMinifiedFile')

        # Extended options
        @outputPath = AtomMinifyOptions.get('outputPath')
        @buffer = AtomMinifyOptions.get('buffer')

        # CSS options
        @cssMinifier = @parseCssMinifier(AtomMinifyOptions.get('cssMinifier'))
        @cssMinifiedFilenamePattern = AtomMinifyOptions.get('cssMinifiedFilenamePattern')
        @cssParametersForYUI = AtomMinifyOptions.get('cssParametersForYUI')
        @cssParametersForCleanCSS = AtomMinifyOptions.get('cssParametersForCleanCSS')
        @cssParametersForCSSO = AtomMinifyOptions.get('cssParametersForCSSO')
        @cssParametersForSqwish = AtomMinifyOptions.get('cssParametersForSqwish')

        # JS options
        @jsMinifier = @parseJsMinifier(AtomMinifyOptions.get('jsMinifier'))
        @jsMinifiedFilenamePattern = AtomMinifyOptions.get('jsMinifiedFilenamePattern')
        @jsParametersForYUI = AtomMinifyOptions.get('jsParametersForYUI')
        @jsParametersForGCC = AtomMinifyOptions.get('jsParametersForGCC')
        @jsParametersForUglifyJS2 = AtomMinifyOptions.get('jsParametersForUglifyJS2')

        # Notification options
        @showInfoNotification = AtomMinifyOptions.get('notifications') in ['Notifications', 'Panel, Notifications']
        @showSuccessNotification = AtomMinifyOptions.get('notifications') in ['Notifications', 'Panel, Notifications']
        @showErrorNotification = AtomMinifyOptions.get('notifications') in ['Notifications', 'Panel, Notifications']

        @autoHideInfoNotification = AtomMinifyOptions.get('autoHideNotifications') in ['Info, Success', 'Info, Success, Error']
        @autoHideSuccessNotification = AtomMinifyOptions.get('autoHideNotifications') in ['Info, Success', 'Info, Success, Error']
        @autoHideErrorNotification = AtomMinifyOptions.get('autoHideNotifications') in ['Error', 'Info, Success, Error']

        @showPanel = AtomMinifyOptions.get('notifications') in ['Panel', 'Panel, Notifications']

        @autoHidePanelOnSuccess = AtomMinifyOptions.get('autoHidePanel') in ['Success', 'Success, Error']
        @autoHidePanelOnError = AtomMinifyOptions.get('autoHidePanel') in ['Error', 'Success, Error']
        @autoHidePanelDelay = AtomMinifyOptions.get('autoHidePanelDelay')

        @showStartMinificationNotification = AtomMinifyOptions.get('showStartMinificationNotification')

        # Advanced options
        @absoluteJavaPath = AtomMinifyOptions.get('absoluteJavaPath')


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
            when 'UglifyJS2' then return 'uglify-js'
            else return null
