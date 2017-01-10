# atom-minify

Minifies JS and CSS files, optionally on save; now supporting inline-parameters and minifier options.

---

Because [minifier](https://atom.io/packages/minifier) is no longer maintained, I created [atom-minify](https://atom.io/packages/atom-minify) which includes **four CSS and three JS minifiers**. Another feature is the flexible configuration which should give you full control over minification and created files. Inline-parameters complete the way of defining the output.



## Requirements

When you want to use **YUI Compressor** or **Google Closure Compiler**, you must install [Java](https://www.java.com/download/). If Java is not present, you will see an error message.



## Usage

#### Minify on save

Beside shortcuts and access via menu, which is described above, you can enable option [Minify on save](#minify-on-save) (shortcut: `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`), so everytime you save a CSS or JavaScript file, it is minified **to a new minified file**. The filename can be configured by a filename pattern (by options [1](#css--filename-pattern-for-minified-file) / [2](#js--filename-pattern-for-minified-file) or by [inline parameter](#filenamepattern)).

Alternatively you can use [minifyOnSave](#minifyOnSave) parameter to control this behaviour.

#### Usage by shortcut or menu
You can use two shortcuts to access the **two different minification functionalites**:

1. `ctrl-shift-m`: **Minify an existant and opened file to a new file** (see options [1](#css--filename-pattern-for-minified-file) / [2](#js--filename-pattern-for-minified-file) or by [inline parameter](#filenamepattern)). If file already exists, content is overwritten.

2. `alt-shift-m` / `cmd-shift-m`: **Direct minification of content** which means that visible CSS or JavaScript text is replaced by its minified version. So you can open a new tab, paste your code and minify it without saving any file.

Beside the shortcuts you also have the possibility to access these actions by menu:
- `Package` → `Minify` → `Minify to minified file`
- `Package` → `Minify` → `Direct Minification`.

#### 4+3 minifiers
With this package you can select between **four CSS and three JS minifiers**. Especially when you don't want to install Java on your system, these feature is great for you. There even exists [predefined shortcuts](#predefined-shortcuts) for instant changing the minifier.

#### Options & parameters
Beside the basic functionality, have a look at the [options](#options). You can configure a lot of things ;)

Since version 0.3 you have the possibility to use [inline-parameters](#inline-parameters), defined as comment in the first line of you CSS or JS file. With these parameters you can overwrite the global options.



## Options

- #### Minify on save
    This option en-/disables minification on save. This is especially useful when you want to create minified files everytime you save a CSS or JavaScript file.  
    **Shortcut for en-/disable this option**: `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`  
    *__Default__: false*

- #### Show saving info
    If enabled some information about saving are shown in notification or panel.  
    *__Default__: true*

- #### Ask for overwriting already existent minified files
    If enabled atom-minify asks you if you want to overwrite the target output file if it already exists.  
    *__Default__: false*

- #### Ask for minification of already minified files
    If enabled current filename is checked for containing `.min.`, `.minified.` and `.compressed.`. If so, atom-minify assumes that content is already minified and asks you if you want to minify the file again.  
    *__Default__: true*

- #### Show Minify-item in Tree View context menu
    If enabled you can minify a file via Tree View context menu. You can choose between showing the item on every file or only on CSS and JavaScript files.  
    *__Default__: Only on CSS and JS files*

- #### ~~General output path~~
    ~~Defines a general output path for minified files, e.g. min/dev/ or compressed. You can use an absolute or relative path. Have a look at the inline parameter outputPath which should be more suitable in most cases.~~

    *Removed since version 0.7.0. Please use filename patterns for defining relative or absolute output paths with filename.*

- #### Buffer
    Only modify the buffer size when you have to compile large files, [see node-minify documentation](https://www.npmjs.com/package/node-minify#max-buffer-size).  
    *__Default__: 1000 \* 1024*

- #### CSS → Minifier
    Defines which CSS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [clean-css](https://github.com/GoalSmashers/clean-css), [CSSO](https://github.com/css/csso), [Sqwish](https://github.com/ded/sqwish).  
    **See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
    *__Default__: YUI Compressor*

- #### CSS → Filename pattern for minified file
    Defines the replacement pattern for minified CSS filename. You can use two placeholders: `$1` for filename without extension, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Foo.CSS` the minified filename `Foo.min.CSS`.  
    *__Default__: $1.min.$2*

    Example:
    ```
    Relative path:
    ../css/min/$1.min.$2

    Absolute path:
    /path/to/your/project/css/$1.min.$2
    ```

- #### CSS → Options for YUI Compressor
    Custom options for CSS minifier **YUI Compressor**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### CSS → Options for clean-css
    Custom options for CSS minifier **clean-css**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### CSS → Options for CSSO
    Custom parameters for CSS minifier **CSSO**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### CSS → Options for Sqwish
    Custom options for CSS minifier **Sqwish**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### JS → Minifier
    Defines which JS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [Google Closure Compiler](https://developers.google.com/closure/compiler/), [UglifyJS2](https://github.com/mishoo/UglifyJS2).  
    **See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
    *__Default__: YUI Compressor*

- #### JS → Filename pattern for minified file
    Defines the replacement pattern for minified JS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Bar.JS` the minified filename `Bar.min.JS`.  
    *__Default__: $1.min.$2*

    Example:
    ```
    Relative path:
    ../css/min/$1.min.$2

    Absolute path:
    /path/to/your/project/css/$1.min.$2
    ```

- #### JS → Options for YUI Compressor
    Custom options for CSS minifier **YUI Compressor**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### JS → Options for Google Closure Compiler
    Custom options for CSS minifier **Google Closure Compiler**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### JS → Options for UglifyJS2
    Custom options for CSS minifier **UglifyJS2**, [see OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md).  
    *__Default__: ''*

- #### Notifications
    This options allows you to decide which feedback you want to see when SASS files are compiled: notification and/or panel.  
    **Panel**: The panel is shown at the bottom of the editor. When starting the compilation it's only a small header with a throbber. After compiliation a success or error message is shown with reference to the CSS file, or on error the SCSS file. By clicking on the message you can access the CSS or error file.  
    **Notification**: The default atom notifications are used for output.  
    *__Default__: Panel*

- #### Automatically hide panel on ...
    Select on which event the panel should automatically disappear. If you want to hide the panel via shortcut, you can use `ctrl-alt-shift-h` / `ctrl-cmd-shift-h`.  
    *__Default__: Success*

- #### Panel-auto-hide delay
    Delay after which panel is automatically hidden.  
    *__Default__: 3000*

- #### Automatically hide notifications on ...
    Decide when you want the notifications to automatically hide. Else you have to close every notification manually.  
    *__Default__: Info, Success*

- #### Show 'Start Minification' Notification
    If enabled and you added the notification option in `Notifications`, you will see an info-message when minification process starts.  
    *__Default__: false*

- #### Advanced → Java path
    If you have more than one Java installation or you have a special constellation, you can use this option to define a path to a Java executable. This executable is used for YUI and GCC minifiers.  
    *__Default__: ''*


## Inline-parameters

Since version 0.3 you can define inline-parameters that overwrites the global options. These parameters applies only for current file. Here are the rules:

You can add them by writing a comment to the first line of your CSS or JS file. The parameters must be comma-separated. Values are optional If you need a comma as value, you have to put it into single or double quotation marks.

- Parameters must be placed as comment in the **first** line
- Comma-separated parameters
- Parameters are entered this way: `key:value` ‒ you can have spaces before and after key and value, e.g. ` key : value `
- Values are optional; if no value is given, parameter has value `true`
- If value contains a comma, value must be surrounded by single/double quotation marks


Examples for CSS files:
```css
/* minifyOnSave, filenamePattern: test/$1.compressed.$2 */
OR
/* filenamePattern: "/this is just a test/project/css/$1.compressed.$2" */
body {
}
h1 {
}
```
```css
/* minifierOptions: "line-break = 100" */
body {
}
h1 {
}
```

Example for JS files:
```js
// minifier: yui-js, buffer: 8388608, minifierOptions: "charset = utf-8 nomunge"
function(document, window, undefined) {
    alert('Hello World!')
}(document, window);
```

### Available parameters

- #### minifyOnSave | minifyOnSave [ : true | false ]
    With this option you can control minify on save functionality by first line parameter. If you define this option, global option is overwritten. Examples:

    ```
    Enable minify on save
    // minifyOnSave
    // minOnSave: true
    // minOnSave
    // minOnSave: true

    Disable minify on save
    // !minifyOnSave
    // minifyOnSave: false
    // !minOnSave
    // minOnSave: false
    ```

- #### compress: false | uncompressed
    With these parameter you can disable minification, so output is not minified. Can be useful for development process.

- #### filenamePattern
    Defines the replacement pattern for minified CSS or JS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Foo.CSS` the minified filename `Foo.min.CSS`.

    You can add relative or absolute path too, e.g. `filenamePattern: "/path/to/your/project/css/$1.min.$2"`.

- #### ~~outputPath~~
    ~~Defines a relative or absolute path where minified file is placed. Can be combined with `filenamePattern`.~~

    *Removed since version 0.7.0. Please use filename patterns for defining relative or absolute output paths with filename.*

- #### minifier
  Selects the minifier to compile with.

  *CSS:*
    - `clean-css`
    - `csso`
    - `sqwish`
    - `yui-css`

  *JavaScript:*
    - `gcc`
    - `uglify-js`
    - `yui-js`

   Example: `minifier: clean-css`


- #### minifierOptions
    See [OPTIONS.md](https://github.com/armin-pfaeffle/atom-minify/blob/master/OPTIONS.md) for more information about custom minifier options.

- #### buffer
    This value sets the buffer size in Bytes. It must be a value Integer and **greater than 1024 * 1024 = 1MB**.



## Predefined shortcuts

- #### `ctrl-shift-m`
    Minify content of **opened file to a new file**. The filename of the new file is specified by **Filename pattern for minified CSS/JS file** options. In general, minification only works on files that ends with `.css` or `.js` (comparison is case **insensitive**), else atom-minify asks you of which file type it is.

- #### `alt-shift-m` / `cmd-shift-m`
    Minify content of opened file. This command does not create a new file, nor saves the minified content. If file extension is `.css` or `.js` the minifier is automatically detected, else you are asked which minifier to use. This option is especially useful when you want to quickly minify CSS or JavaScript without creating a file.

- #### `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`
    En- or disables option [Minify on save](#minify-on-save).

- #### `Escape` / `ctrl-alt-shift-h` / `ctrl-cmd-shift-h`
    Closes notification panel if visible.

- #### `ctrl-alt-shift-c ctrl-1` / `ctrl-cmd-shift-c ctrl-1`
    Select the CSS minifier **YUI Compressor**.

- #### `ctrl-alt-shift-c ctrl-2` / `ctrl-cmd-shift-c ctrl-2`
    Select the CSS minifier **clean-css**.

- #### `ctrl-alt-shift-c ctrl-3` / `ctrl-cmd-shift-c ctrl-3`
    Select the CSS minifier **CSSO**.

- #### `ctrl-alt-shift-c ctrl-4` / `ctrl-cmd-shift-c ctrl-4`
    Select the CSS minifier **Sqwish**.

- #### `ctrl-alt-shift-j ctrl-1` / `ctrl-cmd-shift-j ctrl-1`
    Select the CSS minifier **YUI Compressor**.

- #### `ctrl-alt-shift-j ctrl-2` / `ctrl-cmd-shift-j ctrl-2`
    Select the CSS minifier **Google Closure Compiler**.

- #### `ctrl-alt-shift-j ctrl-3` / `ctrl-cmd-shift-j ctrl-3`
    Select the CSS minifier **UglifyJS2**.


## Issues, questions & feedback

[Please post issues on GitHub](https://github.com/armin-pfaeffle/atom-minify/issues).

For other concerns like questions or feeback [have a look at the discussion thread on atom.io](https://discuss.atom.io/t/feedback-questions-about-atom-minify/).


## Roadmap

- Minify content to a new, unsaved file, so user can decide where to save the new file
- Minify HTML/JSON/XML/etc.?
- Compress more than one file to a minified file


## Changelog

See [CHANGELOG.md](CHANGELOG.md).
