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

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
" colorschemes
Plugin 'sjl/badwolf'
Plugin 'morhetz/gruvbox'
Plugin 'whatyouhide/vim-gotham'
Plugin 'dracula/vim'
Plugin 'tyrannicaltoucan/vim-deep-space' 
Plugin 'altercation/vim-colors-solarized'
Plugin 'cocopon/iceberg.vim'
call vundle#end()    
filetype plugin indent on " load filetype-specific files

map <F1> :set nonumber!<CR>
map <F2> :AirlineToggle<CR>
map <F3> :NERDTreeToggle<CR>

augroup configgroup
    autocmd!
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
augroup END 

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

try
  colorscheme gotham
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

let g:airline_theme='gotham'