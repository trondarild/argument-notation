" ArgMap syntax highlighting
if exists("b:current_syntax")
  finish
endif

" === SECTION TITLE ===
syn match argmapSectionHeader /===.*===/

" entry: / exit: / zoom ↓
syn match argmapMeta /^\s*\(entry\|exit\|zoom\)\s*[↓:].*/

" CITATIONS block header
syn match argmapCitHeader /^CITATIONS\s*$/

" [State] — reader knowledge state (including ⊗ compounds)
syn match argmapState /\[[^\]]\+\]/

" ↓ arrow with optional status and claim name
syn match argmapArrow /↓/
syn match argmapClaimLine /^\s*↓.*$/ contains=argmapArrow,argmapStatus,argmapLitType,argmapNaked,argmapNote

" Status markers
syn match argmapStatus /[?~*✓]/ contained

" Literature type tags
syn match argmapLitType /(E)\|(T)\|(R)/ contained

" Naked assertion
syn match argmapNaked /(!)/ contained

" ⊗ tensor product
syn match argmapTensor /⊗/

" Quoted notes
syn match argmapNote /"[^"]*"/ contained

" Citation line: claim_name (type): keys
syn match argmapCitLine /^\s*\w\+\s*(.*):.*$/

hi def link argmapSectionHeader Title
hi def link argmapMeta          PreProc
hi def link argmapCitHeader     Title
hi def link argmapState         Type
hi def link argmapArrow         Operator
hi def link argmapStatus        Todo
hi def link argmapLitType       Constant
hi def link argmapNaked         WarningMsg
hi def link argmapTensor        Operator
hi def link argmapNote          Comment
hi def link argmapCitLine       Identifier

let b:current_syntax = "argmap"
