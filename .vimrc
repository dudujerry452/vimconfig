syntax on " enable lint 

filetype plugin indent on


"中文编码相关 
set fileformat=unix " unix or DOS, determine line terminators
set fileencoding=utf8
" 自动判断编码时，依次尝试以下编码：
set fileencodings=ucs-bom,utf-8,gb18030,default
" gb18030 最好在 UTF-8 前面，否则其它编码的文件极可能被误识为 UTF-8

set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smarttab
set expandtab

set nowrap
set list
set listchars=eol:.,tab:>-,trail:~,extends:>,precedes:<

set cursorline
set number " line number 
set relativenumber " enable relaive number like 11j not :17
set scrolloff=8 " lines before scroll to bottom
set signcolumn=number " let warnings display on the top of line number 
                      " and other option is "yes"
                      "
                      " to disable relative number temporarily: 
                      " set nornu
                      " set norelativenumber
set showcmd 
set noshowmode " dont show insert mode or something
set conceallevel=1 "how characters are conceealed

set noerrorbells visualbell t_vb= " DON'T RING MORE!!!
set noswapfile " no use it because undodir 
set nobackup
set undodir=~/.vim/undodir " can store undo files through open and close file
set undofile
set clipboard=unnamed

set ignorecase " if no upper case , all cases will be display 
set smartcase " but if there is, only correct case will be display 
set incsearch "display all matches 
set hlsearch " highlight all matches 
nnoremap <CR> :noh<CR><CR>:<backspace> " dont display annoying last matches and clear noh command
" three operation is done when return: 
" :noh (normal mode)
" return noh 
" clear "noh" display

set mouse=a " enable mouse! 

" ctrl + s will save the file
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
vnoremap <C-s> <Esc>:w<CR>gv

nnoremap <leader>q :qall!<CR>
tnoremap <Esc> <C-\><C-n>

so ~/.vim/plugins.vim
so ~/.vim/plugin-config.vim
so ~/.vim/directorylayout.vim
so ~/.vim/toggleterm.vim
so ~/.vim/autoclose.vim

set termguicolors " true color: 2^24 colors
                  " run echo $COLORTERM and test https://github.com/termstandard/colors
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
hi Normal guibg=NONE ctermbg=NONE
let g:terminal_ansi_colors = [
    \ '#282828', '#cc241d', '#98971a', '#d79921',
    \ '#458588', '#b16286', '#689d6a', '#a89984',
    \ '#928374', '#fb4934', '#b8bb26', '#fabd2f',
    \ '#83a598', '#d3869b', '#8ec07c', '#ebdbb2',
\]


