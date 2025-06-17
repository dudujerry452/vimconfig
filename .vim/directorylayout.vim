" " --- Smart file opening for NERDTree ---
" let g:NERDTreeAutoFind = 1 " 自动寻找已打开文件的 NERDTree 节点
" let g:NERDTreeSwitchCWD = 1 " 自动切换当前工作目录

" " 当在 NERDTree 中按 Enter 时，寻找右边的窗口打开，如果没有就新建一个
" autocmd FileType nerdtree nmap <buffer> <CR> :call NERDTreeFindAndOpen()<CR>

" function! NERDTreeFindAndOpen()
"     call feedkeys('s')
"     wincmd l 
"     wincmd l 
"     close 
"     wincmd h
" endfunction



" ============================================================================
" Welcome Screen (Dashboard) Function - FIXED
" ============================================================================
function! s:CreateWelcomeScreen()
    enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal filetype=VimDashboard
    
    " [关键修复] 将内部的单引号 ' 转义为 ''
    call append(0, [
        \ '',
        \ '        __     ___',
        \ '        \ \   / (_)_ __ ___',
        \ '         \ \ / /| | ''__/ __|',
        \ '          \ V / | | |  \__ \',
        \ '           \_/  |_|_|  |___/',
        \ '',
        \ '      Welcome to your custom Vim environment!',
        \ '',
        \ '      Useful Shortcuts:',
        \ '      <Leader>t   - Toggle Terminal',
        \ ''
        \ ])

    1

    setlocal nomodifiable
endfunction

" ============================================================================
" Project Auto Layout (Cmdwin Execution - Anti-Interference Version)
" ============================================================================

" function! SetupProjectLayout()
"     " 防止重复执行
"     if winnr('$') > 1 || (exists('g:project_layout_applied') && g:project_layout_applied)
"         return
"     endif

"     rightbelow vnew
"     " call s:CreateWelcomeScreen()
"     wincmd h
"     vertical resize 15
"     wincmd l
"     call ToggleTerminal()
"     wincmd k

"     let g:project_layout_applied = 1
" endfunction

" augroup ProjectLayoutTrigger
"     autocmd!
"     " 使用 VimEnter，确保在 Vim 完全加载后执行
"     autocmd VimEnter * if argc() > 0 && isdirectory(v:argv[1]) && (!exists('g:project_layout_applied') || !g:project_layout_applied)
"         \ | call SetupProjectLayout()
"         \ | endif
" augroup END
