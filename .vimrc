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
set belloff=esc " press esc in normal mode the screen will flick. so disable it
set noswapfile " no use it because undodir
set nobackup
set undodir=~/.vim/undodir " can store undo files through open and close file
set undofile
set clipboard=unnamed

" Command and search history
set history=10000 " remember more commands and search history
set viminfo='100,<50,s10,h " save viminfo with marks, registers, etc.

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

" Reduce timeout for key mapping sequences (fixes delay after typing '(')
set timeoutlen=1000  " Wait 1000ms (default) for next key

" ctrl + s will save the file and return to normal mode
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>

" ctrl + a will quit all without saving
nnoremap <C-a> :qa!<CR>
inoremap <C-a> <Esc>:qa!<CR>
vnoremap <C-a> <Esc>:qa!<CR>

nnoremap <Leader>ya ggVG"+y

nnoremap <leader>q :qall!<CR>
tnoremap <Esc> <C-\><C-n>

" Quick window navigation with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tab (buffer tab) navigation
nnoremap <S-Tab> :tabnext<CR>
nnoremap <S-p> :tabnew<Space>
" Leader + number for tab switching
nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt

" Terminal mode window navigation
" Use <Cmd> to execute command without leaving terminal mode first
tnoremap <C-h> <Cmd>wincmd h<CR><Cmd>call <SID>EnterTerminalIfNeeded()<CR>
tnoremap <C-j> <Cmd>wincmd j<CR><Cmd>call <SID>EnterTerminalIfNeeded()<CR>
tnoremap <C-k> <Cmd>wincmd k<CR><Cmd>call <SID>EnterTerminalIfNeeded()<CR>
tnoremap <C-l> <Cmd>wincmd l<CR><Cmd>call <SID>EnterTerminalIfNeeded()<CR>

" Helper function to enter terminal mode if we're in a terminal buffer
function! s:EnterTerminalIfNeeded()
    if &buftype == 'terminal'
        startinsert
    endif
endfunction

so ~/.vim/plugins.vim
so ~/.vim/plugin-config.vim
so ~/.vim/directorylayout.vim
" so ~/.vim/toggleterm.vim  " Replaced by vim-terminal plugin
so ~/.vim/autoclose.vim

" ============================================================================
" vim-terminal plugin configuration
" ============================================================================
" The plugin is located at ~/.vim/plugged/vim-terminal/
" It will be automatically loaded by Vim's runtimepath

" Optional: Override default settings
" let g:runner_command_terminal_height = 12
" let g:runner_user_terminal_height = 6
" let g:runner_auto_cd_project_root = 1
" let g:runner_clear_before_execute = 1
" let g:runner_project_root_markers = ['.git', 'Cargo.toml', 'stack.yaml', '.vsettings.json']

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


