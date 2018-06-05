" Use system Python internally  (with python[2]-neovim from community)
let g:python_host_prog = "/home/milan/.config/nvim//env2/bin/python"
let g:python3_host_prog = "/home/milan/.config/nvim//env/bin/python"

" Tabs and indentiation:
filetype indent on
if has("autocmd")
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

let mapleader=","
set mouse=a
set number
set hidden  " Remember history and allow siwching from unsaved buffers
set clipboard=unnamed  " Use middle mouse button to paste into X
set undofile  " Never forget!
let g:undofile_warn_mode=2  " Ask for confirmation when going back to undofile

" Plugins
call plug#begin()
 Plug 'jlanzarotta/bufexplorer' 
 Plug 'ervandew/supertab'
 Plug 'Carpetsmoker/undofile_warn.vim'  " warn when using undofile
 Plug 'scrooloose/nerdtree'  " File-browser
 Plug 'Xuyuanp/nerdtree-git-plugin'  " Show git status in NERDTree
 Plug 'Chiel92/vim-autoformat'  " Generic beutifier
 Plug 'w0rp/ale'  " Generic linter integration
 Plug 'rakr/vim-one'  " Atom One color scheme
 Plug 'vim-airline/vim-airline'  " The status-bar at the bottom
 Plug 'plytophogy/vim-virtualenv'  " Show virtualenv in airline
 Plug 'airblade/vim-gitgutter'  " Flag changes since last commit
 Plug 'tpope/vim-fugitive'  " Show branch in airline (sorry)
 if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-jedi'  " Use Python AST
 end
call plug#end()

" NERDTree key-bindings
map <C-Bslash> :NERDTreeToggle<CR>
map <C-N> :NERDTreeFind<CR>

" Colorscheme
if (empty($TMUX))
  if (has("termguicolors"))
    set termguicolors
  endif
endif
set background=dark
colorscheme one

" Airline config
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='one'

" Turn on auto-completion on startup
let g:deoplete#enable_at_startup = 1

" Jump to the last position when reopening a file:
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

:set guicursor=
" Workaround some broken plugins which set guicursor indiscriminately.
:autocmd OptionSet guicursor noautocmd set guicursor=
