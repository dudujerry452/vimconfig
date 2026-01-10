" ============================================================================
" Terminal Window Management
" ============================================================================

" Global terminal buffer numbers
let s:user_terminal_buf = -1
let s:command_terminal_buf = -1

" Get configuration values
function! s:GetConfig(key, default)
    return get(g:, 'runner_' . a:key, a:default)
endfunction

" ============================================================================
" User Terminal (Ctrl+Z)
" ============================================================================

function! terminal#window#ToggleUserTerminal()
    " Find user terminal buffer
    let user_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'user_terminal_id', 0) == 1
            let user_buf_nr = buf.bufnr
            break
        endif
    endfor

    " If user terminal exists
    if user_buf_nr != -1
        let user_win_id = bufwinid(user_buf_nr)

        if user_win_id != -1
            " User terminal is visible, hide it
            call win_execute(user_win_id, 'hide')
        else
            " User terminal is hidden, show it (and hide command terminal)
            call s:HideCommandTerminal()
            let height = s:GetConfig('user_terminal_height', 5)
            execute 'belowright ' . height . 'split'
            execute 'buffer ' . user_buf_nr
            startinsert
        endif
    else
        " User terminal doesn't exist, create it
        call s:HideCommandTerminal()
        let height = s:GetConfig('user_terminal_height', 5)
        execute 'belowright terminal ++rows=' . height
        let b:user_terminal_id = 1
        let s:user_terminal_buf = bufnr('%')
        startinsert
    endif
endfunction

" ============================================================================
" Command Terminal (\g)
" ============================================================================

function! terminal#window#ToggleCommandTerminal()
    " Find command terminal buffer
    let cmd_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'command_terminal_id', 0) == 1
            let cmd_buf_nr = buf.bufnr
            break
        endif
    endfor

    " If command terminal exists
    if cmd_buf_nr != -1
        let cmd_win_id = bufwinid(cmd_buf_nr)

        if cmd_win_id != -1
            " Command terminal is visible, hide it
            call win_execute(cmd_win_id, 'hide')
        else
            " Command terminal is hidden, show it (and hide user terminal)
            call s:HideUserTerminal()
            let height = s:GetConfig('command_terminal_height', 10)
            execute 'belowright ' . height . 'split'
            execute 'buffer ' . cmd_buf_nr
            startinsert
        endif
    else
        " Command terminal doesn't exist, create it
        call s:HideUserTerminal()
        call terminal#window#CreateCommandTerminal()
    endif
endfunction

function! terminal#window#CreateCommandTerminal()
    let height = s:GetConfig('command_terminal_height', 10)
    execute 'belowright terminal ++rows=' . height
    let b:command_terminal_id = 1
    let s:command_terminal_buf = bufnr('%')

    " Set up terminal mode mappings (will be updated by mappings.vim later)
    tnoremap <buffer> <silent> <leader>g <Cmd>call terminal#window#ToggleCommandTerminal()<CR>

    startinsert
endfunction

function! terminal#window#ShowCommandTerminal()
    let cmd_buf_nr = s:GetCommandTerminalBuf()

    if cmd_buf_nr == -1
        " Create if doesn't exist
        call s:HideUserTerminal()
        call terminal#window#CreateCommandTerminal()
        return
    endif

    let cmd_win_id = bufwinid(cmd_buf_nr)

    if cmd_win_id == -1
        " Hidden, show it
        call s:HideUserTerminal()
        let height = s:GetConfig('command_terminal_height', 10)
        execute 'belowright ' . height . 'split'
        execute 'buffer ' . cmd_buf_nr
    endif
endfunction

function! terminal#window#GetCommandTerminalBuf()
    return s:GetCommandTerminalBuf()
endfunction

function! s:GetCommandTerminalBuf()
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'command_terminal_id', 0) == 1
            return buf.bufnr
        endif
    endfor
    return -1
endfunction

function! terminal#window#IsCommandTerminalRunning()
    let cmd_buf_nr = s:GetCommandTerminalBuf()

    if cmd_buf_nr == -1 || !bufexists(cmd_buf_nr)
        return 0
    endif

    " Check if terminal is running a process
    let term_status = term_getstatus(cmd_buf_nr)
    return term_status =~# 'running'
endfunction

" Close and delete command terminal buffer (for fresh restart)
function! terminal#window#CloseCommandTerminal()
    let cmd_buf_nr = s:GetCommandTerminalBuf()

    if cmd_buf_nr != -1 && bufexists(cmd_buf_nr)
        " Hide window if visible
        let cmd_win_id = bufwinid(cmd_buf_nr)
        if cmd_win_id != -1
            call win_execute(cmd_win_id, 'hide')
        endif

        " Delete buffer (this will kill the terminal process)
        execute 'bdelete! ' . cmd_buf_nr
    endif
endfunction

" ============================================================================
" Helper Functions (互斥显示)
" ============================================================================

function! s:HideUserTerminal()
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'user_terminal_id', 0) == 1
            let win_id = bufwinid(buf.bufnr)
            if win_id != -1
                call win_execute(win_id, 'hide')
            endif
            break
        endif
    endfor
endfunction

function! s:HideCommandTerminal()
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'command_terminal_id', 0) == 1
            let win_id = bufwinid(buf.bufnr)
            if win_id != -1
                call win_execute(win_id, 'hide')
            endif
            break
        endif
    endfor
endfunction
