" vim: fdm=marker
"
" Name:         Vim Hardaway
" Author:       Evan Turner <ev@evturn.com>
" Maintainer:   Evan Turner <ev@evturn.com>
" Repository:   https://github.com/evturn/vim-hardaway
" License:      MIT
" Last Updated: Nov 2018
" Note:         Zip it up and zip it out.

let g:colors_name   = 'vim-hardaway'
let g:airline_theme = 'vim_hardaway'

set background=dark
highlight clear
if has("syntax_on")
  syntax reset
endif

" Color palette {{{

" Color: Black             #000000      0
" Color: Navy              #000080      4
" Color: Grey              #808080      8
" Color: Yellow            #ffff00      11
" Color: Aqua              #00ffff      14
" Color: White             #ffffff      15
" Color: DodgerBlue1       #0087ff      33
" Color: SpringGreen2      #00d787      42
" Color: Turquoise2        #00d7ff      45
" Color: SpringGreen1      #00ff87      48
" Color: MediumSpringGreen #00ffaf      49
" Color: RoyalBlue1        #5f5fff      63
" Color: SteelBlue1        #5fd7ff      81
" Color: MediumPurple1     #af87ff      141
" Color: DarkSeaGreen2     #afffaf      157
" Color: Yellow2           #d7ff00      190
" Color: Red1              #ff0000      196
" Color: DeepPink1         #ff0087      198
" Color: OrangeRed1        #ff5f00      202
" Color: Grey3             #080808      232
" Color: Grey7             #121212      233
" Color: Grey11            #1c1c1c      234
" Color: Grey15            #262626      235
" Color: Grey19            #303030      236
" Color: Grey23            #3a3a3a      237
" Color: Grey27            #444444      238
" Color: Grey35            #585858      240
" Color: Grey50            #808080      244

" }}}

" Base {{{

highlight Boolean        ctermfg=33              guifg=#0087ff
highlight Character      ctermfg=15              guifg=#ffffff
highlight ColorColumn    ctermfg=240 ctermbg=232 guifg=#585858 guibg=#808080
highlight Comment        ctermfg=240             guifg=#585858
highlight Conceal        ctermfg=14  ctermbg=233 guifg=#00ffff guibg=#121212
highlight Conditional    ctermfg=198             guifg=#ff0087
highlight Constant       ctermfg=14              guifg=#00ffff
highlight Cursor         ctermfg=0   ctermbg=81  guifg=#000000 guibg=#5fd7ff
highlight CursorIM       ctermfg=0   ctermbg=81  guifg=#000000 guibg=#5fd7ff
highlight CursorColumn               ctermbg=233               guibg=#121212 cterm=none      gui=none 
highlight CursorLine                 ctermbg=233               guibg=#121212 cterm=none      gui=none
highlight Debug          ctermfg=4               guifg=#000080
highlight Define         ctermfg=198             guifg=#ff0087
highlight Delimiter      ctermfg=14              guifg=#00ffff
highlight DiffAdd        ctermfg=49  ctermbg=235 guifg=#00ffaf guibg=#262626
highlight DiffChange     ctermfg=49  ctermbg=235 guifg=#00ffaf guibg=#262626
highlight DiffDelete     ctermfg=198 ctermbg=235 guifg=#ff0087 guibg=#262626 cterm=italic    gui=italic
highlight DiffText       ctermfg=49  ctermbg=235 guifg=#00ffaf guibg=#262626
highlight Directory      ctermfg=81              guifg=#5fd7ff
highlight Error          ctermfg=202 ctermbg=233 guifg=#ff5f00 guibg=#121212
highlight ErrorMsg       ctermfg=49  ctermbg=233 guifg=#00ffaf guibg=#121212
highlight Exception      ctermfg=196             guifg=#ff0087
highlight Float          ctermfg=141             guifg=#af87ff
highlight FoldColumn     ctermfg=240 ctermbg=233 guifg=#585858 guibg=#121212
highlight Folded         ctermfg=240 ctermbg=235 guifg=#585858 guibg=#262626
highlight Function       ctermfg=190             guifg=#d7ff00
highlight Identifier     ctermfg=45              guifg=#00d7ff
highlight Ignore         ctermfg=244 ctermbg=233 guifg=#808080 guibg=#121212
highlight IncSearch      ctermfg=0   ctermbg=190 guifg=#000000 guibg=#d7ff00 cterm=italic    gui=italic
highlight Include        ctermfg=198             guifg=#ff0087
highlight Label          ctermfg=198             guifg=#ff0087
highlight LineNr         ctermfg=236             guifg=#303030
highlight Macro          ctermfg=48              guifg=#00ffaf
highlight MatchParen                 ctermbg=237               guibg=#3a3a3a
highlight ModeMsg        ctermfg=49  ctermbg=233 guifg=#00ffaf guibg=#121212
highlight MoreMsg        ctermfg=49  ctermbg=233 guifg=#00ffaf guibg=#121212
highlight NonText        ctermfg=236             guifg=#303030
" highlight Normal
highlight Number         ctermfg=141             guifg=#af87ff
highlight Operator       ctermfg=198             guifg=#ff0087
" highlight PMenu
" highlight PMenuSel
" highlight PMenuSbar
" highlight PMenuThumb
highlight PreCondit      ctermfg=33              guifg=#0087ff
highlight PreProc        ctermfg=49              guifg=#00ffaf 
highlight Question       ctermfg=49  ctermbg=233 guifg=#00ffaf guibg=#121212
highlight Repeat         ctermfg=198             guifg=#ff0087
highlight Search         ctermfg=0   ctermbg=190 guifg=#000000 guibg=#d7ff00
" highlight SignColumn
highlight Special        ctermfg=81              guifg=#5fd7ff
highlight SpecialChar    ctermfg=33              guifg=#0087ff
highlight SpecialComment ctermfg=238             guifg=#444444
highlight SpecialKey     ctermfg=235             guifg=#262626
highlight SpellBad                   ctermbg=235               guibg=#262626
" highlight SpellLocal
highlight SpellCap       ctermfg=190             guifg=#d7ff00
highlight SpellRare                  ctermbg=235               guibg=#262626
highlight StatusLine     ctermfg=235             guifg=#262626
highlight StatusLineNC   ctermfg=235             guifg=#262626
highlight Statement      ctermfg=198             guifg=#ff0087
highlight StorageClass   ctermfg=198             guifg=#ff0087
highlight String         ctermfg=49              guifg=#00ffaf 
highlight Structure      ctermfg=81              guifg=#5fd7ff                               gui=none
" highlight TabLine
" highlight TabLineFill
" highlight TabLineSel
highlight Tag            ctermfg=198             guifg=#ff0087
" highlight Title
highlight Todo           ctermfg=81  ctermbg=233 guifg=#5fd7ff guibg=#121212
highlight VertSplit      ctermfg=233 ctermbg=233 guifg=#121212 guibg=#121212 cterm=none
" highlight Visual
" highlight VisualNOS
highlight WarningMsg                 ctermbg=235               guibg=#262626
" highlight WildMenu
highlight keyword        ctermfg=81              guifg=#5fd7ff               cterm=bold      gui=bold 
highlight type           ctermfg=81              guifg=#5fd7ff
highlight Type           ctermfg=81              guifg=#5fd7ff
highlight Typedef        ctermfg=81              guifg=#5fd7ff
highlight typedef        ctermfg=81              guifg=#5fd7ff
" highlight Underlined

" }}}

" CSS / PostCSS {{{

highlight cssAttr                   ctermfg=14  guifg=#00ffff
highlight cssClassName              ctermfg=198 guifg=#ff0087
highlight cssClassNameDot           ctermfg=198 guifg=#ff0087
highlight cssColor                  ctermfg=14  guifg=#00ffff
highlight cssCommonAttr             ctermfg=81  guifg=#5fd7ff
highlight cssFlexibleBoxAttr        ctermfg=14  guifg=#00ffff
highlight cssFlexibleBoxProp        ctermfg=81  guifg=#5fd7ff
highlight cssFontDescriptor         ctermfg=198 guifg=#ff0087
highlight cssFontDescriptorFunction ctermfg=141 guifg=#af87ff
highlight cssFunction               ctermfg=198 guifg=#ff0087
highlight cssFunctionComma          ctermfg=14  guifg=#00ffff
highlight cssFunctionName           ctermfg=198 guifg=#ff0087
highlight cssIdentifier             ctermfg=49  guifg=#00ffaf
highlight cssIncludeKeyword         ctermfg=198 guifg=#ff0087
highlight cssKeyFrameSelector       ctermfg=141 guifg=#af87ff
highlight cssMediaProp              ctermfg=81  guifg=#5fd7ff
highlight cssNoise                  ctermfg=14  guifg=#00ffff
highlight cssPagePseudo             ctermfg=11  guifg=#ffff00
highlight cssProp                   ctermfg=81  guifg=#5fd7ff
highlight cssPseudoClass            ctermfg=11  guifg=#ffff00
highlight cssPseudoClassFn          ctermfg=11  guifg=#ffff00
highlight cssPseudoClassId          ctermfg=11  guifg=#ffff00
highlight cssPseudoClassLang        ctermfg=11  guifg=#ffff00
highlight cssSelectorOp             ctermfg=11  guifg=#ffff00
highlight cssSelectorOp2            ctermfg=11  guifg=#ffff00
highlight cssTagName                ctermfg=198 guifg=#ff0087
highlight cssUnitDecorators         ctermfg=14  guifg=#00ffff
highlight cssValueAngle             ctermfg=14  guifg=#00ffff
highlight cssValueFrequency         ctermfg=14  guifg=#00ffff
highlight cssValueInteger           ctermfg=141 guifg=#af87ff
highlight cssValueLength            ctermfg=141 guifg=#af87ff
highlight cssValueNumber            ctermfg=141 guifg=#af87ff
highlight cssValueTime              ctermfg=14  guifg=#00ffff
highlight cssVariable               ctermfg=11  guifg=#ffff00
highlight cssVariableValue          ctermfg=11  guifg=#ffff00
highlight cssVendor                 ctermfg=198 guifg=#ff0087

" }}}

" Haskell {{{

highlight ConId                     ctermfg=81  guifg=#5fd7ff
highlight haskellBlock              ctermfg=15  guifg=#ffffff
highlight haskellBottom             ctermfg=48  guifg=#00ff87 gui=underline cterm=underline
highlight haskellBrackets           ctermfg=15  guifg=#ffffff
highlight haskellDecl               ctermfg=198 guifg=#ff0087
highlight haskellDeclKeyword        ctermfg=198 guifg=#ff0087
highlight haskellDefault            ctermfg=15  guifg=#ffffff
highlight haskellIdentifier         ctermfg=11  guifg=#ffff00
highlight haskellImport             ctermfg=81  guifg=#5fd7ff
highlight haskellImportKeywords     ctermfg=198 guifg=#ff0087
highlight haskellKeyword            ctermfg=198 guifg=#ff0087
highlight haskellLet                ctermfg=198 guifg=#ff0087
highlight haskellParens             ctermfg=15  guifg=#ffffff
highlight haskellPatternKeyword     ctermfg=48  guifg=#00ff87
highlight haskellPragma             ctermfg=11  guifg=#ffff00 gui=italic    cterm=italic
highlight haskellPreProc            ctermfg=48  guifg=#00ff87 gui=undercurl
highlight haskellStatic             ctermfg=48  guifg=#00ff87 gui=undercurl
highlight haskellType               ctermfg=81  guifg=#5fd7ff
highlight haskellTypeRoles          ctermfg=48  guifg=#00ff87
highlight haskellWhere              ctermfg=198 guifg=#ff0087
highlight hsCharacter               ctermfg=15  guifg=#ffffff gui=italic    cterm=italic
highlight hsComment                 ctermfg=8   guifg=#808080
highlight hsConSym                  ctermfg=198 guifg=#ff0087
highlight hsConditional             ctermfg=198 guifg=#ff0087
highlight hsDebug                   ctermfg=48  guifg=#00ff87 gui=underline cterm=underline
highlight hsDelimiter               ctermfg=15  guifg=#ffffff
highlight hsEnumConst               ctermfg=11  guifg=#ffff00
highlight hsExitCode                ctermfg=81  guifg=#5fd7ff
highlight hsFloat                   ctermfg=141 guifg=#af87ff
highlight hsForeign                 ctermfg=48  guifg=#00ff87
highlight hsImport                  ctermfg=198 guifg=#ff0087
highlight hsImportMod               ctermfg=198 guifg=#ff0087
highlight hsInfix                   ctermfg=198 guifg=#ff0087
highlight hsLineComment             ctermfg=8   guifg=#808080
highlight hsLineComment             ctermfg=8   guifg=#808080
highlight hsMaybe                   ctermfg=81  guifg=#5fd7ff
highlight hsModule                  ctermfg=198 guifg=#ff0087
highlight hsNumber                  ctermfg=141 guifg=#af87ff
highlight hsOperator                ctermfg=198 guifg=#ff0087
highlight hsOrdering                ctermfg=81  guifg=#5fd7ff
highlight hsPragma                  ctermfg=11  guifg=#ffff00 gui=italic    cterm=italic
highlight hsSpecialChar             ctermfg=11  guifg=#ffff00
highlight hsSpecialCharError        ctermfg=202 guifg=#ff5f00
highlight hsStatement               ctermfg=81  guifg=#5fd7ff
highlight hsString                  ctermfg=49  guifg=#00ffaf
highlight hsStructure               ctermfg=198 guifg=#ff0087
highlight hsType                    ctermfg=81  guifg=#5fd7ff
highlight hsTypedef                 ctermfg=198 guifg=#ff0087
highlight hsVarSym                  ctermfg=198 guifg=#ff0087

" }}}

" JavaScript {{{

highlight jsArrowFuncArgs           ctermfg=202 guifg=#ff5f00
highlight jsArrowFunction           ctermfg=81  guifg=#5fd7ff
highlight jsAsyncKeyword            ctermfg=81  guifg=#5fd7ff gui=italic cterm=italic
highlight jsBlockLabel              ctermfg=81  guifg=#5fd7ff
highlight jsBlockLabelKey           ctermfg=81  guifg=#5fd7ff
highlight jsBooleanFalse            ctermfg=63  guifg=#5fd7ff
highlight jsBooleanTrue             ctermfg=63  guifg=#5f5fff
highlight jsBuiltins                ctermfg=81  guifg=#5fd7ff
highlight jsCharacter               ctermfg=81  guifg=#5fd7ff
highlight jsClassDefinition         ctermfg=11  guifg=#ffff00 gui=italic cterm=italic
highlight jsClassFuncName           ctermfg=190 guifg=#d7ff00 gui=italic cterm=italic
highlight jsClassKeyword            ctermfg=81  guifg=#5fd7ff
highlight jsClassMethodType         ctermfg=198 guifg=#ff0087
highlight jsClassProperty           ctermfg=190 guifg=#d7ff00
highlight jsComment                 ctermfg=238 guifg=#444444
highlight jsDecorator               ctermfg=198 guifg=#ff0087
highlight jsDecoratorFunction       ctermfg=81  guifg=#5fd7ff
highlight jsDestructuringAssignment ctermfg=14  guifg=#00ffff
highlight jsDestructuringBraces     ctermfg=14  guifg=#00ffff
highlight jsDestructuringNoise      ctermfg=14  guifg=#00ffff
highlight jsExport                  ctermfg=198 guifg=#ff0087
highlight jsExportDefault           ctermfg=198 guifg=#ff0087
highlight jsExtendsKeyword          ctermfg=81  guifg=#5fd7ff gui=none cterm=none
highlight jsFloat                   ctermfg=141 guifg=#af87ff
highlight jsForAwait                ctermfg=198 guifg=#ff0087
highlight jsFrom                    ctermfg=198 guifg=#ff0087
highlight jsFuncArgOperator         ctermfg=202 guifg=#ff5f00
highlight jsFuncArgs                ctermfg=202 guifg=#ff5f00
highlight jsFuncName                ctermfg=190 guifg=#d7ff00 gui=italic cterm=italic
highlight jsFuncParens              ctermfg=81  guifg=#5fd7ff
highlight jsFunction                ctermfg=81  guifg=#5fd7ff
highlight jsGenerator               ctermfg=81  guifg=#5fd7ff
highlight jsGlobalNodeObjects       ctermfg=81  guifg=#5fd7ff
highlight jsGlobalObjects           ctermfg=81  guifg=#5fd7ff
highlight jsImport                  ctermfg=198 guifg=#ff0087
highlight jsLabel                   ctermfg=198 guifg=#ff0087
highlight jsModuleAs                ctermfg=198 guifg=#ff0087
highlight jsModuleAsterisk          ctermfg=198 guifg=#ff0087
highlight jsNoise                   ctermfg=14  guifg=#00ffff
highlight jsNull                    ctermfg=81  guifg=#5fd7ff
highlight jsNumber                  ctermfg=141 guifg=#af87ff
highlight jsObjectFuncName          ctermfg=81  guifg=#5fd7ff gui=italic cterm=italic
highlight jsObjectKey               ctermfg=14  guifg=#00ffff
highlight jsObjectKeyComputed       ctermfg=157 guifg=#afffaf
highlight jsObjectKeyString         ctermfg=157 guifg=#afffaf
highlight jsObjectMethodType        ctermfg=190 guifg=#d7ff00
highlight jsObjectStringKey         ctermfg=157 guifg=#afffaf
highlight jsPrototype               ctermfg=81  guifg=#5fd7ff gui=italic cterm=italic
highlight jsSpecial                 ctermfg=33  guifg=#0087ff
highlight jsStorageClass            ctermfg=81  guifg=#5fd7ff
highlight jsString                  ctermfg=49  guifg=#00ffaf
highlight jsSuper                   ctermfg=81  guifg=#5fd7ff gui=italic cterm=italic
highlight jsSwitchBraces            ctermfg=81  guifg=#5fd7ff
highlight jsSwitchCase              ctermfg=198 guifg=#ff0087
highlight jsSwitchColon             ctermfg=198 guifg=#ff0087
highlight jsTaggedTemplate          ctermfg=198 guifg=#ff0087
highlight jsTemplateBraces          ctermfg=198 guifg=#ff0087
highlight jsTemplateExpression      ctermfg=198 guifg=#ff0087
highlight jsTernaryIfOperator       ctermfg=198 guifg=#ff0087
highlight jsThis                    ctermfg=81  guifg=#5fd7ff
highlight jsUndefined               ctermfg=81  guifg=#5fd7ff

" }}}

" NERDTree {{{

highlight NERDTreeCWD               ctermfg=49  guifg=#00ffaf gui=italic cterm=italic
highlight NERDTREEDir               ctermfg=49  guifg=#00ffaf gui=italic cterm=italic
highlight NERDTreeFile              ctermfg=81  guifg=#5fd7ff
highlight NERDTreeClosable          ctermfg=11  guifg=#ffff00
highlight NERDTreeOpenable          ctermfg=81  guifg=#5fd7ff
highlight NERDTreeDirSlash          ctermfg=81  guifg=#5fd7ff
highlight NERDTreeHelp              ctermfg=49  guifg=#00ffaf
highlight NERDTreeHelpKey           ctermfg=81  guifg=#5fd7ff
highlight NERDTreeHelpTitle         ctermfg=190 guifg=#d7ff00 gui=underline,italic

" }}}

" netrw {{{

highlight netrwSpecial  ctermfg=45              guifg=turquoise2
highlight netrwClassify ctermfg=45              guifg=turquoise2
highlight netrwExe      ctermfg=240             guifg=grey35
highlight netrwTreeBar  ctermfg=240 ctermbg=233 guifg=grey35 guibg=grey7
highlight netrwPlain    ctermfg=81              guifg=steelblue1

" }}}

" Python {{{

highlight pythonBuiltinFunc  ctermfg=81          guifg=#5fd7ff
highlight pythonBuiltinObj   ctermfg=81          guifg=#5fd7ff
highlight pythonStatement    ctermfg=81          guifg=#5fd7ff

" }}}

" XML / JSX {{{

highlight xmlTag     ctermfg=198                guifg=deeppink1
highlight xmlTagName ctermfg=198                guifg=deeppink1
highlight xmlEndTag  ctermfg=198                guifg=deeppink1
highlight xmlAttrib  ctermfg=81                 guifg=steelblue1
highlight xmlEqual   ctermfg=198                guifg=deeppink1

" }}}

" SH / Bash {{{

highlight shStatement      ctermfg=81 guifg=steelblue1
highlight bashStatement    ctermfg=81 guifg=steelblue1
highlight shArithmetic     ctermfg=141 guifg=mediumpurple1

highlight shEscape         ctermfg=15 guifg=white
highlight shCtrlSeq        ctermfg=15 guifg=white
highlight shSpecial        ctermfg=15 guifg=white
highlight shCaseCommandSub ctermfg=15 guifg=white
highlight shCommandSub     ctermfg=15 guifg=white
highlight shDerefSimple    ctermfg=15 guifg=white
highlight shDeref          ctermfg=15 guifg=white

highlight shExSingleQuote  ctermfg=49 guifg=mediumspringgreen
highlight shExDoubleQuote  ctermfg=49 guifg=mediumspringgreen

highlight shStatement      ctermfg=198 guifg=deeppink1
highlight shExpr           ctermfg=198 guifg=deeppink1
highlight shHereDoc        ctermfg=198 guifg=deeppink1
highlight shEcho           ctermfg=198 guifg=deeppink1
highlight shEchoQuote      ctermfg=198 guifg=deeppink1

" }}}
