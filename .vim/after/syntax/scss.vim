runtime! syntax/css/html5-elements.vim
runtime! syntax/css/css3-animations.vim
runtime! syntax/css/css3-background.vim
runtime! syntax/css/css3-box.vim
runtime! syntax/css/css3-break.vim
runtime! syntax/css/css3-colors.vim
runtime! syntax/css/css3-content.vim
runtime! syntax/css/css3-exclusions.vim
runtime! syntax/css/css3-flexbox.vim
runtime! syntax/css/css3-gcpm.vim
runtime! syntax/css/css3-grid-layout.vim
runtime! syntax/css/css3-hyperlinks.vim
runtime! syntax/css/css3-images.vim
runtime! syntax/css/css3-layout.vim
runtime! syntax/css/css3-linebox.vim
runtime! syntax/css/css3-lists.vim
runtime! syntax/css/css3-marquee.vim
"runtime! syntax/css/css3-mediaqueries.vim
runtime! syntax/css/css3-multicol.vim
runtime! syntax/css/css3-preslev.vim
runtime! syntax/css/css3-regions.vim
runtime! syntax/css/css3-ruby.vim
runtime! syntax/css/css3-selectors.vim
runtime! syntax/css/css3-text.vim
runtime! syntax/css/css3-transforms.vim
runtime! syntax/css/css3-transitions.vim
runtime! syntax/css/css3-ui.vim
runtime! syntax/css/css3-values.vim
runtime! syntax/css/css3-writing-modes.vim


syn region cssMediaType start='(' end=')' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape nextgroup=cssMediaComma,cssMediaAnd,cssMediaBlock skipwhite skipnl
syn match cssMediaAnd "and" nextgroup=cssMediaType skipwhite skipnl
syn clear cssMediaBlock
syn region cssMediaBlock contained transparent matchgroup=cssBraces start='{' end='}' contains=cssTagName,cssSelectorOp,cssAttributeSelector,cssIdentifier,cssError,cssDefinition,cssPseudoClass,cssComment,cssUnicodeEscape,cssClassName,cssURL,scssNestedSelector,scssDefinition,scssId
