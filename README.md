# atom-minify

Minifies JS and CSS files, optionally on save; now supporting inline-parameters.

---

Because [minifier](https://atom.io/packages/minifier) is no longer maintained, I created [atom-minify](https://atom.io/packages/atom-minify) which includes **four CSS and three JS minifiers**. Another feature is the flexible configuration which should give you full control over minification and created files. Inline-parameters complete the way of defining the output.

*In current version minifier options are ignored at the moment. This feature will be included in next version.*

Have a look at the [roadmap](#roadmap) for upcoming features.


## Requirements

When you want to use **YUI Compressor** or **Google Closure Compiler**, you must install [Java](https://www.java.com/de/download/). If Java is not present, you will see an error message.



## Usage

#### Basic usage
After installing [atom-minify](https://atom.io/packages/atom-minify) you can use two shortcuts to access the **two different minification functionalites**:

1. `ctrl-shift-m`: Minify content of opened file to a new file (see [minified filename pattern](#filename-pattern-for-minified-css-file)). If file already exists, content is overwritten.
2. `alt-shift-m` / `cmd-shift-m`: Direct minification of content. Does not create a new file, nor save the modification. If you have an unsaved file, you also can minify content, but you are asked which content type (CSS or JS) it is.

Beside the shortcuts you also have the possibility to access these actions by menu:
- `Package` → `Minify` → `Minify to minified file`
- `Package` → `Minify` → `Direct Minification`.

#### Minify on save

Beside the shortcuts and menu items, you can enable option [Minify on save](#minify-on-save) (shortcut: `ctrl-alt-shift-m`/ `ctrl-cmd-shift-m`), so everytime you save a CSS or JavaScript file, it is directly minified to a new minified file.

#### 4+3 minifiers
Because `node-minify` supports **four CSS and three JS minifiers** you can select which one to use. Especially when you don't want to install Java on your system, these feature is great for you. There even exists [predefined shortcuts](#predefined-shortcuts) for instant changing the minifier.

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

- #### General output path
Defines a general output path for minified files, e.g. `min/dev/` or `compressed`. You can use an absolute or relative path. Have a look at the inline parameter `outputPath` which should be more suitable in most cases.  
*__Default__: ''*

- #### Buffer
Only modify the buffer size when you have to compile large files, [see node-minify documentation](https://www.npmjs.com/package/node-minify#max-buffer-size).  
*__Default__: 1000 * 1024*

- #### CSS → Minifier
Defines which CSS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [clean-css](https://github.com/GoalSmashers/clean-css), [CSSO](https://github.com/css/csso), [Sqwish](https://github.com/ded/sqwish).  
**See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
*__Default__: YUI Compressor*

- #### CSS → Filename pattern for minified file
Defines the replacement pattern for minified CSS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Foo.CSS` the minified filename `Foo.min.CSS`.  
*__Default__: $1.min.$2*

- #### CSS → Parameters for YUI Compressor
Additional parameters for CSS minifier **YUI Compressor**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [YUI Compressor documentation](http://developer.yahoo.com/yui/compressor/).  
*__Default__: ''*

- #### CSS → Parameters for clean-css
Additional parameters for CSS minifier **clean-css**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [clean-css documentation](https://github.com/GoalSmashers/clean-css).  

- #### CSS → Parameters for CSSO
Additional parameters for CSS minifier **CSSO**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [CSSO documentation](https://github.com/css/csso).  
*__Default__: ''*

- #### CSS → Parameters for Sqwish
Additional parameters for CSS minifier **Sqwish**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [Sqwish documentation](https://github.com/ded/sqwish).  
*__Default__: ''*

- #### JS → Minifier
Defines which JS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [Google Closure Compiler](https://developers.google.com/closure/compiler/), [UglifyJS2](https://github.com/mishoo/UglifyJS2).  
**See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
*__Default__: YUI Compressor*

- #### JS → Filename pattern for minified file
Defines the replacement pattern for minified JS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Bar.JS` the minified filename `Bar.min.JS`.  
*__Default__: $1.min.$2*

- #### JS → Parameters for YUI Compressor
Additional parameters for CSS minifier **YUI Compressor**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [YUI Compressor documentation](http://developer.yahoo.com/yui/compressor/).  
*__Default__: ''*

- #### JS → Parameters for Google Closure Compiler
Additional parameters for CSS minifier **Google Closure Compiler**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [Google Closure Compiler documentation](https://developers.google.com/closure/compiler/).  
*__Default__: ''*

- #### JS → Parameters for UglifyJS2
Additional parameters for CSS minifier **UglifyJS2**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [UglifyJS2 documentation](https://github.com/mishoo/UglifyJS2).  
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
/* filenamePattern: test/$1.compressed.$2, outputPath: "compressed/dev, tested/" */
/* This definition redefines the filename pattern and additionally adds the
   subdirectory 'test'. Furthermore an output path is defined, so the resultant
   path is 'compressed/dev/test/<filename>'. Have a look at the usage of the comma! */
body {
}
h1 {
}
```
```css
/* outputPath: dev, uncompressed */
/* This definition put the outputs file to 'dev' subdirectory. Beside that
   the content is not minified, which can be useful for development */
body {
}
h1 {
}
```

Example for JS files:
```js
// minifier: uglify-js, buffer: 8388608, minifierOptions:TODO
/* This parameters ensures, that YUI compressor is used for this file.
   Furhtermore it tells the minifier to use up to 8MB buffer, which can be
   useful for large files.
   As you can see, the minifierOptions parameter is still under
   construction ;) */
function(document, window, undefined) {
    alert('Hello World!')
}(document, window);
```

### Available parameters

- #### compress: false / uncompressed
With these parameter you can disable minification, so output is not minified. Can be useful for development process.

- #### filenamePattern
Defines the replacement pattern for minified CSS or JS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Foo.CSS` the minified filename `Foo.min.CSS`.

- #### outputPath
Defines a relative or absolute path where minified file is placed. Can be combined with `filenamePattern`.

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


- #### minifierOptions
*Not supported yet. Coming soon...*

- #### buffer
This value sets the buffer size in Bytes. It must be a value Integer and **greater than 1024 * 1024 = 1MB**.



## Predefined shortcuts

- #### `ctrl-shift-m`
Minify content of opened file to **a new file**. The filename of the new file is specified by **Filename pattern for minified CSS/JS file** options. Minification only works on files that ends with `.css` or `.js` (comparison is case **in**sensitive).

- #### `alt-shift-m` / `cmd-shift-m`
Minify content of opened file. This command does not create a new file, nor saves the minified content. If file extension is `.css` or `.js` the minifier is automatically detected, else you are asked which minifier to use. This option is especially useful when you want to quickly minify CSS or JavaScript without creating a file.

- #### `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`
En- or disables option [Minify on save](#minify-on-save).

- #### `ctrl-alt-shift-h` / `ctrl-cmd-shift-h`
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
- New option: Overwrite existent file


## Changelog

**0.4.1 - 01.09.2015**
- Fixed documentation

**0.4.0 - 01.09.2015**
- New option: Advanced → Java path for defining an absolute path to a special Java installation
- Minor improvements

**0.3.1 - 25.08.2015**
- Bugfix: Recursive creation of non-existent output directory failed on Darwin and Linux, see [issue #11](https://github.com/armin-pfaeffle/atom-minify/issues/11)

**0.3.0 - 22.08.2015**
- General: Output path is automatically created when not existent
- General: Reordering options in settings view
- General: Minifiyng a unsaved file leads to a save dialog
- New feature: Added inline parameters in a first-line-comment to override global settings
- New feature: Detection of already minified file
- New feature: 'Minify' item in Tree View context menu
- New Option: Ask for overwriting already existent minified files
- New Option: Ask for minification of already minified files
- New Option: Show Minify-item in Tree View context menu
- New Option: General output path
- Improved panel: Better clickable lines for opening files
- Improved panel: When trying opening file by clicking on filename and it does not exist, panel shows an corresponding information and does not open an empty file
- Improved menu: Better menu usability and fixed visual binding problem
- Bugfix: Added try-catch-block when deleting temporary files, so no `Uncaught Error` message occurs, see [issue #10](https://github.com/armin-pfaeffle/atom-minify/issues/10)
- Bugfix: panel was still visible although nothing was minified

**0.2.2 - 27.07.2015**
- Fixed link in documentation

**0.2.1 - 24.07.2015**
- Improved and fixed panel notification

**0.2.0 - 12.07.2015**
- Complete rewrite of package, not depending on node-minify any more
- Improved output filename generation
- Minor improvements

**0.1.7 - 01.07.2015**
- Bugfix: CSS parameters ignored ([pull request](https://github.com/armin-pfaeffle/atom-minify/pull/3) by [William Wells](https://github.com/whanwells))
- Removed unused code

**0.1.5 / 0.1.6 - 27.05.2015**
- Updated CHANGELOG and README

**0.1.4 - 27.05.2015**
- Updated required engine version to <=0.185.0, <2.0.0

**0.1.3 - 27.05.2015**
- Bugfix: Using deprecrated API, so package does not work with API 1.0 (issue [atom/atom#6867](https://github.com/atom/atom/issues/6867))

**0.1.2 - 18.05.2015**
- Bugfix: Missing require() leads to a call of an undefined variable

**0.1.1 - 08.05.2015**
- Removed console outputs

**0.1.0 - 08.05.2015**
- Initial version
