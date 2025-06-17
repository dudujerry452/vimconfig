" ============================================================================
" Toggle Terminal (Named, Hide/Show Version - The Definitive)
" ============================================================================

function! ToggleTerminal()
    " 1. [关键修复] 寻找带有我们特殊标记的终端缓冲区
    let term_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        " getbufvar() 可以安全地获取另一个缓冲区的变量值
        if getbufvar(buf.bufnr, 'toggle_terminal_id', 0) == 1
            let term_buf_nr = buf.bufnr
            break
        endif
    endfor

    " 2. 如果我们命名的终端缓冲区存在...
    if term_buf_nr != -1

        " 检查它是否在某个窗口中可见
        let term_win_id = bufwinid(term_buf_nr)

        if term_win_id != -1
            " 它可见，所以隐藏它
            call win_execute(term_win_id, 'hide')
        else
            " 它被隐藏了，所以重新显示它
            belowright 5split " 先创建一个5行高的空窗口
            execute "buffer " . term_buf_nr 
            startinsert
        endif
    else
        " 3. 如果我们命名的终端完全不存在，就创建一个全新的
        belowright terminal 
        resize 5
        let b:toggle_terminal_id = 1 " 设置“身份证”
        startinsert
        
        startinsert
    endif
endfunction

" 映射保持不变
nnoremap <silent> <Leader>t :call ToggleTerminal()<CR>
