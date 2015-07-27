# atom-minify

Minifies JS and CSS files, optionally on save.

---

Because [minifier](https://atom.io/packages/minifier) is no longer maintained, I created [atom-minify](https://atom.io/packages/atom-minify) which is includes **four CSS and three JS compressors**. Another feature is the extensive configuration which should give you full control over minification and created files.

*Current version does not depend on node-minify any more and can contain errors because the package is completely rewritten. Please let me know if there is any behaviour that does not come up to one's expectations. Further, minifier parameters are ignored at the moment. This feature will be included in next version.*

Have a look at the [roadmap](#roadmap) for upcoming features.


## Requirements

When you want to use **YUI Compressor** or **Google Closure Compiler**, you must install [Java](https://www.java.com/de/download/). If Java is not present, you will see an error message.


## Usage

After installing [atom-minify](https://atom.io/packages/atom-minify) you can use two shortcuts to access the **two different minification functionalites**:

1. `ctrl-shift-m`: Minify content of opened file to a new file (see [minified filename pattern](#filename-pattern-for-minified-css-file)). If file already exists, content is overwritten.
2. `alt-shift-m` / `cmd-shift-m`: Direct minification of content. Does not create a new file, nor save the modification. If you have an unsaved file, you also can minify content, but you are asked which content type (CSS or JS) it is.

Beside the shortcuts you also have the possibility to access these actions by menu:
- `Package` → `Minify` → `Minify to minified file`
- `Package` → `Minify` → `Direct Minification`.

Furthermore you can enable option [Minify on save](#minify-on-save) (shortcut: `ctrl-alt-shift-m`/ `ctrl-cmd-shift-m`), so everytime you save a CSS or JavaScript file, it is directly minified to a new minified file.

Because `node-minify` supports **four CSS and three JS compressors** you can select which one to use. There even exists [predefined shortcuts](#predefined-shortcuts) for instant changing the compressor.

Beside the basic functionality, have a look at the [options](#options). You can configure a lot of things ;)


## Options

#### **Minify on save**
This option en-/disables minification on save. This is especially useful when you want to create minified files everytime you save a CSS or JavaScript file.  
**Shortcut for en-/disable this option**: `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`  
*__Default__: false*

#### **Show saving info**
If enabled some information about saving are shown in notification or panel.  
*__Default__: true*

#### **CSS minifier**
Defines which CSS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [clean-css](https://github.com/GoalSmashers/clean-css), [CSSO](https://github.com/css/csso), [Sqwish](https://github.com/ded/sqwish).  
**See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
*__Default__: YUI Compressor*

#### **JS minifier**
Defines which JS minifier you want to use. Current options: [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [Google Closure Compiler](https://developers.google.com/closure/compiler/), [UglifyJS2](https://github.com/mishoo/UglifyJS2).  
**See [Predefined shortcuts](#predefined-shortcuts) for changing minifier via shortcut**  
*__Default__: YUI Compressor*

#### **Filename pattern for minified CSS file**
Defines the replacement pattern for minified CSS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Foo.CSS` the minified filename `Foo.min.CSS`.  
*__Default__: $1.min.$2*

#### **Filename pattern for minified JS file**
Defines the replacement pattern for minified JS filename. You can use two placeholders: `$1` for filename without extenion, `$2` for file extension. Example: the default value `$1.min.$2` generates from filename `Bar.JS` the minified filename `Bar.min.JS`.  
*__Default__: $1.min.$2*

#### **Notifications**
This options allows you to decide which feedback you want to see when SASS files are compiled: notification and/or panel.  
**Panel**: The panel is shown at the bottom of the editor. When starting the compilation it's only a small header with a throbber. After compiliation a success or error message is shown with reference to the CSS file, or on error the SCSS file. By clicking on the message you can access the CSS or error file.  
**Notification**: The default atom notifications are used for output.  
*__Default__: Panel*

#### **Automatically hide panel on ...**
Select on which event the panel should automatically disappear. If you want to hide the panel via shortcut, you can use `ctrl-alt-shift-h` / `ctrl-cmd-shift-h`.  
*__Default__: Success*

#### **Panel-auto-hide delay**
Delay after which panel is automatically hidden.
*__Default__: 3000*

#### **Automatically hide notifications on ...**
Decide when you want the notifications to automatically hide. Else you have to close every notification manually.  
*__Default__: Info, Success*

#### **Show 'Start Minification' Notification**
If enabled and you added the notification option in `Notifications`, you will see an info-message when minification process starts.  
*__Default__: false*

#### **Buffer**
Only modify the buffer size when you have to compile large files, [see node-minify documentation](https://www.npmjs.com/package/node-minify#max-buffer-size).  
*__Default__: 1000 * 1024*

#### **CSS → parameters for YUI Compressor**
Additional parameters for CSS minifier **YUI Compressor**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [YUI Compressor documentation](http://developer.yahoo.com/yui/compressor/).  
*__Default__: ''*

#### **CSS → parameters for clean-css**
Additional parameters for CSS minifier **clean-css**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [clean-css documentation](https://github.com/GoalSmashers/clean-css).  

#### **CSS → parameters for CSSO**
Additional parameters for CSS minifier **CSSO**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [CSSO documentation](https://github.com/css/csso).  
*__Default__: ''*

#### **CSS → parameters for Sqwish**
Additional parameters for CSS minifier **Sqwish**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [Sqwish documentation](https://github.com/ded/sqwish).  
*__Default__: ''*

#### **JS → parameters for YUI Compressor**
Additional parameters for CSS minifier **YUI Compressor**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [YUI Compressor documentation](http://developer.yahoo.com/yui/compressor/).  
*__Default__: ''*

#### **JS → parameters for Google Closure Compiler**
Additional parameters for CSS minifier **Google Closure Compiler**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [Google Closure Compiler documentation](https://developers.google.com/closure/compiler/).  
*__Default__: ''*

#### **JS → parameters for UglifyJS2**
Additional parameters for CSS minifier **UglifyJS2**, [see node-minify documentation](https://www.npmjs.com/package/node-minify#passing-options) and [UglifyJS2 documentation](https://github.com/mishoo/UglifyJS2).  
*__Default__: ''*



## Predefined shortcuts

#### `ctrl-shift-m`
Minify content of opened file to **a new file**. The filename of the new file is specified by **Filename pattern for minified CSS/JS file** options. Minification only works on files that ends with `.css` or `.js` (comparison is case **in**sensitive).

#### `alt-shift-m` / `cmd-shift-m`
Minify content of opened file. This command does not create a new file, nor saves the minified content. If file extension is `.css` or `.js` the minifier is automatically detected, else you are asked which minifier to use. This option is especially useful when you want to quickly minify CSS or JavaScript without creating a file.

#### `ctrl-alt-shift-m` / `ctrl-cmd-shift-m`
En- or disables option [Minify on save](#minify-on-save).

#### `ctrl-alt-shift-h` / `ctrl-cmd-shift-h`
Closes notification panel if visible.

#### `ctrl-alt-shift-c ctrl-1` / `ctrl-cmd-shift-c ctrl-1`
Select the CSS minifier **YUI Compressor**.

#### `ctrl-alt-shift-c ctrl-2` / `ctrl-cmd-shift-c ctrl-2`
Select the CSS minifier **clean-css**.

#### `ctrl-alt-shift-c ctrl-3` / `ctrl-cmd-shift-c ctrl-3`
Select the CSS minifier **CSSO**.

#### `ctrl-alt-shift-c ctrl-4` / `ctrl-cmd-shift-c ctrl-4`
Select the CSS minifier **Sqwish**.

#### `ctrl-alt-shift-j ctrl-1` / `ctrl-cmd-shift-j ctrl-1`
Select the CSS minifier **YUI Compressor**.

#### `ctrl-alt-shift-j ctrl-2` / `ctrl-cmd-shift-j ctrl-2`
Select the CSS minifier **Google Closure Compiler**.

#### `ctrl-alt-shift-j ctrl-3` / `ctrl-cmd-shift-j ctrl-3`
Select the CSS minifier **UglifyJS2**.


## Issues, questions & feedback

[Please post issues on GitHub](https://github.com/armin-pfaeffle/atom-minify/issues).

For other concerns like questions or feeback [have a look at the discussion thread on atom.io](https://discuss.atom.io/t/feedback-questions-about-atom-minify/).


## Roadmap

- Save minified files to subdirectories
- Minify content to a new, unsaved file, so user can decide where to save the new file
- Introduce parameters as comments in CSS and JS files that overrides general package options (like in sass-autocompile)
- Minify HTML/JSON/XML/etc. ?
- Compress more than one file to a minified file
- Auto-hide checkbox on panel, beside close button
- Include minify entry in tree view popup
- New option: Overwrite existant file
- New ption: disallow minification of file with .min. substring


## Changelog

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
