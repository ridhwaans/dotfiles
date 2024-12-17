syntax enable

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set cursorline      " highlight current line
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set lazyredraw      " redraw only when we need to.
set showmatch       " highlight matching [{()}]
set number          " show line numbers
set laststatus=2    " display status line

" vim-plug
let g:vim_plug_home = '/usr/local/share/vim/bundle'

execute 'source ' . g:vim_plug_home . '/autoload/plug.vim'

call plug#begin(g:vim_plug_home . '/plugged')

Plug 'whatyouhide/vim-gotham'

call plug#end()

map <F1> :set nonumber!<CR>
map <F2> :NERDTreeToggle<CR>
map <F3> :AirlineToggle<CR>

" jump half-page up/down and cursor middle
+nnoremap <C-d> <C-d>zz
+nnoremap <C-u> <C-u>zz

try
  colorscheme gotham256
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

let g:airline_theme='gotham256'
