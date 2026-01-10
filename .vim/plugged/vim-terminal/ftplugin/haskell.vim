" ============================================================================
" Haskell Default Configuration for vim-terminal
" ============================================================================

if !exists('g:runner_filetype_defaults')
    let g:runner_filetype_defaults = {}
endif

let g:runner_filetype_defaults.haskell = {
    \ 'l': 'ghci {$}',
    \ 'r': '@@:reload',
    \ 't': '@@:type main',
    \ 'q': '@@:quit',
\ }
