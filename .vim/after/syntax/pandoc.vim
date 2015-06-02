
syntax case match
syntax keyword todoStates TODO APPT PAY BUY containedin=pandocAtxHeader
syntax keyword logStates LOG containedin=pandocAtxHeader
syntax keyword holdStates HOLD WAITING CLIENT containedin=pandocAtxHeader
syntax keyword doneStates DONE containedin=pandocAtxHeader
syntax keyword canceledStates CANCELED DEFERRED containedin=pandocAtxHeader

syntax match todoTag "\(^\|\s\)\@<=+\w\{-\}\>" containedin=pandocUListItem,pandocAtxHeader
syntax match todoNextTag "\(^\|\s\)\@<=+next\>" containedin=pandocUListItem,pandocAtxHeader

hi link todoTag Comment
hi link todoNextTag Function

setlocal iskeyword=48-57,a-z,A-Z,192-255,$,.,+
