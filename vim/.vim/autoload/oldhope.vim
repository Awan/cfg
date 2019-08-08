" ------------------------------------------------------------------------------
" Author: j-tom
" Source: https://github.com/j-tom/vim-old-hope
" Note:   Based on the 'An Old Hope' theme for Atom editor
"         (https://atom.io/themes/an-old-hope-syntax)
" ------------------------------------------------------------------------------

" Functions {{{
" * Detect used t_Co
function! oldhope#GetTCo()
  if exists("&t_Co")
    if (&t_Co > 255)
      let l:tCol=256
    elseif (&t_Co > 15 && &t_Co < 256)
      let l:tCol=16
    else
      let l:tCol=8
    endif
  else " no t_Co specified probably using GUI
    let l:tCol=256
    set t_Co=l:tCol
  endif

  return l:tCol
endfunction

" * Set highlighting for the given group
function! oldhope#SetHi(grp, fg, bg, opt)
  let l:gFg  = a:fg['GUI']
  let l:gBg  = a:bg['GUI']
  let l:gOpt = a:opt['GUI']
  let l:tFg  = a:fg['TERM']
  let l:tBg  = a:bg['TERM']
  let l:tOpt = a:opt['TERM']

  let l:hiStr= "hi! " .a:grp
             \ ." guifg="   . l:gFg
             \ ." guibg="   . l:gBg
             \ ." gui="     . l:gOpt
             \ ." ctermfg=" . l:tFg
             \ ." ctermbg=" . l:tBg
             \ ." cterm="   . l:tOpt
  execute l:hiStr
endfunction

" * Link highlighting of one group to another
function! oldhope#LinkHi(obj, target)
  execute "hi! link " .a:obj ." " .a:target
endfunction
" }}}
