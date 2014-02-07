
syn match   rstRoleTodo         '\v:(TODO|FIXME|NOTE):'
syn match   rstRoleDone         '\v:(DONE):'
hi def link rstRoleTodo Function 
hi def link rstRoleDone Comment
