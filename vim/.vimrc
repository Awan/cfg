" In the name of Allah, the most Gracious, the most Merciful.
" 
"  ▓▓▓▓▓▓▓▓▓▓
" ░▓ Author ▓ Abdullah <https://abdullah.today>
" ░▓▓▓▓▓▓▓▓▓▓
" ░░░░░░░░░░
" 
" ░█░█░▀█▀░█▄█
" ░▀▄▀░░█░░█░█
" ░░▀░░▀▀▀░▀░▀

set ruler
let g:zenburn_old_Visual = 1
let g:zenburn_high_contrast = 1
let g:zenburn_force_dark_Background = 1
set fo+=w
colorscheme vim-hardaway
cmap w!! %!sudo tee > /dev/null %

" Set relative number but also show current line number (no zero for current
" line)
set number relativenumber

if exists('g:loaded_translate_plugin')
  finish
endif
let g:loaded_translate_plugin = 1

command! -nargs=* Translate call translate#run(<q-args>)
command! -nargs=* -range TranslateVisual call translate#visual(<q-args>)
command! -nargs=* -range TranslateReplace call translate#replace(<q-args>)
command! TranslateOpen call translate#open_trans_buf('')
command! TranslateClear call translate#clear_trans_buf()

set hlsearch
autocmd! bufwritepost ~/.Xresources !xrdb -load ~/.Xresources && urxvtc 
autocmd! bufwritepost ~/.zshrc	!source ~/.zshrc
autocmd! bufwritepost ~/.config/sxhkd/sxhkdrc	!pkill -USR1 -x sxhkd
autocmd! bufwritepost ~/cfg/sxhkd/.config/sxhkd/sxhkdrc	!pkill -USR1 -x sxhkd
autocmd! bufwritepost ~/cfg/zsh/.zsh/custom-alias !source ~/cfg/zsh/.zsh/custom-alias
set nocp
filetype on
set bg=dark
au BufNewFile,BufRead *Pkgfile set filetype=sh
set textwidth=80
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set fileencoding=utf-8
filetype plugin indent on
set showmode
set ai
set sc
set noincsearch
set completeopt=menuone
set ignorecase
set smartcase
set cursorline
set cursorcolumn
set noexpandtab
set backspace=indent,eol,start
syntax on
if has('mouse') | set mouse=a | endif 
let mapleader=" "
set hidden
set history=10000
filetype indent on
filetype plugin on
set linebreak 
set wrap
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamed,unnamedplus
set ttyfast
set smartindent
set wildmenu
set autoindent
set nohlsearch
set lazyredraw
set showmatch
set noshowmode 
set undofile
set undodir=~/.vim/undodir
set viminfo='10,\"100,:20,%,n~/.viminfo
set nobackup
set showcmd
set whichwrap=b,s,<,>,[,]
set laststatus=2
let g:colors_name = 'vim-hardaway'
let g:airline_theme = 'vim_hardaway'
let g:instant_markdown_browser = "/usr/bin/google-chrome-stable --new-window"
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
let g:instant_markdown_port = 47479
let g:powerline_pycmd = 'py3'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

:noremap <leader>u :w<Home>silent <End> !urlview<CR>
autocmd BufEnter *.md exe 'noremap <F5> :!google-chrome-stable %:p<CR>'
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

function! DeleteFunctionUnderCursor()
  let line = getline('.')
  normal diwxml
  let i = 1
  let c = 1
  while i <= strlen(line)
      let char = getline('.')[col('.') - 1]
      if (char == '(')
          let c += 1
      elseif (char == ')')
          let c -= 1
      endif
      if (c == 0)
          normal x`l
          break
      endif
      normal l
      let i += 1
  endwhile
endfunc

command! -range=% DeleteFunctionUnderCursor <line1>,<line2>call DeleteFunctionUnderCursor()

function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
       set relativenumber
    endif
endfunc
command! ToggleNumber call ToggleNumber()

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit | 0d_ | diffthis 
        \ wincmd p | diffthis
endif

if &t_Co == 8 && $TERM !~# '^linux\|^Eterm|^screen-*'
  set t_Co=16
endif


" duplicate lines
function! HighlightRepeats() range
    let lineCounts = {}
    let lineNum = a:firstline
    while lineNum <= a:lastline
        let lineText = getline(lineNum)
        if lineText != ""
            let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
        endif
        let lineNum = lineNum + 1
    endwhile
    exe 'syn clear Repeat'
    for lineText in keys(lineCounts)
        if lineCounts[lineText] >= 2
            exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
        endif
    endfor
endfunction
command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
autocmd FileType python set breakindentopt=shift:4
command! -range=% PB  <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/ | sed -n 's/^url: //p' | xclip
command! -range=% TB  <line1>,<line2>w !fb
command! -range=% GT <line1>,<line2>w !gist -c -p -f %

" comfortable navigation
noremap <buffer> j gj
noremap <buffer> k gk
noremap <buffer> gj j
noremap <buffer> gk k


" some pastebins commands
" for GUI apps like browsers, paste the URL with CTRL+v
command! -range=% CL  <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | xclip -i -selection clipboard

" Another good pastebin same as CTRL+v paste.
command! -range=% VP  <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | xclip -i -selection clipboard

map <F3> :! ( urxvt & ) &>/dev/null &<CR><CR>

" Run python code without exiting vim
nmap <silent> <Leader>m :w<CR>:!clear && python % > /tmp/vim-py.out && cat /tmp/vim-py.out && rm -f /tmp/vim-py.out<CR>

" Run bash code without exiting vim
nmap <silent> <Leader>b :w<CR>:!clear && bash % > /tmp/vim-bash.out && cat /tmp/vim-bash.out && rm -f /tmp/vim-bash.out<CR>

" vim: set ft=vim :
