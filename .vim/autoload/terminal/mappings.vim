" ============================================================================
" Dynamic Key Mappings
" ============================================================================

function! terminal#mappings#ApplyMappings()
    " Only apply to source files (not terminals)
    if &buftype == 'terminal' || &buftype == 'nofile'
        return
    endif

    " Get effective configuration
    let config = terminal#settings#GetEffectiveConfig()

    " Apply mappings to current buffer (source file)
    call s:ApplyToSourceBuffer(config)

    " Update command terminal mappings if it exists
    call s:UpdateCommandTerminalMappings(config)
endfunction

function! s:ApplyToSourceBuffer(config)
    " Clear old mappings first (optional, vim will override)
    " We apply buffer-local mappings

    " Apply \g for toggling command terminal
    nnoremap <buffer> <silent> <leader>g :call terminal#window#ToggleCommandTerminal()<CR>

    " Apply dynamic mappings from config
    for [key, cmd] in items(a:config)
        " Skip special keys or comments
        if key[0] == '_'
            continue
        endif

        " Create mapping
        execute printf('nnoremap <buffer> <silent> <leader>%s :call terminal#executor#Execute("%s")<CR>',
                     \ key, escape(cmd, '"'))
    endfor
endfunction

function! s:UpdateCommandTerminalMappings(config)
    " Find command terminal buffer
    let cmd_buf = terminal#window#GetCommandTerminalBuf()

    if cmd_buf == -1 || !bufexists(cmd_buf)
        return
    endif

    " Apply mappings to command terminal buffer
    " We need to execute in the context of that buffer
    call win_execute(bufwinid(cmd_buf), 'call s:ApplyToCommandTerminal(' . string(a:config) . ')')
endfunction

function! s:ApplyToCommandTerminal(config)
    " This runs in the context of the command terminal buffer

    " Apply \g for toggling
    tnoremap <buffer> <silent> <leader>g <Cmd>call terminal#window#ToggleCommandTerminal()<CR>

    " Apply dynamic mappings from config
    for [key, cmd] in items(a:config)
        if key[0] == '_'
            continue
        endif

        execute printf('tnoremap <buffer> <silent> <leader>%s <Cmd>call terminal#executor#Execute("%s")<CR>',
                     \ key, escape(cmd, '"'))
    endfor
endfunction

" Public function to apply mappings to command terminal (called when creating terminal)
function! terminal#mappings#ApplyToCommandTerminal()
    let config = terminal#settings#GetEffectiveConfig()
    call s:ApplyToCommandTerminal(config)
endfunction
