" Color scheme
colo desert
syntax on

" Number lines
set number
set numberwidth=3
highlight LineNr ctermfg=gray

" Avoid numbers in copying lines by typing F12
nmap <F12> :set invnumber<CR>

" Cursor line
set cursorline
hi cursorline cterm=bold term=bold guibg=white
highlight LineNr ctermfg=red
