"  ▓▓▓▓▓▓▓▓▓▓ 
" ░▓ Author ▓ Abdullah <https://abdullah.today/> 
" ░▓▓▓▓▓▓▓▓▓▓ 
" ░░░░░░░░░░ 


set nocompatible
set ruler
source ~/.vim/autoload/supertab.vim
let g:zenburn_old_Visual = 1
let g:zenburn_high_contrast = 1
let g:zenburn_force_dark_Background = 1
set fo+=w
colorscheme wombat256dave
cmap w!! %!sudo tee > /dev/null %
set nu
set hlsearch
autocmd! bufwritepost ~/.Xresources !xrdb -load ~/.Xresources
autocmd! bufwritepost ~/.zshrc	!source ~/.zshrc
autocmd! bufwritepost ~/.config/sxhkd/sxhkdrc	!pkill -USR1 -x sxhkd
autocmd! bufwritepost ~/cfg/sxhkd/.config/sxhkd/sxhkdrc	!pkill -USR1 -x sxhkd
autocmd! bufwritepost ~/cfg/zsh/.zsh/custom-alias !source ~/cfg/zsh/.zsh/custom-alias
set nocp
filetype on
set bg=dark
au BufNewFile,BufRead *Pkgfile set filetype=sh
set textwidth=80
"au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/ " will make extra spaces red
set fileencoding=utf-8
filetype plugin indent on
set showmode
set nu
set ai
set sc
set noincsearch
set completeopt=menuone
set ignorecase
set smartcase
set cursorline
set scrolloff=8
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
set autoindent
set nohlsearch
set showmatch
set laststatus=2
set noshowmode 
set undofile
set undodir=~/.vim/undodir
set viminfo='10,\"100,:20,%,n~/.viminfo
set nobackup
set showcmd
set whichwrap=b,s,<,>,[,]
set laststatus=2
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

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit | 0d_ | diffthis 
        \ wincmd p | diffthis
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

"augroup resCur
"  autocmd!
"  autocmd BufWinEnter * call ResCur()
"augroup END
autocmd FileType python set breakindentopt=shift:4
command! -range=% PB  <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/ | sed -n 's/^url: //p' | xclip
command! -range=% TB  <line1>,<line2>w !fb
command! -range=% GT <line1>,<line2>w !gist-paste -c -p 

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

" vim: set ft=vim :
