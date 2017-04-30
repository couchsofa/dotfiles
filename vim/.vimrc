call pathogen#infect()

syntax enable
set background=dark
colorscheme solarized

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"quick fix to tell flake not to use python3 linter
let g:syntastic_python_python_exec = '/usr/bin/python2'

set tabstop=4
set shiftwidth=4
set softtabstop=4

set number
