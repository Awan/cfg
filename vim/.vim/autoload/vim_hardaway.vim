" vim: fdm=marker
"
" Name:         Vim Hardaway (Airline theme)
" Author:       Evan Turner <ev@evturn.com>
" Maintainer:   Evan Turner <ev@evturn.com>
" Repository:   https://github.com/evturn/vim-hardaway
" Description:  This color palette was based on a novel "Push" by Sapphire.
" License:      MIT
" Last Updated: Nov 2018
" Note:         Very cool.

" Color variables {{{

" cterm
let s:T000 = 0         " black
let s:T011 = 11        " yellow
let s:T014 = 14        " aqua
let s:T015 = 15        " white
let s:T049 = 49        " mediumspringgreen
let s:T081 = 81        " steelblue1
let s:T145 = 145       " grey69
let s:T190 = 190       " yellow2
let s:T196 = 196       " red1
let s:T198 = 198       " deeppink1
let s:T202 = 202       " orangered1
let s:T233 = 233       " grey7
let s:T235 = 235       " grey15
let s:T236 = 236       " grey19
let s:T234 = 234       " grey11 
let s:T237 = 237       " grey23 
let s:T240 = 240       " grey35

" gui
let s:G011 = "#ffff00" " yellow
let s:G014 = "#00ffff" " aqua
let s:G015 = "#ffffff" " white
let s:G049 = "#00ffaf" " mediumspringgreen
let s:G081 = "#5fd7ff" " steelblue1
let s:G190 = "#d7ff00" " yellow2
let s:G196 = "#ff0000" " red1
let s:G198 = "#ff0087" " deeppink1
let s:G202 = "#ff5f00" " orangered1
let s:G233 = "#121212" " grey7
let s:G234 = "#1C1C1C" " grey11
let s:G235 = "#262626" " grey15
let s:G236 = "#303030" " grey19
let s:G237 = "#3A3A3A" " grey23
let s:G240 = "#585858" " grey35

" custom
let s:G300 = "#101010" " black
let s:G301 = "#abb2bf" " white
let s:G302 = "#ffee00" " yellow
let s:G303 = "#1a1a1a" " grey
let s:G304 = "#282c34" " grey

" }}}

" Color maps {{{

" Normal mode
let s:N1 = [ s:G300, s:G049, s:T235, s:T049 ]
let s:N2 = [ s:G301, s:G303, s:T015, s:T236 ]
let s:N3 = [ s:G049, s:G304, s:T049, '' ]

" Insert mode
let s:I1 = [ s:G300, s:G302, s:T235, s:T011 ]
let s:I2 = s:N2
let s:I3 = s:N3

" Replace mode
let s:R1 = [ s:G300, s:G198, s:T000, s:T198 ]
let s:R2 = s:N2
let s:R3 = s:N3

" Visual mode
let s:V1 = [ s:G300, s:G081, s:T235, s:T081 ]
let s:V2 = s:N2
let s:V3 = s:N3

" Inactive mode
let s:IA1 = [ s:G240, s:G233, s:T240, s:T233 ]
let s:IA2 = s:IA1
let s:IA3 = s:IA1

" }}}

" Color palette {{{

let g:airline#themes#vim_hardaway#palette = {}
let g:airline#themes#vim_hardaway#palette.normal   = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#vim_hardaway#palette.insert   = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#vim_hardaway#palette.replace  = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#vim_hardaway#palette.visual   = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#vim_hardaway#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

let group = airline#themes#get_highlight('vimCommand')
let g:airline#themes#vim_hardaway#palette.normal_modified   = { 'airline_c': [ group[0], '', group[2], '', '' ] }
let g:airline#themes#vim_hardaway#palette.insert_modified   = g:airline#themes#vim_hardaway#palette.normal_modified
let g:airline#themes#vim_hardaway#palette.replace_modified  = g:airline#themes#vim_hardaway#palette.normal_modified
let g:airline#themes#vim_hardaway#palette.visual_modified   = g:airline#themes#vim_hardaway#palette.normal_modified
let g:airline#themes#vim_hardaway#palette.inactive_modified = { 'airline_c': [ group[0], '', group[2], '', '' ] }

" Warning
let s:WI                                                           = [ s:G233, s:G302, s:T233, s:T190 ]
let g:airline#themes#vim_hardaway#palette.normal.airline_warning           = [ s:WI[0], s:WI[1], s:WI[2], s:WI[3] ]
let g:airline#themes#vim_hardaway#palette.normal_modified.airline_warning  = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.insert.airline_warning           = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.insert_modified.airline_warning  = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.visual.airline_warning           = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.visual_modified.airline_warning  = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.replace.airline_warning          = g:airline#themes#vim_hardaway#palette.normal.airline_warning
let g:airline#themes#vim_hardaway#palette.replace_modified.airline_warning = g:airline#themes#vim_hardaway#palette.normal.airline_warning

" Error
let s:ER                                                         = [ s:G190, s:G196, s:T190, s:T196 ]
let g:airline#themes#vim_hardaway#palette.normal.airline_error           = [ s:ER[0], s:ER[1], s:ER[2], s:ER[3] ]
let g:airline#themes#vim_hardaway#palette.normal_modified.airline_error  = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.insert.airline_error           = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.insert_modified.airline_error  = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.visual.airline_error           = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.visual_modified.airline_error  = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.replace.airline_error          = g:airline#themes#vim_hardaway#palette.normal.airline_error
let g:airline#themes#vim_hardaway#palette.replace_modified.airline_error = g:airline#themes#vim_hardaway#palette.normal.airline_error

" Terminal
let s:TE                                               = [ s:G234 , s:G237 , s:T234 , s:T237 , '' ]
let g:airline#themes#vim_hardaway#palette.normal.airline_term  = [ s:TE[0], s:TE[1], s:TE[2], s:TE[3] ]
let g:airline#themes#vim_hardaway#palette.insert.airline_term  = g:airline#themes#vim_hardaway#palette.normal.airline_term
let g:airline#themes#vim_hardaway#palette.visual.airline_term  = g:airline#themes#vim_hardaway#palette.normal.airline_term
let g:airline#themes#vim_hardaway#palette.replace.airline_term = g:airline#themes#vim_hardaway#palette.normal.airline_term

let g:airline#themes#vim_hardaway#palette.accents = { 'red': [ s:G196, '', s:T196, 0 ] }

" }}}
