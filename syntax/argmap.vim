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

" ↓ arrow line — contains sub-elements
syn match argmapArrow /↓/
syn match argmapClaimLine /^\s*↓.*$/ contains=argmapArrow,argmapStatus,argmapLitE,argmapLitT,argmapLitR,argmapNaked,argmapNote

" Status markers
syn match argmapStatus /[?~*✓]/ contained

" Literature type tags — top-level so they highlight in citation blocks too
syn match argmapLitE /(E)/
syn match argmapLitT /(T)/
syn match argmapLitR /(R)/

" Naked assertion — top-level so it highlights everywhere
syn match argmapNaked /(!)/

" ⊗ tensor product
syn match argmapTensor /⊗/

" Quoted notes
syn match argmapNote /"[^"]*"/ contained

" Citation line: claim_name (type): keys
syn match argmapCitLine /^\s*\w\+\s*(.*):.*$/ contains=argmapLitE,argmapLitT,argmapLitR,argmapNaked

hi def link argmapSectionHeader Title
hi def link argmapMeta          PreProc
hi def link argmapCitHeader     Title
hi def link argmapState         Type
hi def link argmapArrow         Operator
hi def link argmapStatus        Todo
hi def link argmapTensor        Operator
hi def link argmapNote          Comment
hi def link argmapCitLine       Identifier

" Distinct colors for each wire type — palette matches ArgMap Dark (bat theme)
hi argmapLitE guifg=#98C379 ctermfg=114 gui=NONE cterm=NONE
hi argmapLitT guifg=#56B6C2 ctermfg=73  gui=NONE cterm=NONE
hi argmapLitR guifg=#D19A66 ctermfg=173 gui=NONE cterm=NONE
hi argmapNaked guifg=#E06C75 ctermfg=168 gui=bold cterm=bold

let b:current_syntax = "argmap"
