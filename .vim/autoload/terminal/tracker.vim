" ============================================================================
" Main File Tracking
" ============================================================================

" Global main file information
let g:runner_main_file = {
    \ 'path': '',
    \ 'dir': '',
    \ 'name': '',
    \ 'ext': '',
    \ 'filetype': '',
    \ 'project_root': '',
\ }

function! terminal#tracker#UpdateMainFile()
    " Ignore terminal buffers
    if &buftype == 'terminal' || &buftype == 'nofile'
        return
    endif

    " Ignore empty buffers
    if empty(expand('%'))
        return
    endif

    " Ignore special buffers (NERDTree, quickfix, etc.)
    if &filetype == 'nerdtree' || &filetype == 'qf'
        return
    endif

    " Update main file information
    let g:runner_main_file.path = expand('%:p')
    let g:runner_main_file.dir = expand('%:p:h')
    let g:runner_main_file.name = expand('%:t')
    let g:runner_main_file.ext = expand('%:e')
    let g:runner_main_file.filetype = &filetype

    " Find project root
    let g:runner_main_file.project_root = terminal#tracker#FindProjectRoot()

    " Trigger settings reload
    call terminal#settings#ReloadSettings()
endfunction

function! terminal#tracker#FindProjectRoot()
    " Priority order: .vsettings.json first, then others
    let markers = get(g:, 'runner_project_root_markers',
                    \ ['.vsettings.json', '.git', 'Cargo.toml', 'stack.yaml'])

    let current_dir = g:runner_main_file.dir

    for marker in markers
        let found = findfile(marker, current_dir . ';')
        let is_dir = 0

        if empty(found)
            " Try as directory (like .git)
            let found = finddir(marker, current_dir . ';')
            let is_dir = 1
        endif

        if !empty(found)
            " Get full path
            let full_path = fnamemodify(found, ':p')

            if is_dir
                " For directories like .git, remove trailing slash and get parent
                let full_path = substitute(full_path, '/$', '', '')
                return fnamemodify(full_path, ':h')
            else
                " For files like Cargo.toml, get the directory they're in
                return fnamemodify(full_path, ':h')
            endif
        endif
    endfor

    " Not found, return current file directory
    return current_dir
endfunction

function! terminal#tracker#GetMainFile()
    return g:runner_main_file
endfunction
