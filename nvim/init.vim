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

" Use tab to circle through auto-complete popup
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

set mouse=a
set number
set title

" Plugins
call plug#begin()
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

let g:ale_python_pylint_options = '-d R,C,fixme,broad-except'

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
