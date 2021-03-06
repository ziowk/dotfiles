set nocompatible
filetype off

" vim-plug is now used for plugin installation.
"
" Install vim-plug:
" $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Plugins are stored in .vim/plugged/
"
" do :PlugUpdate to install/update plugins
"
" do :PlugUpgrade to update vim-plug itself
"
" fzf is now updated by vim-plug, located in ~/.fzf

call plug#begin()

"key: \\{motion}
Plug 'Lokaltog/vim-easymotion'

"key: {c=sub,d=del,y=add}s{object}{brace} example: ysaw( - add () around a word
"example: yss" - add " around line
Plug 'tpope/vim-surround'

"key: <F5> for undo tree
Plug 'simnalamburt/vim-mundo'

"color schemes
Plug 'flazz/vim-colorschemes'

" fuzzy finder (plugin outside ~/.vim/plugged with post-update hook)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" extra commands for fzf
Plug 'junegunn/fzf.vim'

" better highlighting for cpp/cc
Plug 'octol/vim-cpp-enhanced-highlight'

" some extra commands like :SudoWrite
Plug 'tpope/vim-eunuch'

" highlight and fix whitespace errors
Plug 'ntpeters/vim-better-whitespace'

" switching between header and code
Plug 'derekwyatt/vim-fswitch'

" vim focus events in tmux
Plug 'tmux-plugins/vim-tmux-focus-events'

" show changes sign columns
Plug 'airblade/vim-gitgutter'

" airline statusbar replacement
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" show indent lines
Plug 'Yggdroot/indentLine'

"unused:
"Plugin 'Lokaltog/powerline.git',{'rtp':'powerline/bindings/vim'}
"Plugin 'jeffkreeftmeijer/vim-numbertoggle.git'

call plug#end()

" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo

" To use airline:
" 1. install https://github.com/powerline/fonts (correct Literation ->
" Liberation everywhere!)
" 2. rebuild st to use 'Liberation Mono for Powerline'
" 3. (maybe) rebuild font cache - fc-cache -vf ~/.fonts ~/.local/share/fonts
" 4. restart st and vim

" air-line
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set noshowmode

nnoremap <F5> :MundoToggle<CR>
nnoremap <F6> :FSHere<CR>
nnoremap <F7> :b#<CR>
nnoremap <F8> :Buff<CR>
nnoremap <F9> :Files<CR>
nnoremap <F10> :syntax sync fromstart<CR>

" blinking cursor
set guicursor=a:block-blinkon0,n-v:block,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,r-cr-c:hor20-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175

" 24bit color
set termguicolors

filetype plugin indent on

colorscheme wombat256

set laststatus=2

set encoding=utf-8
let $LANG = 'en'
set langmenu=en_gb.utf-8

set incsearch
set ignorecase
set smartcase
set hlsearch
set showmatch

set expandtab
set shiftwidth=2
set tabstop=2
set smarttab

set ai "Auto indent
set si "Smart indet

set wrap "Wrap lines
set linebreak "will wrap lines at a character in 'breakat' rather than last character that fits on the screen

set backspace=indent,eol,start
set relativenumber
set number "line numbers
syntax on
set ruler "position in file

set clipboard=unnamedplus "integrate unnamed register with system clipboard

set showcmd
set noautoread "automatically reread after outisde change
set noautowrite "no automatic writing when switching files
set noautowriteall "like above, but other commands
set hidden "allow modified buffers to be hidden
set scrolloff=5
set wildmenu
set wildmode=list:longest,full
set ssop-=options
set foldmethod=indent
set foldlevel=99

set spell
set spelllang=en

set colorcolumn=80
set cursorline
set cursorcolumn

au FocusGained,BufEnter * checktime
" au CursorHold,CursorHoldI * checktime

set directory=.,$TEMP

inoremap jj <esc>
inoremap <esc> <Nop>
nnoremap Y y$

nnoremap <SPACE> <Nop>
let mapleader="\<Space>"
