" ============================================================================
" Haskell GHCi Integration
" ============================================================================

function! s:ToggleGHCi()
    " Find GHCi terminal buffer with our special marker
    let ghci_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'haskell_ghci_id', 0) == 1
            let ghci_buf_nr = buf.bufnr
            break
        endif
    endfor

    " If GHCi buffer exists...
    if ghci_buf_nr != -1
        let ghci_win_id = bufwinid(ghci_buf_nr)

        if ghci_win_id != -1
            " GHCi is visible, hide it
            call win_execute(ghci_win_id, 'hide')
        else
            " GHCi is hidden, show it
            belowright 10split
            execute "buffer " . ghci_buf_nr
            startinsert
        endif
    else
        " GHCi doesn't exist, create a new one
        belowright terminal ++rows=10
        let b:haskell_ghci_id = 1
        " Set up terminal mode mappings for this buffer
        tnoremap <buffer> <silent> <leader>g <Cmd>call <SID>ToggleGHCi()<CR>
        tnoremap <buffer> <silent> <leader>l <Cmd>call <SID>LoadCurrentFile()<CR>
        tnoremap <buffer> <silent> <leader>r <Cmd>call <SID>ReloadGHCi()<CR>
        " Send ghci command to start
        call term_sendkeys(bufnr('%'), "ghci\<CR>")
        startinsert
    endif
endfunction

function! s:LoadCurrentFile()
    " Save current file path FIRST, before any window switching
    let current_file = expand('%:p')

    " Find GHCi terminal buffer
    let ghci_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'haskell_ghci_id', 0) == 1
            let ghci_buf_nr = buf.bufnr
            break
        endif
    endfor

    if ghci_buf_nr != -1
        " Get current file path and escape it with quotes
        let load_cmd = ':load "' . current_file . '"' . "\<CR>"

        " Make GHCi visible if hidden
        let ghci_win_id = bufwinid(ghci_buf_nr)
        if ghci_win_id == -1
            belowright 10split
            execute "buffer " . ghci_buf_nr
        endif

        " Send :load command to GHCi
        call term_sendkeys(ghci_buf_nr, load_cmd)

        " Focus on GHCi window and enter insert mode
        call win_gotoid(bufwinid(ghci_buf_nr))
        startinsert
    else
        " No GHCi buffer exists, create one and load file
        call s:ToggleGHCi()
        " Wait a bit for ghci to start, then load file
        sleep 500m
        let ghci_buf_nr = -1
        for buf in getbufinfo({'buftype': 'terminal'})
            if getbufvar(buf.bufnr, 'haskell_ghci_id', 0) == 1
                let ghci_buf_nr = buf.bufnr
                break
            endif
        endfor
        if ghci_buf_nr != -1
            let load_cmd = ':load "' . current_file . '"' . "\<CR>"
            call term_sendkeys(ghci_buf_nr, load_cmd)
        endif
    endif
endfunction

function! s:ReloadGHCi()
    " Find GHCi terminal buffer
    let ghci_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'haskell_ghci_id', 0) == 1
            let ghci_buf_nr = buf.bufnr
            break
        endif
    endfor

    if ghci_buf_nr != -1
        " Send :reload command
        call term_sendkeys(ghci_buf_nr, ":reload\<CR>")
        echo "GHCi reloaded"
    else
        echo "No GHCi session found. Use <leader>l to start one."
    endif
endfunction

" Key mappings (for Haskell files)
nnoremap <buffer> <silent> <leader>l :call <SID>LoadCurrentFile()<CR>
nnoremap <buffer> <silent> <leader>r :call <SID>ReloadGHCi()<CR>
nnoremap <buffer> <silent> <leader>g :call <SID>ToggleGHCi()<CR>

" Optional: Auto-load on save
" Uncomment the line below if you want to auto-reload on every save
" autocmd BufWritePost <buffer> call s:ReloadGHCi()
