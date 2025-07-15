
" nerd tree
nnoremap <C-t> :NERDTreeToggle \| vertical resize 15<CR>
" normal mode: non-recurisve mapping, <CR> always <CR>
" Press Ctrl+T will show and hidden nerdtree. 
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
" show hidden files defaultly
let NERDTreeRespectWildIgnore=1
" respect wildnore 
set wildignore+=*.DS_Store,*.min.*
" dont show these files
autocmd BufWinEnter * silent NERDTreeMirror
" hl the openned file and silent the command


" pyglot

let g:javascript_conceal_function="ƒ" " display signs instead of key words

" =======================================================
" CoC (Conquer of Completion) - Key Mappings
" (This version does NOT require Lua support)
" =======================================================

" 1. 先定义所有需要被映射引用的函数 (纯 VimL 版本)
" -------------------------------------------------------

" 这个函数检查光标前是否是空白字符，用于智能 Tab
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" 2. 然后定义所有按键映射
" -------------------------------------------------------

" 让 <Enter> 键在补全菜单弹出时行为更友好
" 注意：这里我们使用 coc#pum#confirm() 来代替旧的 coc#_select_confirm()
inoremap <expr> <CR> pumvisible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 使用 Tab 和 Shift-Tab 来选择补全项
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" =======================================================
" CoC Mappings - End
" =======================================================
