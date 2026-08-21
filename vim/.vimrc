"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""                                                                 """
"""                                                                 """
"""     In the name of Allah, the most Gracious, the most Merciful. """
"""                                                                 """
"""      ▓▓▓▓▓▓▓▓▓▓                                                 """
"""     ░▓ Author ▓ Abdullah Khabir <https://abdullah.support>      """
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
"
" Plugin-free by design: everything below is native Vim/Neovim, no
" plugin manager, no network fetch required. Drop it on any box you
" SSH into and it works immediately.

" ---------------------------------------------------------------------
" Core
" ---------------------------------------------------------------------
if &compatible
    set nocompatible
endif
filetype plugin indent on
if has('syntax')
    syntax on
    syntax sync minlines=200
endif

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = "utf-8"
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
endif

let mapleader = " "
set hidden
set autoread
set history=10000
set nottimeout

" No backup for encrypted files
set backupskip+=*.gpg,*.age

" ---------------------------------------------------------------------
" Indentation & wrapping
" ---------------------------------------------------------------------
" Spaces by default; Makefiles override this below (make requires
" real tabs for recipe lines, not spaces).
set expandtab
set smarttab copyindent preserveindent
set tabstop=8
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set nocindent
set cinkeys=0{,0},0),:,!,o,O,e
set backspace=indent,eol,start

" textwidth is kept only as a *reference* (drives colorcolumn and the
" manual gq reformat) -- nothing auto hard-wraps while you type, for
" ANY filetype. That's the direct fix for a sentence getting split
" into several physical lines mid-word and then looking broken when
" the file is opened in something other than Vim.
set textwidth=80
set colorcolumn=+1
set formatoptions=rqnjw
" r = continue comment leader after <Enter>
" q = allow `gq` to manually reformat when you actually want a hard wrap
" n = recognise numbered/bulleted lists when formatting
" j = remove comment leader when joining lines
" w = trailing whitespace marks a paragraph as continuing
" (deliberately no 't' or 'c' -- see the filetype_settings augroup
" below for why this needs enforcing again after filetype plugins load)

set wrap
set linebreak
set display+=lastline
set display+=truncate
set display+=uhex
silent! set listchars=eol:¬,tab:→.,extends:»,precedes:«,trail:•
set nolist

" ---------------------------------------------------------------------
" Search
" ---------------------------------------------------------------------
set ignorecase
set smartcase
set wrapscan
set magic
set gdefault
if has('reltime')
    set incsearch
endif
if &t_Co > 2 || has("gui_running")
    set hlsearch
endif

" ---------------------------------------------------------------------
" Spelling (used by markdown/text/gitcommit/mail in filetype_settings)
" ---------------------------------------------------------------------
" `zg` adds the word under the cursor here instead of flagging every
" DevOps term (kubectl, terraform, ansible, ...) as a typo forever.
set spellfile=~/.vim/spell/en.utf-8.add

" ---------------------------------------------------------------------
" UI
" ---------------------------------------------------------------------
set rnu nu
silent! set numberwidth=4
set ruler
set showcmd
set noshowmode
set cmdheight=2
set scrolloff=3
set sidescrolloff=5
set wildmenu
set wildmode=longest:full,full
silent! set wildignorecase
set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm
set whichwrap=b,s,<,>,[,]
set splitbelow splitright
set tabpagemax=20
set noerrorbells visualbell t_vb=
set shortmess+=I
set lazyredraw
set noshowmatch
set mouse=a
if $TERM !~# '^linux\|^Eterm|^screen-*|^tmux-*'
    set t_Co=8
endif
set ttyfast

" Cursor line/column, cursorline only active in the focused window
set cursorline
set cursorcolumn
hi CursorLine guifg=white guibg=#2b3f4a
hi CursorColumn guifg=white guibg=#2b3f4a
hi ColorColumn guifg=#232526 guibg=#F92672
if &t_Co > 16
    au WinEnter * setl cursorline
    au WinLeave * setl nocursorline
    au FocusGained * setl cursorline
    au FocusLost * setl nocursorline
endif
hi CursorLineNr cterm=NONE

" Colorscheme, with a safe fallback if 'nord' isn't present on
" this particular machine (it's not a Vim builtin -- if you always
" drop it in ~/.vim/colors/ manually alongside this file, it'll be
" picked up as before; otherwise this won't error, it'll just fall
" back cleanly).
silent! colorscheme nord
if !exists('g:colors_name') || g:colors_name !=# 'nord'
    colorscheme slate
endif
highlight StatusLine ctermbg=NONE guibg=NONE
highlight Comment cterm=italic

if has("nvim")
    silent! set guicursor=
endif
" (Vim 8.1) with Num Lock off, Num5 is parsed as individual commands
if !has("nvim")
    map! <Esc>OE <Nop>
endif

" ---------------------------------------------------------------------
" Status line (native -- no airline/lightline)
" ---------------------------------------------------------------------
let g:currentmode = {
      \ 'n'  : 'NORMAL ',
      \ 'v'  : 'VISUAL ',
      \ 'V'  : 'V·Line ',
      \ "\<C-v>" : 'V·Block ',
      \ 'i'  : 'INSERT ',
      \ 'R'  : 'R ',
      \ 'Rv' : 'V·Replace ',
      \ 'c'  : 'Command ',
      \}

" Git branch, cached per-buffer so the statusline doesn't spawn a
" `git` process on every redraw -- only on buffer switch/save/refocus.
function! s:UpdateGitBranch()
    if !executable('git')
        let b:git_branch = ''
        return
    endif
    let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    let b:git_branch = substitute(l:branch, '\n', '', '')
endfunction
augroup git_branch_status
    autocmd!
    autocmd BufEnter,BufWritePost,FocusGained * call s:UpdateGitBranch()
augroup END

function! StatusGitBranch()
    if exists('b:git_branch') && b:git_branch !=# ''
        return '  ' . b:git_branch . ' '
    endif
    return ''
endfunction

" Live word count, shown only for prose filetypes so it doesn't
" clutter code files -- this is the actual "word count" ask: a quick,
" always-current sanity check on a paragraph while you write it.
function! StatusWordCount()
    if &filetype =~# '^\%(markdown\|text\|gitcommit\|mail\)$'
        return ' ' . wordcount().words . 'w '
    endif
    return ''
endfunction

set laststatus=2
set statusline=
set statusline+=%#Question#
set statusline+=%f
set statusline+=%#LineNr#
set statusline+=\ %{toupper(g:currentmode[mode()])}
set statusline+=%{&paste?'[paste]':''}
set statusline+=\ %m
set statusline+=%#MoreMsg#
set statusline+=%r
set statusline+=%#Directory#
set statusline+=%{StatusGitBranch()}
"set statusline+=%#StatusLine#
set statusline+=%=
set statusline+=%#Todo#
set statusline+=%{StatusWordCount()}
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
set statusline+=\ %l:%c/%L

" ---------------------------------------------------------------------
" Filetype-specific settings
" ---------------------------------------------------------------------
augroup filetype_settings
    autocmd!

    " Whatever a filetype plugin sets, force auto hard-wrap back off
    " by default for every filetype -- specific, deliberate exceptions
    " (gitcommit) are added back further down. This also finally makes
    " the old "no comment-continue on o/O" intent reliable, since a
    " bare `set` in vimrc runs once at startup, before any filetype
    " plugin has had a chance to re-add these flags per-file.
    autocmd FileType * setlocal formatoptions-=t formatoptions-=c formatoptions-=o

    " Prose: markdown, plain text, git commits, mail
    autocmd FileType markdown,text setlocal textwidth=80 spell spelllang=en
    autocmd FileType gitcommit setlocal spell spelllang=en
    autocmd FileType mail setlocal spell spelllang=en
    autocmd BufNewFile,BufRead *Pkgfile set filetype=sh

    " Git commit bodies are the one deliberate exception to "never
    " auto hard-wrap": every git tool expects a 72-char-wrapped body,
    " so hard-wrapping here is the convention, not a bug, and won't
    " look broken anywhere else. Delete this line if you'd rather it
    " behave exactly like everything else.
    autocmd FileType gitcommit setlocal textwidth=72 formatoptions+=t

    " Shell scripts
    autocmd FileType sh let g:is_bash = 1
    autocmd FileType sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType sh setlocal makeprg=shellcheck\ -f\ gcc\ %
    autocmd FileType sh setlocal errorformat=%f:%l:%c:\ %trror:\ %m,%f:%l:%c:\ %tarning:\ %m,%f:%l:%c:\ %tote:\ %m

    " YAML (Ansible, Kubernetes, CI configs, docker-compose)
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType yaml setlocal indentkeys-=0# indentkeys-=<:>
    autocmd FileType yaml setlocal makeprg=yamllint\ -f\ parsable\ %
    " YAML forbids literal tabs for indentation -- flag them loudly
    " rather than let a stray tab silently break a playbook/manifest.
    autocmd FileType yaml match ErrorMsg /\t/

    " Terraform / HCL
    autocmd BufNewFile,BufRead *.tf,*.tfvars,*.tfstate setlocal filetype=terraform
    autocmd FileType terraform setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType terraform setlocal commentstring=#\ %s

    " Dockerfiles
    autocmd BufNewFile,BufRead Dockerfile,Dockerfile.*,*.dockerfile setlocal filetype=dockerfile
    autocmd FileType dockerfile setlocal commentstring=#\ %s

    " Makefiles -- these REQUIRE literal tabs for recipe lines, so this
    " has to override the global expandtab or `make` breaks with
    " "missing separator".
    autocmd BufNewFile,BufRead *.mk setlocal filetype=make
    autocmd FileType make setlocal noexpandtab

    " Python -- ruff is assumed since it's the fast, modern default;
    " if you're on flake8/pylint instead, swap the command below (same
    " %f:%l:%c: %m-ish shape, so the default errorformat still applies).
    autocmd FileType python setlocal breakindentopt=shift:4
    autocmd FileType python setlocal makeprg=ruff\ check\ %

    " JSON with // comments (JSONC-style files)
    autocmd FileType json syntax match Comment +\/\/.\+$+

    " SSH-related config files
    autocmd BufNewFile,BufRead authorized_keys*,known_hosts,id_*.pub
          \ setlocal filetype=conf wrap nolinebreak
    autocmd BufNewFile,BufRead /etc/motd setlocal expandtab

    " Don't let modelines run in things you didn't author yourself
    autocmd BufNewFile,BufRead COMMIT_EDITMSG,git-rebase-todo setlocal nomodeline

    " Markdown preview in Chrome, scoped to markdown buffers only
    " (the old version used a global noremap re-applied on every
    " BufEnter, so F5 would still try to open Chrome even after you
    " switched to an unrelated buffer -- <buffer> fixes that).
    autocmd FileType markdown nnoremap <buffer> <F5> :!google-chrome-stable %:p<CR>
    "autocmd! bufwritepost *.md !pandoc -o /tmp/index.html --template $HOME/.local/share/pandoc/template.html -s -f markdown -t html -V mainfont="Chakra Petch" -V fontsize=25px --metadata-file $HOME/.local/share/pandoc/metadata.yaml --toc %:p

    if has("nvim")
        " Neovim 0.2.1+: terminal buffers now have line numbers
        autocmd TermOpen * setlocal nonumber norelativenumber
    endif
augroup END

" Strip trailing whitespace on save for code plus the DevOps filetypes
" above. Only trims *trailing* whitespace, so it's safe for Makefiles'
" leading recipe tabs.
augroup strip_trailing_whitespace
    autocmd!
    autocmd BufWritePre *.c,*.cpp,*.cc,*.h,*.sh,*.hpp,*.py,*.m,*.mm,
          \*.yml,*.yaml,*.tf,*.tfvars,Dockerfile,*.dockerfile,Makefile,*.mk
          \ :%s/\s\+$//e
augroup END

" ---------------------------------------------------------------------
" New-file templates -- only fires on genuinely new files (BufNewFile),
" never on anything that already exists, and drops the cursor where
" you'd actually start typing.
" ---------------------------------------------------------------------
function! s:NewFileTemplate(lines)
    call setline(1, a:lines)
    normal! G$
    startinsert!
endfunction

augroup file_templates
    autocmd!
    autocmd BufNewFile *.sh call s:NewFileTemplate(['#!/usr/bin/env bash', '', 'set -euo pipefail', ''])
    autocmd BufNewFile *.py call s:NewFileTemplate(['#!/usr/bin/env python3', ''])
    autocmd BufNewFile Dockerfile,Dockerfile.*,*.dockerfile call s:NewFileTemplate(['# syntax=docker/dockerfile:1', 'FROM '])
    autocmd BufNewFile Makefile call s:NewFileTemplate(['.PHONY: all', '', 'all:', "\t"])
    autocmd BufNewFile *.yml,*.yaml call s:NewFileTemplate(['---', ''])
    autocmd BufNewFile *.md call s:NewFileTemplate(['# '])
augroup END

" ---------------------------------------------------------------------
" Folding
" ---------------------------------------------------------------------
set foldlevel=4
set foldmethod=marker
set foldmarker=<<<,>>>
set nofoldenable

" ---------------------------------------------------------------------
" Sessions
" ---------------------------------------------------------------------
set sessionoptions-=help
set sessionoptions-=curdir

" ---------------------------------------------------------------------
" Backup / swap / undo
" ---------------------------------------------------------------------
set nobackup
set modeline
set viminfo='10,\"100,:20,%,n~/.viminfo

if has("unix")
    if has("nvim")
        set undofile
    else
        if !isdirectory(expand('~/.vim/undodir'))
            call mkdir(expand('~/.vim/undodir'), 'p')
        endif
        silent! set undodir=~/.vim/undodir//
        silent! set undofile
    endif
endif

augroup no_swap_for_secrets
    autocmd!
    autocmd BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
    autocmd BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile
augroup END

augroup restore_cursor_position
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
          \ | exe "normal! g`\""
          \ | endif
augroup END

" ---------------------------------------------------------------------
" Completion / diff / misc editing
" ---------------------------------------------------------------------
set completeopt=menuone
set nrformats=bin,hex,unsigned
set clipboard=unnamed,unnamedplus
set updatetime=300

if &diff
    highlight! link DiffText MatchParen
endif

if has('syntax') && has('eval')
    packadd! matchit
endif

" ---------------------------------------------------------------------
" Functions & commands
" ---------------------------------------------------------------------
function! SaveIfUnsaved()
    if &modified
        :silent! w
    endif
endfunction
" au FocusLost,BufLeave * :call SaveIfUnsaved()

function! ToggleNumber()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
command! ToggleNumber call ToggleNumber()

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
endfunction
command! -range=% DeleteFunctionUnderCursor <line1>,<line2>call DeleteFunctionUnderCursor()

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

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" A .yml file can't be reliably told apart from a K8s manifest or a
" docker-compose file, so this is a deliberate manual switch rather
" than an autocmd guess: run this in a buffer you know is a playbook,
" then :make / <leader>k lints it with ansible-lint instead of yamllint.
command! AnsibleLintMode setlocal makeprg=ansible-lint\ % errorformat=%f:%l:\ %m

" Quick reference for everything above -- <leader>? or :Cheatsheet
function! s:ShowCheatSheet()
    let l:lines = [
          \ 'leader = <Space>', '',
          \ '  c    comment out current line',
          \ '  n    file explorer (netrw)',
          \ '  u    open URL under cursor',
          \ '  l    list buffers / switch',
          \ '  b    delete (close) buffer',
          \ '  h    clear search highlight',
          \ '  t    open terminal',
          \ '  rw   search/replace word under cursor',
          \ '  S    sort CSS-like properties in a block',
          \ '  v    reselect last-pasted text',
          \ '  w    rewrap current paragraph (gq)',
          \ '  W    strip trailing whitespace',
          \ '  s    substitute template (%s//)',
          \ '  m    run current Python file',
          \ '  o    run current shell script',
          \ '  k    lint current file, open quickfix',
          \ '  "    wrap WORD under cursor in quotes',
          \ '  ?    this cheat sheet', '',
          \ 'not on leader:', '',
          \ '  w!!          write file as root (doas)',
          \ '  :DiffOrig    diff buffer against saved file',
          \ '  :AnsibleLintMode   switch this buffer to ansible-lint',
          \ '', 'q to close',
          \ ]
    new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile filetype=
    call setline(1, l:lines)
    setlocal nomodifiable readonly
    nnoremap <buffer> q :q<CR>
    resize 20
endfunction
command! Cheatsheet call s:ShowCheatSheet()

" w!! to write file as root
cmap w!! %!doas tee > /dev/null %
com! -complete=file -bang -nargs=? W :w<bang> <args>

" mmm abbreviated as my mail address
iabbrev mmm abdullah@abdullah.support

let g:python3_host_prog = "/usr/bin/python3"

" Native file explorer (<leader>n / :Lexplore) -- no banner, tree
" style, fixed-width sidebar instead of taking over the whole window.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" ---------------------------------------------------------------------
" Mappings
" ---------------------------------------------------------------------
nnoremap ; :
nnoremap K <nop>
nnoremap qq :q!<CR>
nnoremap Q q
inoremap # #

" comfortable navigation (wrapped lines move visually, not logically)
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

vnoremap < <gv
vnoremap > >gv

" comment out current line
map <leader>c 0i# <ESC>
" native file explorer (used to be a coc.nvim mapping)
nnoremap <leader>n :Lexplore<CR>
nnoremap <leader>u :w \| startinsert \| term urlview %<CR>
nnoremap <leader>l :ls<CR>:b<Space>
nnoremap <leader>b :bd<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>rw :%s/\<<C-r><C-w>\>/
" sort CSS properties
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
" reselect pasted text
nnoremap <leader>v `[V`]
" rewrap current paragraph on demand (auto-wrap is off by default now)
nnoremap <leader>w gq}
" strip trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=""<CR>
nnoremap <leader>s :%s//g<Left><Left>

" Run python code without exiting vim
nnoremap <silent> <leader>m :w<CR>:!clear && python % > /tmp/vim-py.out && cat /tmp/vim-py.out && rm -f /tmp/vim-py.out<CR>
" Run bash code without exiting vim
nnoremap <silent> <leader>o :w<CR>:!clear && sh -x % > /tmp/vim-bash.out && cat /tmp/vim-bash.out && rm -f /tmp/vim-bash.out<CR>
" Lint the current file (shellcheck for .sh, yamllint for .yml/.yaml,
" ruff for .py, via makeprg above) and open the results in quickfix
nnoremap <silent> <leader>k :w<CR>:make<CR>:copen<CR>
" Quick reference for every leader mapping in this file
nnoremap <silent> <leader>? :Cheatsheet<CR>

vmap rot :!tr A-Za-z N-ZA-Mn-za-m<CR>

" ---------------------------------------------------------------------
" Environment-reload hooks (personal desktop)
" ---------------------------------------------------------------------

augroup env_reload
    autocmd!
    autocmd bufwritepost $HOME/.Xresources !xrdb -load $HOME/.Xresources 
    autocmd bufwritepost $HOME/.zshrc      !source $HOME/.zshrc
    autocmd bufwritepost $HOME/.config/sxhkd/sxhkdrc       !pkill -USR1 -x sxhkd
    autocmd bufwritepost $HOME/cfg/sxhkd/.config/sxhkd/sxhkdrc     !pkill -USR1 -x sxhkd
    autocmd bufwritepost $HOME/cfg/zsh/.zsh/custom-alias !source $HOME/cfg/zsh/.zsh/custom-alias
    autocmd bufwritepost $HOME/.vimrc source $MYVIMRC
    autocmd bufwritepost $HOME/cfg/polybar/.config/polybar/*.{conf,ini} !bspc wm -r >/dev/null 2>&1
    autocmd bufwritepost $HOME/cfg/bspwm/.config/bspwm/bspwmrc !bspc wm -r >/dev/null 2>&1
    autocmd bufwritepost $HOME/cfg/etc/.local/bin/mypanel !pkill mypanel && $HOME/.local/bin/mypanel & disown
    autocmd bufwritepost $HOME/cfg/sway/.config/sway/config !swaymsg reload
    autocmd bufwritepost $HOME/cfg/herbstluftwm/.config/herbstluftwm/autostart !herbstclient reload
augroup END

augroup misc_autocmds
    autocmd!
    autocmd FocusGained,BufEnter * :silent! !
augroup END

" ---------------------------------------------------------------------
" Pastebins (personal -- untouched)
" ---------------------------------------------------------------------
command! -range=% CL <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | xclip -i -selection clipboard
command! -range=% VP <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | xclip -i -selection clipboard
command! -range=% PB <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/ | sed -n 's/^url: //p' | xclip
command! -range=% TB <line1>,<line2>w !fb
command! -range=% GT <line1>,<line2>w !gist -c -p -f %

map <F3> :! ( urxvt & ) &>/dev/null &<CR><CR>

" Wrap current WORD (includes $) in double quotes with <Leader>"
nnoremap <Leader>" viWc"<C-r>""<Esc>

" vim: set ft=vim :
