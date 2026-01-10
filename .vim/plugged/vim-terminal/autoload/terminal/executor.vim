" ============================================================================
" Command Execution
" ============================================================================

function! terminal#executor#Execute(cmd_template)
    " Save current window
    let source_win = win_getid()

    " Replace variables
    let cmd = s:ReplaceVariables(a:cmd_template)

    " Check if it's a session command (starts with @@)
    if cmd =~# '^@@'
        let session_cmd = substitute(cmd, '^@@', '', '')
        call s:SendToSession(session_cmd, source_win)
    else
        call s:ExecuteNormalCommand(cmd, source_win)
    endif
endfunction

function! s:ReplaceVariables(cmd)
    let cmd = a:cmd
    let f = g:runner_main_file

    " Replace {$} with main file path
    let cmd = substitute(cmd, '{$}', shellescape(f.path), 'g')

    " Future expansions:
    " let cmd = substitute(cmd, '{name}', shellescape(f.name), 'g')
    " let cmd = substitute(cmd, '{dir}', shellescape(f.dir), 'g')
    " let cmd = substitute(cmd, '{root}', shellescape(f.project_root), 'g')
    " let cmd = substitute(cmd, '{ext}', f.ext, 'g')

    return cmd
endfunction

function! s:ExecuteNormalCommand(cmd, source_win)
    " Close old command terminal (if exists) to start fresh
    call terminal#window#CloseCommandTerminal()

    " Create new command terminal and show it
    call terminal#window#ShowCommandTerminal()

    let cmd_buf = terminal#window#GetCommandTerminalBuf()
    if cmd_buf == -1
        echohl ErrorMsg
        echo "Failed to create command terminal"
        echohl None
        return
    endif

    " CD to project root if configured
    if get(g:, 'runner_auto_cd_project_root', 1)
        let root = g:runner_main_file.project_root
        if !empty(root)
            call term_sendkeys(cmd_buf, "cd " . shellescape(root) . "\<CR>")
            sleep 50m
        endif
    endif

    " Execute command
    call term_sendkeys(cmd_buf, a:cmd . "\<CR>")

    " Return focus to source window
    call win_gotoid(a:source_win)
endfunction

function! s:SendToSession(cmd, source_win)
    if !terminal#window#IsCommandTerminalRunning()
        echohl WarningMsg
        echo "No active session. Use a command that starts a session first (e.g. \\l)"
        echohl None
        return
    endif

    " Show command terminal if hidden
    call terminal#window#ShowCommandTerminal()

    let cmd_buf = terminal#window#GetCommandTerminalBuf()
    if cmd_buf == -1
        echohl ErrorMsg
        echo "Command terminal not found"
        echohl None
        return
    endif

    " Send command directly to session (no clear, no cd)
    call term_sendkeys(cmd_buf, a:cmd . "\<CR>")

    " Return focus to source window
    call win_gotoid(a:source_win)
endfunction
