" ============================================================================
" vim-terminal - Main Entry Point
" ============================================================================

function! terminal#Init()
    " Initialize global variables if not set
    if !exists('g:runner_filetype_defaults')
        let g:runner_filetype_defaults = {}
    endif

    " Set up autocommands
    augroup VimTerminal
        autocmd!
        " Update main file on buffer enter
        autocmd BufEnter * call terminal#tracker#UpdateMainFile()
        " Apply mappings on buffer enter
        autocmd BufEnter * call terminal#mappings#ApplyMappings()
    augroup END
endfunction

function! terminal#ShowMainFile()
    let f = g:runner_main_file
    echo "Main File Information:"
    echo "  Path:         " . f.path
    echo "  Directory:    " . f.dir
    echo "  Name:         " . f.name
    echo "  Extension:    " . f.ext
    echo "  Filetype:     " . f.filetype
    echo "  Project Root: " . f.project_root
endfunction
