" pareto.vim -- Vim color scheme
" Author:      fcpg, from ewilazarus's work
" Webpage:     https://github.com/fcpg/vim-pareto
" Description: Fork from github.com/ewilazarus/preto

" Reset -------------------------------------------------------------------{{{1

set background=dark
highlight clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "pareto"


" Palette ---------------------------------------------------------------- {{{1

let s:palette = {}

let s:palette.black      = [16 , "#000000"]
let s:palette.gray01     = [232, "#080808"]
let s:palette.gray02     = [233, "#121212"]
let s:palette.gray03     = [234, "#1c1c1c"]
let s:palette.gray04     = [235, "#262626"]
let s:palette.gray05     = [236, "#303030"]
let s:palette.gray06     = [237, "#3a3a3a"]
let s:palette.gray07     = [238, "#444444"]
let s:palette.gray08     = [239, "#4e4e4e"]
let s:palette.gray09     = [240, "#585858"]
let s:palette.gray10     = [241, "#606060"]
let s:palette.gray11     = [242, "#666666"]
let s:palette.gray12     = [243, "#767676"]
let s:palette.gray13     = [244, "#808080"]
let s:palette.gray14     = [245, "#8a8a8a"]
let s:palette.gray15     = [246, "#949494"]
let s:palette.gray16     = [247, "#9e9e9e"]
let s:palette.gray17     = [248, "#a8a8a8"]
let s:palette.gray18     = [249, "#b2b2b2"]
let s:palette.gray19     = [250, "#bcbcbc"]
let s:palette.gray20     = [251, "#c6c6c6"]
let s:palette.gray21     = [252, "#d0d0d0"]
let s:palette.gray22     = [253, "#dadada"]
let s:palette.gray23     = [254, "#e4e4e4"]
let s:palette.white      = [255, "#eeeeee"]
let s:palette.fullwhite  = [255, "#ffffff"]

" let s:palette.offwhite   = [254, "#e8e1d6"]
let s:palette.offwhite   = [254, "#eeeeee"]
let s:palette.darkred    = [52 , "#5f0000"]


" Utilities -------------------------------------------------------------- {{{1

function! s:HL(item, fgColor, bgColor, style, ...)
	let undesirable_runtimes = a:000
	for runtime in undesirable_runtimes
		if has(runtime)
			return	
		end
	endfor

	let target = 'cterm'
	let pindex = 0
	let has_tgc = (exists('+termguicolors') && &termguicolors)
	if has('gui_running') || has_tgc
		let target = 'gui'
		let pindex = 1
	end

	let command  = 'hi ' . a:item
	let command .= ' ' . target . 'fg=' . a:fgColor[pindex]
	let command .= ' ' . target . 'bg=' . a:bgColor[pindex]
	let command .= ' ' . (has_tgc?'cterm':target) . '=' . a:style

	exe command
endfun


" Composition ------------------------------------------------------------ {{{1

" PRIMITIVES
call s:HL('Normal',         s:palette.offwhite,  s:palette.black,  'none')
call s:HL('Boolean',        s:palette.gray16,    s:palette.black,  'none')
call s:HL('Character',      s:palette.gray16,    s:palette.black,  'none')
call s:HL('Constant',       s:palette.gray16,    s:palette.black,  'bold')
call s:HL('Number',         s:palette.gray16,    s:palette.black,  'none')
call s:HL('String',         s:palette.gray18,    s:palette.gray03, 'none')
call s:HL('SpecialChar',    s:palette.fullwhite, s:palette.gray01, 'none')

" COMMENTS
call s:HL('Comment',        s:palette.gray12,    s:palette.black,  'none')
call s:HL('SpecialComment', s:palette.gray14,    s:palette.black,  'none')
call s:HL('Title',          s:palette.fullwhite, s:palette.black,  'none')
call s:HL('Todo',           s:palette.fullwhite, s:palette.black,  'bold')

" LINES, COLUMNS
call s:HL('LineNr',         s:palette.gray09,    s:palette.black,  'none')
call s:HL('CursorLine',     s:palette.white,     s:palette.gray03, 'none')
call s:HL('CursorLineNr',   s:palette.gray11,    s:palette.black,  'none')

call s:HL('ColorColumn',    s:palette.white,     s:palette.gray03, 'none')
call s:HL('CursorColumn',   s:palette.gray16,    s:palette.gray03, 'none')

" VISUAL MODE
call s:HL('Visual',         s:palette.fullwhite, s:palette.gray05, 'none')
call s:HL('VisualNOS',      s:palette.fullwhite, s:palette.gray05, 'none')

" SEARCH
call s:HL('Search',         s:palette.black,     s:palette.gray16, 'none')
call s:HL('IncSearch',      s:palette.white,     s:palette.gray08, 'bold')

" SPELLING
call s:HL('SpellBad',       s:palette.white,     s:palette.gray03, 'bold')
call s:HL('SpellCap',       s:palette.white,     s:palette.gray03, 'none')
call s:HL('SpellLocal',     s:palette.white,     s:palette.gray03, 'none')
call s:HL('SpellRare',      s:palette.white,     s:palette.gray03, 'none')

" ERROR
call s:HL('Error',          s:palette.fullwhite, s:palette.gray03, 'bold')

" COMMAND MODE MESSAGES
call s:HL('ErrorMsg',       s:palette.fullwhite, s:palette.gray03, 'bold')
call s:HL('WarningMsg',     s:palette.fullwhite, s:palette.black,  'none')
call s:HL('ModeMsg',        s:palette.white,     s:palette.black,  'none')
call s:HL('MoreMsg',        s:palette.white,     s:palette.black,  'none')

" PREPROCESSOR DIRECTIVES
call s:HL('PreProc',        s:palette.white,     s:palette.black,  'none')

" BINDINGS
call s:HL('Identifier',     s:palette.fullwhite, s:palette.black,  'none')
call s:HL('Function',       s:palette.white,     s:palette.black,  'none')
call s:HL('Keyword',        s:palette.gray16,    s:palette.black,  'none')
call s:HL('Operator',       s:palette.gray21,    s:palette.black,  'none')

" TYPES
call s:HL('Type',           s:palette.white,     s:palette.black,  'none')

" FLOW CONTROL
call s:HL('Statement',      s:palette.white,     s:palette.black,  'none')
call s:HL('Label',          s:palette.white,     s:palette.black,  'none')

" MISC
call s:HL('Cursor',         s:palette.white,     s:palette.black,  'none', 'gui_macvim')
call s:HL('Underlined',     s:palette.gray16,    s:palette.gray02, 'none')
call s:HL('SpecialKey',     s:palette.white,     s:palette.black,  'bold')
call s:HL('NonText',        s:palette.darkred,   s:palette.black,  'none')
call s:HL('Directory',      s:palette.fullwhite, s:palette.gray02, 'none')

" FOLD
call s:HL('FoldColumn',     s:palette.gray10,    s:palette.black,  'none')
call s:HL('Folded',         s:palette.gray10,    s:palette.black,  'none')

" SIGN
call s:HL('SignColumn',     s:palette.gray10,    s:palette.black,  'none')

" PARENTHESIS
call s:HL('MatchParen',     s:palette.fullwhite, s:palette.gray02,  'none')

" POPUP
call s:HL('Pmenu',          s:palette.white,     s:palette.gray09, 'none')
call s:HL('PmenuSbar',      s:palette.black,     s:palette.gray19, 'none')
call s:HL('PmenuSel',       s:palette.black,     s:palette.gray19, 'none')
call s:HL('PmenuThumb',     s:palette.gray01,    s:palette.gray09, 'none')

" SPLITS
call s:HL('VertSplit',      s:palette.gray10,    s:palette.black,  'none')

" OTHERS
call s:HL('Debug',          s:palette.white,     s:palette.black,  'none')
call s:HL('Delimiter',      s:palette.white,     s:palette.black,  'none')
call s:HL('Question',       s:palette.white,     s:palette.black,  'none')
call s:HL('Special',        s:palette.white,     s:palette.black,  'none')
call s:HL('StatusLine',     s:palette.white,     s:palette.black,  'none', 'gui_macvim')
call s:HL('StatusLineNC',   s:palette.white,     s:palette.black,  'none', 'gui_macvim')
call s:HL('Tag',            s:palette.white,     s:palette.black,  'none')
call s:HL('WildMenu',       s:palette.white,     s:palette.black,  'none')

" DIFF
call s:HL('DiffAdd',        s:palette.fullwhite, s:palette.gray02, 'bold')
call s:HL('DiffChange',     s:palette.white,     s:palette.black,  'none')
call s:HL('DiffDelete',     s:palette.gray10,    s:palette.black,  'none')
call s:HL('DiffText',       s:palette.fullwhite, s:palette.gray04, 'bold')

" TABLINE
call s:HL('TabLine',        s:palette.gray18,    s:palette.gray03, 'none')
call s:HL('TabLineFill',    s:palette.white,     s:palette.gray03, 'none')
call s:HL('TabLineSel',     s:palette.fullwhite, s:palette.gray02, 'none')

" Links ------------------------------------------------------------------ {{{1

hi! link   Float            Number
hi! link   Conditional      Statement
hi! link   Repeat           Statement
hi! link   Exception        Statement
hi! link   Include          PreProc
hi! link   Define           PreProc
hi! link   Macro            PreProc
hi! link   PreCondit        PreProc
hi! link   StorageClass     Type
hi! link   Structure        Type
hi! link   Typedef          Type
hi! link   StatusLineTerm   StatusLine
hi! link   StatusLineTermNC StatusLineNC
hi! link   QuickFixLine     Search
hi! link   VimFuncKey       VimCommand
hi! link   VimSubstPat      VimString
hi! link   htmlItalic       Underlined
hi! link   qfLineNr         Comment


" Filetype Specific ------------------------------------------------------ {{{1

" MARKDOWN
call s:HL('markdownUrl',    s:palette.gray11,    s:palette.black,  'none')
call s:HL('markdownCode',   s:palette.gray14,    s:palette.black,  'none')


" Plugin Specific -------------------------------------------------------- {{{1

