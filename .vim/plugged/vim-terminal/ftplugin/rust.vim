" ============================================================================
" Rust Default Configuration for vim-terminal
" ============================================================================

if !exists('g:runner_filetype_defaults')
    let g:runner_filetype_defaults = {}
endif

let g:runner_filetype_defaults.rust = {
    \ 'b': 'cargo build',
    \ 'r': 'cargo run',
    \ 'c': 'cargo check',
    \ 't': 'cargo test',
\ }
