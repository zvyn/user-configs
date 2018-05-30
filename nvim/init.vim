" Use virtualenv internally since Ubuntu has no siutable packages
let g:python_host_prog = "/home/milan/.config/nvim/env2/bin/python"
let g:python3_host_prog = "/home/milan/.config/nvim/env/bin/python3"

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

set title
set mouse=a
set number  " Show absolute number in current line
set relativenumber  " Show relative number for the rest
set colorcolumn=80  " Highlight column 80
set hidden  " Remember history and allow siwching from unsaved buffers
set clipboard=unnamed  " Use middle mouse button to paste into X
set undofile  " Never forget!
let g:undofile_warn_mode=2  " Ask for confirmation when going back to undofile

" Magic!
autocmd VimResized * wincmd =  " Split window evenly on every resize
augroup numbertoggle  " Use absolute numbers without focus
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Plugins
call plug#begin()
 Plug 'jlanzarotta/bufexplorer'  " Switch buffers with confidence
 Plug 'ervandew/supertab'  " Non-buggy Tab for completion
 Plug 'Carpetsmoker/undofile_warn.vim'  " warn when using undofile
 Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " Auto-complete
 Plug 'zchee/deoplete-jedi', { 'do': ':UpdateRemotePlugins' }  " Use Python AST
 Plug 'scrooloose/nerdtree'  " File-browser
 Plug 'Xuyuanp/nerdtree-git-plugin'  " Show git status in NERDTree
 Plug 'w0rp/ale'  " Generic linter integration
 Plug 'rakr/vim-one'  " Atom One color scheme
 Plug 'vim-airline/vim-airline'  " The status-bar at the bottom
 Plug 'plytophogy/vim-virtualenv'  " Show virtualenv in airline
 Plug 'airblade/vim-gitgutter'  " Flag changes since last commit
 Plug 'tpope/vim-fugitive'  " Show branch in airline (sorry)
 Plug 'tpope/vim-obsession'  " Session managment helper
call plug#end()

let g:ale_linters = {'python': ['flake8', 'mypy']}
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
" Tab and Shift-Tab in normal mode to navigate buffers
nmap <S-Tab> <Plug>AirlineSelectPrevTab
nmap <Tab> <Plug>AirlineSelectNextTab

let g:airline_skip_empty_sections = 1

" NERDTree key-bindings
map <C-Bslash> :NERDTreeToggle<CR>
map <C-N> :NERDTreeFind<CR>

" Remove search highliting
noremap <silent> <Space> :nohlsearch<Return>

" Atom key-binding
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

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
