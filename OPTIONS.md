# Minifier Options

### Table of Contents

1. [Introduction](#introduction)
    1. [Option Format](#option-format)
    2. [Usage](#usage)
2. [Supported Options](#supported-options)
3. [CSS Minifier](#css-minifier)
    1. [clean-css](#clean-css)
    2. [CSSO](#csso)
    3. [Sqwish](#sqwish)
    4. [YUI CSS Compressor](#yui-css-compressor)
4. [JS Minifier](#js-minifier)
    1. [Google Closure Compile](#google-closure-compiler)
    2. [UglifyJS2](#uglifyjs2)
    3. [YUI JS Compressor](#yui-js-compressor)



## Introduction

Since version 0.6.0 minifier options are ready to use! The corresponding options for every minifier are desribed here. **Please let me know if some options are missing or do not work correctly!**

On the one hand, you can define the options by setting them in the atom-minify package options ‒ I call them *global options**. Please ensure that you put it to the right minifier! These global options are used for **every** minification.

On the other hand, you can set a first line parameter and put your options there. These options are used only for minifing a single file.


### Option Format

If you put your settings to global options or to first line parameter, the minifier options must follow the following format:

```
<key1>=<value1> <key2>=<value2> ...
// Spaces before and after equality sign are also allowed:
<key1> = <value1> <key2> = <value2> ...
```

An options starts with the name of the option, an equality sign and the value. The key can contain dots and dashes. The value can contain every sign. If you want ot use spaces, put single or double quotes around the value.

**Example:**

```
charset=utf-8 line-break=72 another-custom-value="This is just a demo"
```


### Usage

If you want to use custom options for every minification it should be set in the package options ‒ I call this options *global options*. You can set options for every minifier separately.

Beside that you can define the options in the first-line-parameter, see [minifierOptions parameter](https://github.com/armin-pfaeffle/atom-minify#minifieroptions). These options are used only for that file in which it is defined.

If you define first-line-parameter options and you have set global options, the first-line-parameter options **replaces** the global ones. But you have the possibilty of extending/overwriting global options by putting a plus before the list of options. Let's use a concrete example for better understanding. I use **YUI JS Compressor** and set `line-break=72` as global options. Here the example options:

```js
/* minifierOption : "nomunge" */
function(document, window, undefined) {
    alert('Hello World!')
}(document, window);
```
This definition leads to an output that **ignores** the line-break option, because the global options are overwritten and only `nomunge` option is used.

```js
/* minifierOption : "+ nomunge" */
function(document, window, undefined) {
    alert('Hello World!')
}(document, window);
```
By inserting the plus before `nomunge`, both global and first-line-parameter options are combined, so line-break **and** nomunge option is used for minification. There is also the possibilty to set a global line-break of 72, and overwrite this option by set a first-line-parameter option of 100.



## Supported Options

### CSS Minifiers

#### clean-css

Documentation: https://github.com/jakubpawlowicz/clean-css#how-to-use-clean-css-api

* `advanced = [ true | false ]`  
    Set to false to disable advanced optimizations ‒ selector & property merging, reduction, etc.

* `aggressiveMerging = [ true | false ]`  
    Set to false to disable aggressive merging of properties.

* `compatibility = <value>`  
    Enables compatibility mode, see [below for more examples](https://github.com/jakubpawlowicz/clean-css#how-to-set-a-compatibility-mode).

* `inliner = <value>`  
    A hash of options for `@import` inliner, see [test/protocol-imports-test.js](https://github.com/jakubpawlowicz/clean-css/blob/master/test/protocol-imports-test.js#L372) for examples, or [this comment](https://github.com/jakubpawlowicz/clean-css/issues/612#issuecomment-119594185) for a proxy use case.

* `keepBreaks = [ true | false ]`  
    Whether to keep line breaks (default is false).

* `keepSpecialComments = <value>`  
    `*` for keeping all (default), `1` for keeping first one only, `0` for removing all.

* `mediaMerging = [ true | false ]`  
    Whether to merge `@media` at-rules (default is true).

* `processImport = [ true | false ]`  
    Whether to process `@import` rules.

* `processImportFrom = <value>`  
    A list of `@import` rules, can be `['all']` (default), `['local']`, `['remote']`, or a blacklisted path e.g. `['!fonts.googleapis.com']`.

* `rebase = [ true | false ]`  
    Set to false to skip URL rebasing.

* `relativeTo = <value>`  
    Path to **resolve** relative `@import` rules and URLs.

* `restructuring = [ true | false ]`  
    Set to false to disable restructuring in advanced optimizations.

* `root = <value>`  
    Path to **resolve** absolute `@import` rules and **rebase** relative URLs.

* `roundingPrecision = <value>`  
    Rounding precision; defaults to `2`; `-1` disables rounding.

* `semanticMerging = [ true | false ]`  
    Set to true to enable semantic merging mode which assumes BEM-like content (default is false as it's highly likely this will break your stylesheets ‒ **use with caution**!).

* `shorthandCompacting = [ true | false ]`  
    Set to false to skip shorthand compacting (default is true unless sourceMap is set when it's false).

* `sourceMap = <value>`  
    Exposes source map under `sourceMap` property, e.g. `new CleanCSS().minify(source).sourceMap` (default is false) If input styles are a product of CSS preprocessor (Less, Sass) an input source map can be passed as a string.

* `sourceMapInlineSources = [ true | false ]`  
    Set to true to inline sources inside a source map's `sourcesContent` field (defaults to false). It is also required to process inlined sources from input source maps.

* `target = <path>`  
    Path to a folder or an output file to which **rebase** all URLs.


#### CSSO

Documentation: https://github.com/css/csso/blob/master/docs/usage/usage.en.md#as-an-npm-module

* `restructureOff`  
    Set this options to turn structure minimization off.


#### Sqwish

Documentation: https://github.com/ded/sqwish#strict-optimizations

* `strict`  
    Aside from regular minification, in `strict` mode Sqwish will combine duplicate selectors and merge duplicate properties.


#### YUI CSS Compressor

Documentation: http://yui.github.io/yuicompressor/

* `charset = <charset>`  
    Read the input file using <charset>.

* `line-break = <column>`  
    Insert a line break after the specified column number.




### JS Minifiers


#### Google Closure Compiler

Documentation: https://developers.google.com/closure/compiler/docs/gettingstarted_app

* `angular_pass`  
    Generate $inject properties for AngularJS for functions annotated with @ngInject.

* `charset = <value>`  
    Input and output charset for all files. By default, we accept UTF-8 as input and output US_ASCII.

* `closure_entry_point = <value>`  
    Entry points to the program. Must be goog.provide'd symbols. Any goog.provide'd symbols that are not a transitive dependency of the entry points will be removed. Files without goog.provides, and their dependencies, will always be left in. If any entry points are specified, then the manage_closure_dependencies option will be set to true and all files will be sorted in dependency order.

* `common_js_entry_module = <value>`  
    Root of your common JS dependency hierarchy. Your main script.

* `common_js_module_path_prefix = <value>`  
    Path prefix to be removed from CommonJS module names.

* `compilation_level = <value>` or `O = <value>`  
    Specifies the compilation level to use. Options: `WHITESPACE_ONLY`, `SIMPLE`, `ADVANCED`.

* `conformance_configs = <value>`  
    A list of JS Conformance configurations in text protocol buffer format.

* `create_renaming_reports = [ true | false ]`  
    If true, variable renaming and property renaming report files will be produced as {binary name}_vars_renaming_report.out and {binary name}_props_renaming_report.out. Note that this flag cannot be used in conjunction with either variable_renaming_report or property_renaming_report.

* `create_source_map = <value>`  
    If specified, a source map file mapping the generated source files back to the original source file will be output to the specified path. The `%outname%` placeholder will expand to the name of the output file that the source map corresponds to.

* `dart_pass`  
    Rewrite Dart Dev Compiler output to be compiler-friendly.

* `debug`  
    Enable debugging options.

* `define = <value>` or `D = <value>`  
    Override the value of a variable annotated @define. The format is <name>[=<val>], where <name> is the name of a @define variable and <val> is a boolean, number, or a single-quot ed string that contains no single quotes. If [=<val>] is omitted, the variable is marked true.

* `env = [BROWSER | CUSTOM]`  
    Determines the set of builtin externs to load. Options: `BROWSER`, `CUSTOM`. Defaults to `BROWSER`.

* `export_local_property_definitions`  
    Generates export code for local properties marked with @export.

* `externs = <value>`  
    The file containing JavaScript externs. You may specify multiple.

* `extra_annotation_name = <value>`  
    A whitelist of tag names in JSDoc. You may specify multiple.

* `flagfile = <value>`  
    A file containing additional command-line options.

* `formatting = [PRETTY_PRINT | PRINT_INPUT_DELIMITER | SINGLE_QUOTES]`  
    Specifies which formatting options, if any, should be applied to the output JS. Options: `PRETTY_PRINT`, `PRINT_INPUT_DELIMITER`, `SINGLE_QUOTES`.

* `generate_exports`  
    Generates export code for those marked with @export.

* `instrumentation_template = <value>`  
    A file containing an instrumentation template.

* `js_module_root = <value>`  
    Path prefixes to be removed from ES6 & CommonJS modules.

* `jscomp_error = <value>`  
    Make the named class of warnings an error. Options: accessControls, ambiguousFunctionDecl, checkEventfulObjectDisposal, checkRegExp, checkTypes, checkVars, conformanceViolations, const, constantProperty, deprecated, deprecatedAnnotations, duplicateMessage, es3, es5Strict, externsValidation, fileoverviewTags, globalThis, inferredConstCheck, internetExplorerChecks, invalidCasts, misplacedTypeAnnotation, missingGetCssName, missingProperties, missingProvide, missingRequire, missingReturn, msgDescriptionsnewCheckTypes, nonStandardJsDocs, reportUnknownTypes, suspiciousCode, strictModuleDepCheck, typeInvalidation, undefinedNames, undefinedVars, unknownDefines, unnecessaryCasts, uselessCode, useOfGoogBase, visibility. `*` adds all supported.

* `jscomp_off = <value>`  
    Turn off the named class of warnings. Options: accessControls, ambiguousFunctionDecl, checkEventfulObjectDisposal, checkRegExp, checkTypes, checkVars, conformanceViolations, const, constantProperty, deprecated, deprecatedAnnotations, duplicateMessage, es3, es5Strict, externsValidation, fileoverviewTags, globalThis, inferredConstCheck, internetExplorerChecks, invalidCasts, misplacedTypeAnnotation, missingGetCssName, missingProperties, missingProvide, missingRequire, missingReturn, msgDescriptionsnewCheckTypes, nonStandardJsDocs, reportUnknownTypes, suspiciousCode, strictModuleDepCheck, typeInvalidation, undefinedNames, undefinedVars, unknownDefines, unnecessaryCasts, uselessCode, useOfGoogBase, visibility. `*` adds all supported.

* `jscomp_warning = <value>`  
    Make the named class of warnings a normal warning. Options: accessControls, ambiguousFunctionDecl, checkEventfulObjectDisposal, checkRegExp, checkTypes, checkVars, conformanceViolations, const, constantProperty, deprecated, deprecatedAnnotations, duplicateMessage, es3, es5Strict, externsValidation, fileoverviewTags, globalThis, inferredConstCheck, internetExplorerChecks, invalidCasts, misplacedTypeAnnotation, missingGetCssName, missingProperties, missingProvide, missingRequire, missingReturn, msgDescriptionsnewCheckTypes, nonStandardJsDocs, reportUnknownTypes, suspiciousCode, strictModuleDepCheck, typeInvalidation, undefinedNames, undefinedVars, unknownDefines, unnecessaryCasts, uselessCode, useOfGoogBase, visibility. `*` adds all supported.

* `jszip = <value>`  
    The JavaScript zip filename. You may specify multiple.

* `language_in = <value>`  
    Sets what language spec that input sources conform. Options: `ECMASCRIPT3` (default), `ECMASCRIPT5`, `ECMASCRIPT5_STRICT`, `ECMASCRIPT6`, `ECMASCRIPT6_STRICT`, `ECMASCRIPT6_TYPED` (experimental).

* `language_out = <value>`  
    Sets what language spec the output should conform to. If omitted, defaults to the value of `language_in`. Options: `ECMASCRIPT3`, `ECMASCRIPT5`, `ECMASCRIPT5_STRICT`, `ECMASCRIPT6_TYPED` (experimental).

* `logging_level = <value>`  
    The logging level (standard java.util. logging.Level values) for Compiler progress. Does not control errors or warnings for the JavaScript code under compilation.

* `manage_closure_dependencies`  
    Automatically sort dependencies so that a file that goog.provides symbol X will always come before a file that goog.requires symbol X. If an input provides symbols, and those symbols are never required, then that input will not be included in the compilation.

* `module = <value>`  
    A JavaScript module specification. The format is <name>:<num-js-files>[:[<dep>,...][:]]]. Module names must be unique. Each dep is the name of a module that this module depends on. Modules must be listed in dependency order, and JS source files must be listed in the corresponding order. Where * `module flags occur in relation to `js` flags is unimportant. <num-js-files> may be set to 'auto' for the first module if it has no dependencies. Provide the value 'auto' to trigger module creation from CommonJSmodules.

* `module_output_path_prefix = <value>`  
    Prefix for filenames of compiled JS modules. <module-name>.js will be appended to this prefix. Directories will be created as needed. Use with `module`.

* `module_wrapper = <value>`  
    An output wrapper for a JavaScript module (optional). The format is <name>:<wrapper>. The module name must correspond with a module specified using `module`. The wrapper must contain %s as the code placeholder. The `%basename%` placeholder can also be used to substitute the base name of the module output file.

* `new_type_inf`  
    Checks for type errors using the new type inference algorithm.

* `only_closure_dependencies`  
    Only include files in the transitive dependency of the entry points (specified by `closure_entry_point`). Files that do not provide dependencies will be removed. This supersedes `manage_closure_dependencies`.

* `output_manifest = <value>`  
    Prints out a list of all the files in the compilation. If `manage_closure_dependencies` is on, this will not include files that got dropped because they were not required. The `%outname%` placeholder expands to the JS output file. If you're using modularization, using `%outname%` will create a manifest for each module.

* `output_module_dependencies = <value>`  
    Prints out a JSON file of dependencies between modules.

* `output_wrapper = <value>`  
    Interpolate output into this string at the place denoted by the marker token `%output%`. Use marker token `%output|jsstring%` to do js string escaping on the output.

* `output_wrapper_file = <value>`  
    Loads the specified file and passes the file contents to the `output_wrap` per flag, replacing the value if it exists.

* `polymer_pass`  
    Rewrite Polymer classes to be compiler-friendly.

* `print_ast`  
    Prints a dot file describing the internal abstract syntax tree and exits.

* `print_pass_graph`  
    Prints a dot file describing the passes that will get run and exits.

* `print_tree`  
    Prints out the parse tree and exits.

* `process_closure_primitives = [ true | false ]`  
    Processes built-ins from the Closure library, such as goog.require(), goog.provide(), and goog.exportSymbol(). True by default.

* `process_common_js_modules`  
    Process CommonJS modules to a concatenable form.

* `process_jquery_primitives`  
    Processes built-ins from the Jquery library, such as jQuery.fn and jQuery.extend().

* `property_renaming_report = <value>`  
    File where the serialized version of the property renaming map produced should be saved.

* `rename_prefix_namespace = <value>`  
    Specifies the name of an object that will be used to store all non-extern globals.

* `source_map_format = [DEFAULT | V3]`  
    The source map format to produce. Options are `V3` and `DEFAULT`, which are equivalent.

* `source_map_input = <value>`  
    Source map locations for input files, separated by a '|', (i.e. input-file-path|input-source-map).

* `source_map_location_mapping = <value>`  
    Source map location mapping separated by a '|' (i.e. filesystem-path|webserver-path).

* `summary_detail_level = <value>`  
    Controls how detailed the compilation summary is. Values: `0` (never print summary), `1` (print summary only if there are errors or warnings), `2` (print summary if the 'checkTypes' diagnostic group is enabled, see `jscomp_warning`), `3` (always print summary). The default level is `1`.

* `third_party`  
    Check source validity but do not enforce Closure style rules and conventions.

* `transform_amd_modules`  
    Transform AMD to CommonJS modules.

* `translations_file = <value>`  
    Source of translated messages. Currently only supports XTB.

* `translations_project = <value>`  
    Scopes all translations to the specified project.When specified, we will use different message ids so that messages in different projects can have different translations.

* `use_types_for_optimization`  
    Enable or disable the optimizations based on available type information. Inaccurate type annotations may result in incorrect results.

* `variable_renaming_report = <value>`  
    File where the serialized version of the variable renaming map produced should be saved.

* `warning_level = [QUIET | DEFAULT | VERBOSE]` or `W = <value>`  
    Specifies the warning level to use. Options: `QUIET`, `DEFAULT`, `VERBOSE`.

* `warnings_whitelist_file = <value>`  
    A file containing warnings to suppress. Each line should be of the form <file-name>:<line-number>?  <warning-description>.


#### UglifyJs2

**General**

* `mangle`  
    Pass false to skip mangling names.

**Code generator options**

* `indent_start = <value>`  
    Start indentation on every line (only when `beautify`). Default: 0.

* `indent_level = <value>`  
    Indentation level (only when `beautify`). Default: 4.

* `quote_keys = [ true | false ]`  
    Quote all keys in object literals? Default: false.

* `space_colon = [ true | false ]`  
    Add a space after colon signs? Default: true.

* `ascii_only = [ true | false ]`  
    Output ASCII-safe? (encodes Unicode characters as ASCII). Default: false.

* `inline_script = [ true | false ]`  
    Escape "</script"? Default: false.

* `width = <value>`  
    Informative maximum line width (for beautified output). Default: 80.

* `max_line_len = <value>`  
    Maximum line length (for non-beautified output). Default: 32000.

* `ie_proof = [ true | false ]`  
    Output IE-safe code? Default: true.

* `beautify = [ true | false ]`  
    Beautify output? Default: false.

* `source_map = <value>`  
    Output a source map.

* `bracketize = [ true | false ]`  
    Use brackets every time? Default: false.

* `comments = [ true | false ]`  
    Output comments? Default: false.

* `semicolons = [ true | false ]`  
    Use semicolons to separate statements? (otherwise, newlines) Default: true.


**Compressor options**

* `sequences = [ true | false ]`  
    Join consecutive statemets with the "comma operator". Default: true.

* `properties = [ true | false ]`  
    Optimize property access: a["foo"] → a.foo. Default: true.

* `dead_code = [ true | false ]`  
    Discard unreachable code. Default: true.

* `drop_debugger = [ true | false ]`  
    Discard “debugger” statements. Default: true.

* `unsafe = [ true | false ]`  
    Some unsafe optimizations (see below). Default: false.

* `conditionals = [ true | false ]`  
    Optimize if-s and conditional expressions. Default: true.

* `comparisons = [ true | false ]`  
    Optimize comparisons. Default: true.

* `evaluate = [ true | false ]`  
    Evaluate constant expressions. Default: true.

* `booleans = [ true | false ]`  
    Optimize boolean expressions. Default: true.

* `loops = [ true | false ]`  
    Optimize loops. Default: true.

* `unused = [ true | false ]`  
    Drop unused variables/function. Default: true.s

* `hoist_funs = [ true | false ]`  
    Hoist function declarations. Default: true.

* `hoist_vars = [ true | false ]`  
    Hoist variable declarations. Default: false.

* `if_return = [ true | false ]`  
    Optimize if-s followed by return/continue. Default: true.

* `join_vars = [ true | false ]`  
    Join var declarations. Default: true.

* `cascade = [ true | false ]`  
    Try to cascade `right` into `left` in sequences. Default: true.

* `side_effects = [ true | false ]`  
    Drop side-effect-free statements. Default: true.

* `warnings = [ true | false ]`  
    Warn about potentially dangerous optimizations/code. Default: true.

* `global_defs = [ true | false ]`  
    Global definitions. Default: {}.


#### YUI JS Compressor

* `charset = <value>`  
    Read the input file using <charset>.

* `line-break = <column>`  
    Insert a line break after the specified column number.

* `nomunge`  
    Minify only, do not obfuscate.

* `preserve-semi`  
    Preserve all semicolons.

* `disable-optimizations`  
    Disable all micro optimizations.
