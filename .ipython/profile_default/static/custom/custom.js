// leave at least 2 line with only a star on it below, or doc generation fails
/**
 *
 *
 * Placeholder for custom user javascript
 * mainly to be overridden in profile/static/custom/custom.js
 * This will always be an empty file in IPython
 *
 * User could add any javascript in the `profile/static/custom/custom.js` file
 * (and should create it if it does not exist).
 * It will be executed by the ipython notebook at load time.
 *
 * Same thing with `profile/static/custom/custom.css` to inject custom css into the notebook.
 *
 * Example :
 *
 * Create a custom button in toolbar that execute `%qtconsole` in kernel
 * and hence open a qtconsole attached to the same kernel as the current notebook
 *
 *    $([IPython.events]).on('app_initialized.NotebookApp', function(){
 *        IPython.toolbar.add_buttons_group([
 *            {
 *                 'label'   : 'run qtconsole',
 *                 'icon'    : 'icon-terminal', // select your icon from http://fortawesome.github.io/Font-Awesome/icons
 *                 'callback': function () {
 *                     IPython.notebook.kernel.execute('%qtconsole')
 *                 }
 *            }
 *            // add more button here if needed.
 *            ]);
 *    });
 *
 * Example :
 *
 *  Use `jQuery.getScript(url [, success(script, textStatus, jqXHR)] );`
 *  to load custom script into the notebook.
 *
 *    // to load the metadata ui extension example.
 *    $.getScript('/static/notebook/js/celltoolbarpresets/example.js');
 *    // or
 *    // to load the metadata ui extension to control slideshow mode / reveal js for nbconvert
 *    $.getScript('/static/notebook/js/celltoolbarpresets/slideshow.js');
 *
 *
 * @module IPython
 * @namespace IPython
 * @class customjs
 * @static
 */

require(['/static/custom/jquery.handsontable.full.js']);

CodeMirror.keyMap.default['Ctrl-W'] = 'delWordBefore';
CodeMirror.keyMap.default['Ctrl-U'] = "delLineLeft";

$([IPython.events]).on("app_initialized.NotebookApp", function () {
    $('div#header').hide();
    $('div#maintoolbar').hide();
});

$([IPython.events]).on("selected_cell_type_changed.Notebook", function () {
    var cells = IPython.notebook.get_cells();
    cells.forEach(function(cell) {
      if (cell.code_mirror && cell.code_mirror.options.mode === 'magic_javascript') {
        cell.code_mirror.setOption('theme', 'monokai');
      } else {
        // reset
        cell.code_mirror.setOption('theme', 'ipython')
      }
    });
});

