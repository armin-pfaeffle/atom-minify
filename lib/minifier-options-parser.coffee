module.exports =
class AtomMinifyMinifierOptionsParser

    parse: (contentType, options, inlineParameters) ->
        @contentType = contentType
        @options = options
        @inlineParameters = inlineParameters

        optionsStr = @getMinifierOptionsStr()
        regex = /(?:([\w-\.]+)(?:\s*=\s*(?:(?:'(.*?)')|(?:"(.*?)")|([^ ]+)))?)*/g
        options = []
        while (match = regex.exec(optionsStr)) != null
            if match.index == regex.lastIndex
                regex.lastIndex++

            if match[1] != undefined
                key = match[1].trim()
                value = if match[2] then match[2] else if match[3] then match[3] else match[4]
                options[key] = @parseValue(value)

        return options


    getMinifierOptionsStr: () ->
        options = @getGlobalMinifierOptions()

        inlineParameterOptionsStr = @getMinifierOptionsFromInlineParameter()
        if typeof inlineParameterOptionsStr is 'string' and inlineParameterOptionsStr.length > 0
            # Check if first character is a plus ("+"), so it means that parameters for minifier
            # has to be combined
            if inlineParameterOptionsStr[0] is '+'
                options += inlineParameterOptionsStr.substr(1)

            # ... else we replace the global minifier options
            else
                options = inlineParameterOptionsStr

        return options


    getGlobalMinifierOptions: () =>
        switch @contentType
            when 'css'
                switch @options.cssMinifier
                    when 'clean-css' then key = 'cssParametersForCleanCSS'
                    when 'csso' then key = 'cssParametersForCSSO'
                    when 'sqwish' then key = 'cssParametersForSqwish'
                    when 'yui-css' then key = 'cssParametersForYUI'

            when 'js'
                switch @options.jsMinifier
                    when 'gcc' then key = 'jsParametersForGCC'
                    when 'uglify-js' then key = 'jsParametersForUglifyJS2'
                    when 'yui-js' then key = 'jsParametersForYUI'

        return @options[key]


    getMinifierOptionsFromInlineParameter: ()=>
        options = undefined
        if typeof @inlineParameters.minifierOptions is 'string' and @inlineParameters.minifierOptions.length > 0
            options = @inlineParameters.minifierOptions
        else if typeof @inlineParameters.options is 'string' and @inlineParameters.options.length > 0
            options = @inlineParameters.options
        return options


    parseValue: (value) ->
        # undefined is a special value that means, that the key is defined, but no value
        if value is undefined
            return true

        value = value.trim()

        if value in [true, 'true', 'yes']
            return true

        if value in [false, 'false', 'no']
            return false

        if isFinite(value)
            if value.indexOf('.') > -1
                return parseFloat(value)
            else
                return parseInt(value)

        # TODO: Extend for array and objects?

        return value
