" ============================================================================
" Rust Cargo Integration
" ============================================================================

" Find the nearest Cargo.toml in parent directories
function! s:FindCargoToml()
    let current_dir = expand('%:p:h')
    let cargo_toml = findfile('Cargo.toml', current_dir . ';')

    if empty(cargo_toml)
        echo "Error: Cargo.toml not found in parent directories"
        return ''
    endif

    " Return the directory containing Cargo.toml
    return fnamemodify(cargo_toml, ':p:h')
endfunction

" Toggle cargo terminal window
function! s:ToggleCargoTerminal()
    " Find cargo terminal buffer with our special marker
    let cargo_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'rust_cargo_id', 0) == 1
            let cargo_buf_nr = buf.bufnr
            break
        endif
    endfor

    " If cargo buffer exists...
    if cargo_buf_nr != -1
        let cargo_win_id = bufwinid(cargo_buf_nr)

        if cargo_win_id != -1
            " Cargo terminal is visible, hide it
            call win_execute(cargo_win_id, 'hide')
        else
            " Cargo terminal is hidden, show it
            belowright 10split
            execute "buffer " . cargo_buf_nr
            startinsert
        endif
    else
        " Cargo terminal doesn't exist, create a new one
        belowright terminal ++rows=10
        let b:rust_cargo_id = 1
        " Set up terminal mode mappings for this buffer
        tnoremap <buffer> <silent> <leader>g <Cmd>call <SID>ToggleCargoTerminal()<CR>
        tnoremap <buffer> <silent> <leader>b <Cmd>call <SID>CargoBuild()<CR>
        tnoremap <buffer> <silent> <leader>r <Cmd>call <SID>CargoRun()<CR>
        tnoremap <buffer> <silent> <leader>c <Cmd>call <SID>CargoCheck()<CR>
        tnoremap <buffer> <silent> <leader>t <Cmd>call <SID>CargoTest()<CR>
        startinsert
    endif
endfunction

" Execute a cargo command in the cargo terminal
function! s:ExecuteCargoCommand(cmd)
    let cargo_dir = s:FindCargoToml()
    if empty(cargo_dir)
        return
    endif

    " Find or create cargo terminal buffer
    let cargo_buf_nr = -1
    for buf in getbufinfo({'buftype': 'terminal'})
        if getbufvar(buf.bufnr, 'rust_cargo_id', 0) == 1
            let cargo_buf_nr = buf.bufnr
            break
        endif
    endfor

    if cargo_buf_nr == -1
        " Create cargo terminal if it doesn't exist
        call s:ToggleCargoTerminal()
        sleep 100m
        " Find the newly created terminal
        for buf in getbufinfo({'buftype': 'terminal'})
            if getbufvar(buf.bufnr, 'rust_cargo_id', 0) == 1
                let cargo_buf_nr = buf.bufnr
                break
            endif
        endfor
    endif

    if cargo_buf_nr != -1
        " Make terminal visible if hidden
        let cargo_win_id = bufwinid(cargo_buf_nr)
        if cargo_win_id == -1
            belowright 10split
            execute "buffer " . cargo_buf_nr
        endif

        " Clear screen and execute command
        call term_sendkeys(cargo_buf_nr, "clear\<CR>")
        call term_sendkeys(cargo_buf_nr, "cd \"" . cargo_dir . "\"\<CR>")
        call term_sendkeys(cargo_buf_nr, a:cmd . "\<CR>")

        " Focus on cargo window
        call win_gotoid(bufwinid(cargo_buf_nr))
        startinsert
    endif
endfunction

" Cargo build
function! s:CargoBuild()
    call s:ExecuteCargoCommand('cargo build')
endfunction

" Cargo run
function! s:CargoRun()
    call s:ExecuteCargoCommand('cargo run')
endfunction

" Cargo check (faster than build)
function! s:CargoCheck()
    call s:ExecuteCargoCommand('cargo check')
endfunction

" Cargo test
function! s:CargoTest()
    call s:ExecuteCargoCommand('cargo test')
endfunction

" Key mappings (for Rust files)
nnoremap <buffer> <silent> <leader>b :call <SID>CargoBuild()<CR>
nnoremap <buffer> <silent> <leader>r :call <SID>CargoRun()<CR>
nnoremap <buffer> <silent> <leader>c :call <SID>CargoCheck()<CR>
nnoremap <buffer> <silent> <leader>t :call <SID>CargoTest()<CR>
nnoremap <buffer> <silent> <leader>g :call <SID>ToggleCargoTerminal()<CR>
