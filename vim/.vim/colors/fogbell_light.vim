"
"
"        ┌─┐┌─┐┌─┐┌┐ ┌─┐┬  ┬
"        ├┤ │ ││ ┬├┴┐├┤ │  │
"        └  └─┘└─┘└─┘└─┘┴─┘┴─┘
"
"
" by Jared Gorski
" https://github.com/jaredgorski/fogbell
" >> custom modifications by n0mad (https://codeberg.org/n0mad)

scriptencoding utf-8

set background=light
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="fogbell_light"

" ==========================
" Highlighting Function
" ==========================
"  >> (inspired by https://github.com/tomasiser/vim-code-dark and https://github.com/chriskempson/base16-vim)
fun! <sid>hi(group, fg, bg, attr)
  if !empty(a:fg)
    exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" .  a:fg.cterm256
  endif
  if !empty(a:bg)
    exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" .  a:bg.cterm256
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

" ==========================
" Color Variables
" ==========================
let s:voidBlack =  {'gui': '#121212', 'cterm256': '233'}
let s:voidBlack2 = {'gui': '#262626', 'cterm256': '235'}
let s:voidGray1 =  {'gui': '#3E3D32', 'cterm256': '237'}
let s:voidGray2 =  {'gui': '#49483E', 'cterm256': '239'}
let s:voidGray3 =  {'gui': '#6B6B6B', 'cterm256': '242'}
let s:voidGray4 =  {'gui': '#B0B0B0', 'cterm256': '249'}
"let s:voidSteel = {'gui': '#D0D0D0', 'cterm256': '252'}
let s:voidSteel =  {'gui': '#C6C6C6', 'cterm256': '251'}
let s:voidBlue =   {'gui': '#185D78', 'cterm256': '74'}
let s:voidBlueSoft = {'gui' : '#7495b6', 'cterm256': '74'}
let s:voidGreen =  {'gui': '#24781A', 'cterm256': '82'}
let s:voidGold =   {'gui': '#8E700B', 'cterm256': '136'}
let s:voidRed =    {'gui': '#821A1A', 'cterm256': '1'}
let s:voidRed2 =   {'gui': '#FF0000', 'cterm256': '208'}
let s:voidOrange = {'gui': '#FF8600', 'cterm256': '208'}
let s:none =       {'gui': 'NONE', 'cterm256': 'NONE'}

" ==========================
" Definitions
" ==========================
"    <sid>hi(GROUP, FOREGROUND, BACKGROUND, ATTRIBUTE)

" Editor
call <sid>hi('ColorColumn',  s:none, 		s:none, 'none')
call <sid>hi('Cursor', 		 s:voidSteel, 	s:none, 'none')
call <sid>hi('CursorColumn', s:none, 		s:none, 'none')
call <sid>hi('CursorLine', 	 s:voidBlack, 	s:voidGray4, 'none')
call <sid>hi('CursorLineNr', s:voidBlack, 	s:voidGray4, 'none')
call <sid>hi('Directory',    s:voidBlack, 	s:none, 'none')
call <sid>hi('Folded', 		 s:voidGray3, 	s:none, 'none')
call <sid>hi('IncSearch',    s:voidBlack, 	s:voidGreen, 'none')
call <sid>hi('LineNr', 		 s:voidGray3, 	s:none , 'none')
call <sid>hi('MatchParen',   s:voidBlack, 	s:voidGray4, 'none')
call <sid>hi('Normal', 		 s:voidBlack, 	s:voidSteel, 'none')
call <sid>hi('Pmenu',  		 s:voidBlack, 	s:voidGray4, 'none')
call <sid>hi('PmenuSel', 	 s:voidSteel, 	s:voidGray2, 'none')
call <sid>hi('PmenuThumb', 	 s:voidSteel, 	s:voidGray3, 'none')
call <sid>hi('Search', 		 s:voidBlack, 	s:voidGreen, 'none')
call <sid>hi('StatusLine', 	 s:voidSteel, 	s:voidBlack, 'none')
call <sid>hi('StatusLineNC', s:voidGray3, 	s:voidBlack2, 'none')
call <sid>hi('VertSplit', 	 s:voidGray3, 	s:voidGray3, 'none')
call <sid>hi('Visual', 		 s:none, 		s:voidGray4, 'none')
call <sid>hi('TabLine', 	 s:voidBlack, 	s:none, 'none')
call <sid>hi('TabLineFill',  s:voidBlack, 	s:none, 'none')


" General
call <sid>hi('Boolean', 	s:voidBlack, s:none, 'none')
call <sid>hi('Character', 	s:voidBlack, s:none, 'none')
call <sid>hi('Comment', 	s:voidGreen, s:none, 'none')
call <sid>hi('Conditional', s:voidBlack, s:none, 'none')
call <sid>hi('Constant', 	s:voidBlack, s:none, 'none')
call <sid>hi('Define', 		s:voidBlack, s:none, 'none')
call <sid>hi('DiffAdd', 	s:voidSteel, s:voidGreen, 'none')
call <sid>hi('DiffChange', 	s:voidSteel, s:voidGold, 'none')
call <sid>hi('DiffDelete', 	s:voidBlack, s:voidRed, 'none')
call <sid>hi('DiffText', 	s:voidGray1, s:voidBlue, 'none')
call <sid>hi('ErrorMsg', 	s:voidBlack, s:voidRed, 'none')
call <sid>hi('Float', 		s:voidRed,   s:none, 'none')
call <sid>hi('Function', 	s:voidBlue,  s:none, 'none')
call <sid>hi('Identifier', 	s:voidBlack, s:none, 'none')
call <sid>hi('Keyword', 	s:voidBlack, s:none, 'none')
call <sid>hi('Label', 		s:voidBlack, s:none, 'none')
call <sid>hi('NonText', 	s:voidGray1, s:none, 'none')
call <sid>hi('Number', 		s:voidRed,   s:none, 'none')
call <sid>hi('Operator', 	s:voidBlack, s:none, 'none')
call <sid>hi('PreProc', 	s:voidBlack, s:none, 'none')
call <sid>hi('Special', 	s:voidBlack, s:none, 'none')
call <sid>hi('SpecialKey', 	s:voidBlack, s:none, 'none')
call <sid>hi('SpellBad', 	s:voidRed2,  s:voidBlack, 'italic,undercurl')
call <sid>hi('SpellCap', 	s:voidBlack, s:none, 'italic,undercurl')
call <sid>hi('SpellLocal', 	s:voidBlack, s:none, 'undercurl')
call <sid>hi('Statement', 	s:voidBlack, s:none, 'none')
call <sid>hi('StorageClass', s:voidBlack, s:none, 'none')
call <sid>hi('String', 		s:voidBlack, s:none, 'none')
call <sid>hi('Tag', 		s:voidBlack, s:none, 'none')
call <sid>hi('Title', 		s:none, s:none, 'bold')
call <sid>hi('Todo', 		s:voidOrange, s:voidBlack, 'inverse,bold')
call <sid>hi('Type', 		s:none, s:none, 'none')
call <sid>hi('Underlined', 	s:none, s:none, 'underline')
call <sid>hi('WarningMsg', 	s:voidBlack, s:voidRed, 'none')

" Diff Mode
if &diff
  call <sid>hi('DiffAdd', 		s:voidSteel, 	s:voidGreen, 'none')
  call <sid>hi('DiffChange', 	s:voidSteel, 	s:voidGold, 'none')
  call <sid>hi('DiffDelete', 	s:voidRed2, 	s:voidRed, 'none')
  call <sid>hi('DiffText', 		s:voidGray1, 	s:voidBlue, 'none')
else
  call <sid>hi('DiffAdd', s:voidGreen, s:none, 'none')
  call <sid>hi('DiffChange', s:voidGold, s:none, 'none')
  call <sid>hi('DiffDelete', s:voidRed2, s:none, 'none')
  call <sid>hi('DiffText', s:voidBlack, s:voidBlue, 'none')
endif

" ------------
" Languages
" ------------

" C
call <sid>hi('cConstant', 			s:voidBlack, s:none, 'none')
call <sid>hi('cFormat', 			s:voidBlack, s:none, 'none')
call <sid>hi('cMulti', 				s:voidBlack, s:none, 'none')
call <sid>hi('cNumbers', 			s:voidBlack, s:none, 'none')
call <sid>hi('cOperator', 			s:voidBlack, s:none, 'none')
call <sid>hi('cSpecial', 			s:voidBlack, s:none, 'none')
call <sid>hi('cSpecialCharacter', 	s:voidBlack, s:none, 'none')
call <sid>hi('cStatement', 			s:voidBlack, s:none, 'none')
call <sid>hi('cStorageClass', 		s:voidBlack, s:none, 'none')
call <sid>hi('cString', 			s:voidGreen, s:none, 'none')
call <sid>hi('cStructure', 			s:voidBlack, s:none, 'none')
call <sid>hi('cType', 				s:voidBlack, s:none, 'none')

" C++
call <sid>hi('cppConstant', 		s:voidBlack, s:none, 'none')
call <sid>hi('cppFormat', 			s:voidBlack, s:none, 'none')
call <sid>hi('cppMulti', 			s:voidBlack, s:none, 'none')
call <sid>hi('cppNumbers', 			s:voidBlack, s:none, 'none')
call <sid>hi('cppOperator', 		s:voidBlack, s:none, 'none')
call <sid>hi('cppSpecial', 			s:voidBlack, s:none, 'none')
call <sid>hi('cppSpecialCharacter', s:voidBlack, s:none, 'none')
call <sid>hi('cppStatement', 		s:voidBlack, s:none, 'none')
call <sid>hi('cppStorageClass', 	s:voidBlack, s:none, 'none')
call <sid>hi('cppString', 			s:voidBlack, s:none, 'none')
call <sid>hi('cppStructure', 		s:voidBlack, s:none, 'none')
call <sid>hi('cppType', 			s:voidBlack, s:none, 'none')


" ------------
" Plugins
" ------------

" todo.txt
call <sid>hi('TodoContext', s:voidBlack, s:none, 'none')
call <sid>hi('TodoDate', s:voidBlack, s:none, 'none')
call <sid>hi('TodoDone', s:voidGray3, s:none, 'none')
call <sid>hi('TodoPriorityA', s:voidBlack, s:none, 'none')
call <sid>hi('TodoPriorityB', s:voidBlack, s:none, 'none')
call <sid>hi('TodoPriorityC', s:voidBlack, s:none, 'none')
call <sid>hi('TodoProject', s:voidBlack, s:none, 'none')

" Buftabline
call <sid>hi('BufTabLineActive', s:voidBlack, s:voidGray3, 'none')
call <sid>hi('BufTabLineCurrent', s:voidBlack, s:voidGray4, 'none')
call <sid>hi('BufTabLineFill', s:voidBlack, s:voidSteel, 'none')
call <sid>hi('BufTabLineHidden', s:voidGray3, s:voidBlack2, 'none')
