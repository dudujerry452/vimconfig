call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox' " color theme
Plug 'scrooloose/nerdtree' " file explorer
Plug 'vim-airline/vim-airline' " bottom state line

Plug 'sheerun/vim-polyglot' " language lint
Plug 'tpope/vim-commentary' " gc to comment lines
Plug 'tpope/vim-surround' " ysw to surround words

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Local plugin: vim-terminal
Plug '~/.vim/plugged/vim-terminal'

call plug#end() 

"PlugInstall
"PlugUpdate
"PlugStatus
"PlugClean
"PlugUpgrade
"
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
