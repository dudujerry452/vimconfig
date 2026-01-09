" ============================================================================
" Toggle Terminal (Named, Hide/Show Version - Optimized)
" ============================================================================

function! s:ToggleTerminal()
    " Find terminal buffer with our special marker
    let term_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'toggle_terminal_id', 0) == 1
            let term_buf_nr = buf.bufnr
            break
        endif
    endfor

    " If our terminal buffer exists...
    if term_buf_nr != -1
        let term_win_id = bufwinid(term_buf_nr)

        if term_win_id != -1
            " Terminal is visible, hide it
            call win_execute(term_win_id, 'hide')
        else
            " Terminal is hidden, show it
            belowright 5split
            execute "buffer " . term_buf_nr
            startinsert
        endif
    else
        " Terminal doesn't exist, create a new one
        belowright terminal
        resize 5
        let b:toggle_terminal_id = 1
        startinsert
    endif
endfunction

" Toggle terminal with Ctrl+Z
nnoremap <silent> <C-z> :call <SID>ToggleTerminal()<CR>
" Use <Cmd> to avoid mode change side effects
tnoremap <silent> <C-z> <Cmd>call <SID>ToggleTerminal()<CR>
