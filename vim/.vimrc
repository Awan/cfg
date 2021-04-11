"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""                                                                 """
"""                                                                 """
"""     In the name of Allah, the most Gracious, the most Merciful. """
"""                                                                 """
"""      ▓▓▓▓▓▓▓▓▓▓                                                 """
"""     ░▓ Author ▓ Abdullah <https://abdullah.today>               """
"""     ░▓▓▓▓▓▓▓▓▓▓                                                 """
"""     ░░░░░░░░░░                                                  """
"""                                                                 """
"""     ░█▀█░█░█░▀█▀░█▄█                                            """
"""     ░█░█░▀▄▀░░█░░█░█                                            """
"""     ░▀░▀░░▀░░▀▀▀░▀░▀                                            """
"""                                                                 """
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Install vim-plug 
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"endif
"
"" Run PlugInstall if there are missing plugins
"autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \| PlugInstall --sync | source $MYVIMRC
"\| endif
"
"" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"
"" Call vim-plug
"
"" Directory to save plugins
"
"call plug#begin('~/.vim/plugged')
"
"" Plugins
"
"Plug 'ryanoasis/vim-devicons' | Plug 'neoclide/coc.nvim', { 'branch': 'release' } | Plug 'honza/vim-snippets' | Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' | Plug 'neoclide/coc-snippets' | Plug 'dylanaraps/wal' | Plug 'jiangmiao/auto-pairs'
"
"" Initialize vim-plug
"
"call plug#end()
"
" Use vim settings rather than vi
if &compatible
    set nocompatible
endif
" Show relative numbers
set rnu nu
" Set colorscheme
color afterglow
" Set status line
set laststatus=2
set statusline=
" Show file path
set statusline+=%#Question#
set statusline+=%f
" Show current mode
let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'V·Line ',
       \ '' : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'R ',
       \ 'Rv' : 'V·Replace ',
       \ 'c'  : 'Command ',
       \}
set statusline+=%#LineNr#
set statusline+=\ %{toupper(g:currentmode[mode()])}
set statusline+=%{&paste?'[paste]':''}
set statusline+=\ %m
set statusline+=%#MoreMsg#
set statusline+=%r
set statusline+=%#StatusLine#
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=%#Constant#
set statusline+=\ %y
set statusline+=%#PreProc#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=%#Tag#
set statusline+=\ [%{&fileformat}\]
set statusline+=%#Debug#
set statusline+=\ %p%%
set statusline+=%#Number#
set statusline+=\ %l:%c
function! SaveIfUnsaved()
    if &modified
        :silent! w
    endif
endfunction

" w!! to write file as root
cmap w!! %!doas tee > /dev/null %
" No comments with o
set formatoptions-=o
" au FocusLost,BufLeave * :call SaveIfUnsaved()
au FocusGained,BufEnter * :silent! !

set ruler

if &diff
    highlight! link DiffText MatchParen
else
"    setup for non-diff mode
endif

" Sessions management
" No help windows
set sessionoptions-=help
set sessionoptions-=curdir

silent! set numberwidth=4

if &t_Co > 2 || has("gui_running")
    set hlsearch
endif

autocmd! bufwritepost $HOME/.Xresources !xrdb -load $HOME/.Xresources 
autocmd! bufwritepost $HOME/.zshrc      !source $HOME/.zshrc
autocmd! bufwritepost $HOME/.config/sxhkd/sxhkdrc       !pkill -USR1 -x sxhkd
autocmd! bufwritepost $HOME/cfg/sxhkd/.config/sxhkd/sxhkdrc     !pkill -USR1 -x sxhkd
autocmd! bufwritepost $HOME/cfg/zsh/.zsh/custom-alias !source $HOME/.zsh/custom-alias
autocmd! bufwritepost $HOME/cfg/polybar/.config/polybar/*.conf !bspc wm -r >/dev/null 2>&1 
set nocp
filetype on
au BufNewFile,BufRead *Pkgfile set filetype=sh
set textwidth=80
if !&scrolloff
  set scrolloff=3
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set foldlevel=4
set foldmethod=marker
"set foldmarker=<<<,>>>
filetype plugin indent on
set showmode
set fo+=w
set ai
set sc
if has('reltime')
    set incsearch
endif
set nrformats=octal
set completeopt=menuone
set ignorecase
set wrapscan
set magic
set gdefault
com! -complete=file -bang -nargs=? W :w<bang> <args>
set smartcase
set cursorcolumn
set colorcolumn=+1
set cursorline
hi ColorColumn guifg=#232526 guibg=#F92672
hi CursorColumn guifg=white guibg=#2b3f4a
set noexpandtab
set backspace=indent,eol,start
if has("syntax")
    syntax on
    syntax sync minlines=200
endif
if has('mouse') | set mouse=a | endif 
let mapleader=" "
set hidden
set autoread
set history=10000
filetype plugin indent on
set linebreak
set display+=lastline
set display+=truncate
set display+=uhex
silent! set listchars=eol:¬,tab:→.,extends:»,precedes:«,trail:•
set list
set wrap
set tabstop=8
set smarttab copyindent preserveindent
set shiftwidth=4
set softtabstop=4
set expandtab
retab
set clipboard=unnamed,unnamedplus
set ttyfast
set smartindent
set wildmenu
silent! set wildignorecase
set noerrorbells visualbell t_vb=
set shortmess+=I
set autoindent
set nocindent
set cinkeys=0{,0},0),:,!,o,O,e
set formatoptions=tcrqnjw
set comments-=:%
set comments-=:XCOMM
set lazyredraw
set noshowmatch

if has("unix")
    if has("nvim")
        set undofile
    else
        silent! set undodir=~/.vim/undodir//
        silent! set undofile
    endif
endif
set noshowmode
set viminfo='10,\"100,:20,%,n~/.viminfo
autocmd BufWritePre *.c,*.cpp,*.cc,*.h,*.sh,*.hpp,*.py,*.m,*.mm :%s/\s\+$//e
set modeline
set nobackup
set showcmd
set whichwrap=b,s,<,>,[,]
set splitbelow splitright
set tabpagemax=20
if &t_Co > 16
        setl cursorline
        au WinEnter * setl cursorline
        au WinLeave * setl nocursorline
        au FocusGained * setl cursorline
        au FocusLost * setl nocursorline
endif
hi CursorLine guifg=white guibg=#2b3f4a

let g:instant_markdown_browser = "/usr/bin/google-chrome-stable --new-window"
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
let g:instant_markdown_port = 47479
"let g:powerline_pycmd = 'py3'
"let g:ycm_autoclose_preview_window_after_completion = 1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#ale#enabled = 1
"let g:ale_sign_error = '●'
"let g:ale_sign_warning = '.'
"let g:airline#extensions#tabline#formatter = 'default'
"let g:airline_powerline_fonts = 1
"
"if !exists('g:airline_symbols')
"    let g:airline_symbols = {}
"endif
"
"" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'
"" airline symbols
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:ale_fix_on_save = 1
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''

noremap <leader>u :w \| startinsert \| term urlview %<CR>
map <leader>n :CocCommand explorer<CR>
" comment out current line
map <leader>c 0i# <ESC>
nnoremap ; :
nnoremap K <nop>
nnoremap q :q
nnoremap qq :q!<CR>
nnoremap Q q
inoremap # #
autocmd BufEnter *.md exe 'noremap <F5> :!google-chrome-stable %:p<CR>'
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile
"autocmd BufReadPost *
"     \ if line("'\"") > 0 && line("'\"") <= line("$") |
"     \   exe "normal! g`\"" |
"     \ endif
autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~#'commit'
            \ | exe "normal! g`\""
            \ | endif

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

"if &t_Co == 8 && $TERM !~# '^linux\|^Eterm|^screen-*'
"  set t_Co=16
"endif

if has("nvim")
    silent! set guicursor=
endif

hi CursorLineNr cterm=NONE

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

" comfortable navigation
nnoremap k gk
nnoremap j gj
nnoremap <Up> gk
nnoremap <Down> gj
nnoremap <Tab> %
vnoremap <Tab> %
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


if has("nvim") || has("terminal")
        tnoremap <Esc> <C-\><C-n>
endif


nnoremap <Leader>l :ls<CR>:b<Space>
nnoremap <Leader>b :bd<CR>
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>t :terminal<CR>
nnoremap <Leader>rw :%s/\<<C-r><C-w>\>/
" sort CSS properties
nnoremap <Leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
" reselect pasted text
nnoremap <Leader>v `[V`]
" rewrap current paragraph
nnoremap <Leader>w gq}
" strip trailing whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=""<CR>

" fix application-numpad mode
if !has("nvim")
        " (Vim 8.1) with Num Lock off, Num5 is parsed as individual commands
        map! <Esc>OE <Nop>
endif
set nottimeout
"let g:python_host_prog = "/usr/bin/python2.7"
let g:python3_host_prog = "/usr/bin/python3.9"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

noremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


if has("autocmd")
        au BufNewFile,BufRead COMMIT_EDITMSG,git-rebase-todo
        \ setl nomodeline

        au BufNewFile,BufRead /etc/motd
        \ setl et

        au BufNewFile,BufRead authorized_keys*,known_hosts,id_*.pub
        \ setl ft=conf wrap nolinebreak

        au! BufNewFile */_posts/2*.html
        \ 0r %:h/_template.html

        if has("nvim")
                " Neovim 0.2.1: terminal buffers now have line numbers
                au! TermOpen * setl nonumber norelativenumber
        endif
endif


" some pastebins commands
" for GUI apps like browsers, paste the URL with CTRL+v
command! -range=% CL  <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | xclip -i -selection clipboard

" Another good pastebin same as CTRL+v paste.
command! -range=% VP  <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | xclip -i -selection clipboard

" pastebin ptpb is now down but is the best pastebin ever
command! -range=% PB  <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/ | sed -n 's/^url: //p' | xclip

command! -range=% TB  <line1>,<line2>w !fb

command! -range=% GT <line1>,<line2>w !gist -c -p -f %


map <F3> :! ( urxvt & ) &>/dev/null &<CR><CR>

" Run python code without exiting vim
nmap <silent> <Leader>m :w<CR>:!clear && python % > /tmp/vim-py.out && cat /tmp/vim-py.out && rm -f /tmp/vim-py.out<CR>

" Run bash code without exiting vim
nmap <silent> <Leader>o :w<CR>:!clear && sh -x % > /tmp/vim-bash.out && cat /tmp/vim-bash.out && rm -f /tmp/vim-bash.out<CR>
"
" Json highlight comments
autocmd FileType json syntax match Comment +\/\/.\+$+

" For all text files, set textwidth to 78
autocmd FileType text setlocal textwidth=78

" UTF-8 support
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = "utf-8"
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
endif

" Highlight comments italic 
highlight Comment cterm=italic

if has('syntax') && has('eval')
    packadd! matchit
endif

vmap rot :!tr A-Za-z N-ZA-Mn-za-m<CR>
vnoremap < <gv
vnoremap > >gv
nmap <leader>s :%s//g<Left><Left>
set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm


" vim: set ft=vim :
