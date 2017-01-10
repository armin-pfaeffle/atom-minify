{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class GccMinifier extends BaseMinifier

    getName: ()->
        return 'Google Closure Compiler'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        @checkJavaInstalled (javaIsInstalled, version) =>
            if not javaIsInstalled
                error = 'You need to install Java in order to use Google Closure Compiler or set a correct path to Java exectuable in options.'
                callback(minified, error)
            else
                exec = require('child_process').exec

                java = if @options.absoluteJavaPath then '"' + @options.absoluteJavaPath + '"' else 'java'
                command = java + ' -server -XX:+TieredCompilation -jar -Xss2048k "' + __dirname + '/../_bin/closure-compiler-v20161201.jar"'

                command += ' --js "' + inputFilename + '"'
                command += ' --js_output_file "' + outputFilename + '"'

                options = @prepareMinifierOptions()
                command += ' ' + options

                exec command,
                    maxBuffer: @options.buffer,
                    (err, stdout, stderr) =>
                        if err
                            error = err.toString()
                        else
                            fs = require('fs')
                            minified = fs.readFileSync(outputFilename).toString()

                        callback(minified, error)


    prepareMinifierOptions: () ->
        options = ''

        if @options.minifierOptions.angular_pass isnt undefined
            options += ' --angular_pass'

        if @options.minifierOptions.charset isnt undefined
            options += ' --charset ' + @options.minifierOptions.charset

        if @options.minifierOptions.closure_entry_point isnt undefined
            options += ' --closure_entry_point ' + @options.minifierOptions.closure_entry_point

        if @options.minifierOptions.common_js_entry_module  isnt undefined
            options += ' --common_js_entry_module ' + @options.minifierOptions.common_js_entry_module

        if @options.minifierOptions.common_js_module_path_prefix isnt undefined
            options += ' --common_js_module_path_prefix ' + @options.minifierOptions.common_js_module_path_prefix

        if @options.minifierOptions.compilation_level isnt undefined
            options += ' --compilation_level ' + @options.minifierOptions.compilation_level

        if @options.minifierOptions.O isnt undefined
            options += ' -O ' + @options.minifierOptions.O

        if @options.minifierOptions.conformance_configs isnt undefined
            options += ' --conformance_configs ' + @options.minifierOptions.conformance_configs

        if @options.minifierOptions.create_renaming_reports isnt undefined
            options += ' --create_renaming_reports'

        if @options.minifierOptions.create_source_map isnt undefined
            options += ' --create_source_map ' + @options.minifierOptions.create_source_map

        if @options.minifierOptions.dart_pass isnt undefined
            options += ' --dart_pass'

        if @options.minifierOptions.debug isnt undefined
            options += ' --debug'

        if @options.minifierOptions.define isnt undefined
            options += ' --define ' + @options.minifierOptions.define

        if @options.minifierOptions.D isnt undefined
            options += ' -D ' + @options.minifierOptions.D

        if @options.minifierOptions.env isnt undefined
            options += ' --env ' + @options.minifierOptions.env

        if @options.minifierOptions.export_local_property_definitions isnt undefined
            options += ' --export_local_property_definitions'

        if @options.minifierOptions.externs isnt undefined
            options += ' --externs ' + @options.minifierOptions.externs

        if @options.minifierOptions.extra_annotation_name isnt undefined
            options += ' --extra_annotation_name ' + @options.minifierOptions.extra_annotation_name

        if @options.minifierOptions.flagfile isnt undefined
            options += ' --flagfile ' + @options.minifierOptions.flagfile

        if @options.minifierOptions.formatting isnt undefined
            options += ' --formatting ' + @options.minifierOptions.formatting

        if @options.minifierOptions.generate_exports isnt undefined
            options += ' --generate_exports'

        if @options.minifierOptions.instrumentation_template isnt undefined
            options += ' --instrumentation_template ' + @options.minifierOptions.instrumentation_template

        if @options.minifierOptions.js_module_root isnt undefined
            options += ' --js_module_root ' + @options.minifierOptions.js_module_root

        if @options.minifierOptions.jscomp_error isnt undefined
            options += ' --jscomp_error ' + @options.minifierOptions.jscomp_error

        if @options.minifierOptions.jscomp_off isnt undefined
            options += ' --jscomp_off ' + @options.minifierOptions.jscomp_off

        if @options.minifierOptions.jscomp_warning isnt undefined
            options += ' --jscomp_warning ' + @options.minifierOptions.jscomp_warning

        if @options.minifierOptions.jszip isnt undefined
            options += ' --jszip ' + @options.minifierOptions.jszip

        if @options.minifierOptions.language_in isnt undefined
            options += ' --language_in ' + @options.minifierOptions.language_in

        if @options.minifierOptions.language_out isnt undefined
            options += ' --language_out ' + @options.minifierOptions.language_out

        if @options.minifierOptions.logging_level isnt undefined
            options += ' --logging_level ' + @options.minifierOptions.logging_level

        if @options.minifierOptions.manage_closure_dependencies isnt undefined
            options += ' --manage_closure_dependencies'

        if @options.minifierOptions.module isnt undefined
            options += ' --module ' + @options.minifierOptions.module

        if @options.minifierOptions.module_output_path_prefix isnt undefined
            options += ' --module_output_path_prefix ' + @options.minifierOptions.module_output_path_prefix

        if @options.minifierOptions.module_wrapper isnt undefined
            options += ' --module_wrapper ' + @options.minifierOptions.module_wrapper

        if @options.minifierOptions.new_type_inf isnt undefined
            options += ' --new_type_inf'

        if @options.minifierOptions.only_closure_dependencies isnt undefined
            options += ' --only_closure_dependencies'

        if @options.minifierOptions.output_manifest isnt undefined
            options += ' --output_manifest ' + @options.minifierOptions.output_manifest

        if @options.minifierOptions.output_module_dependencies isnt undefined
            options += ' --output_module_dependencies ' + @options.minifierOptions.output_module_dependencies

        if @options.minifierOptions.output_wrapper isnt undefined
            options += ' --output_wrapper ' + @options.minifierOptions.output_wrapper

        if @options.minifierOptions.output_wrapper_file isnt undefined
            options += ' --output_wrapper_file ' + @options.minifierOptions.output_wrapper_file

        if @options.minifierOptions.polymer_pass isnt undefined
            options += ' --polymer_pass'

        if @options.minifierOptions.print_ast isnt undefined
            options += ' --print_ast'

        if @options.minifierOptions.print_pass_graph isnt undefined
            options += ' --print_pass_graph'

        if @options.minifierOptions.print_tree isnt undefined
            options += ' --print_tree'

        if @options.minifierOptions.process_closure_primitives isnt undefined
            options += ' --process_closure_primitives'

        if @options.minifierOptions.process_common_js_modules isnt undefined
            options += ' --process_common_js_modules'

        if @options.minifierOptions.process_jquery_primitives isnt undefined
            options += ' --process_jquery_primitives'

        if @options.minifierOptions.property_renaming_report isnt undefined
            options += ' --property_renaming_report ' + @options.minifierOptions.property_renaming_report

        if @options.minifierOptions.rename_prefix_namespace isnt undefined
            options += ' --rename_prefix_namespace ' + @options.minifierOptions.rename_prefix_namespace

        if @options.minifierOptions.source_map_format isnt undefined
            options += ' --source_map_format ' + @options.minifierOptions.source_map_format

        if @options.minifierOptions.source_map_input isnt undefined
            options += ' --source_map_input ' + @options.minifierOptions.source_map_input

        if @options.minifierOptions.source_map_location_mapping isnt undefined
            options += ' --source_map_location_mapping ' + @options.minifierOptions.source_map_location_mapping

        if @options.minifierOptions.summary_detail_level isnt undefined
            options += ' --summary_detail_level ' + @options.minifierOptions.summary_detail_level

        if @options.minifierOptions.third_party isnt undefined
            options += ' --third_party'

        if @options.minifierOptions.transform_amd_modules isnt undefined
            options += ' --transform_amd_modules'

        if @options.minifierOptions.translations_file isnt undefined
            options += ' --translations_file ' + @options.minifierOptions.translations_file

        if @options.minifierOptions.translations_project isnt undefined
            options += ' --translations_project ' + @options.minifierOptions.translations_project

        if @options.minifierOptions.use_types_for_optimization isnt undefined
            options += ' --use_types_for_optimization'

        if @options.minifierOptions.variable_renaming_report isnt undefined
            options += ' --variable_renaming_report ' + @options.minifierOptions.variable_renaming_report

        if @options.minifierOptions.warning_level isnt undefined
            options += ' --warning_level ' + @options.minifierOptions.warning_level

        if @options.minifierOptions.W isnt undefined
            options += ' -W ' + @options.minifierOptions.W

        if @options.minifierOptions.warnings_whitelist_file isnt undefined
            options += ' --warnings_whitelist_file ' + @options.minifierOptions.warnings_whitelist_file

        return options
