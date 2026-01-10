" ============================================================================
" vim-terminal - Plugin Entry Point
" ============================================================================

if exists('g:loaded_vim_terminal')
    finish
endif
let g:loaded_vim_terminal = 1

" Initialize plugin
call terminal#Init()

" ============================================================================
" Global Key Mappings
" ============================================================================

" User Terminal (Ctrl+Z)
nnoremap <silent> <C-z> :call terminal#window#ToggleUserTerminal()<CR>
tnoremap <silent> <C-z> <Cmd>call terminal#window#ToggleUserTerminal()<CR>

" Command Terminal (\g) - will be overridden by buffer-local mappings
" but provide a fallback
nnoremap <silent> <leader>g :call terminal#window#ToggleCommandTerminal()<CR>

" ============================================================================
" Commands
" ============================================================================

command! RunnerReload call terminal#settings#ReloadSettings()
command! -nargs=? RunnerGenerateConfig call terminal#settings#GenerateConfig(<f-args>)
command! RunnerShowMainFile call terminal#ShowMainFile()
command! -nargs=1 RunnerExecute call terminal#executor#Execute(<q-args>)
command! RunnerToggleCommand call terminal#window#ToggleCommandTerminal()
command! RunnerToggleUser call terminal#window#ToggleUserTerminal()

" ============================================================================
" Default Configuration
" ============================================================================

" Terminal heights (can be overridden by user in .vimrc)
if !exists('g:runner_command_terminal_height')
    let g:runner_command_terminal_height = 10
endif

if !exists('g:runner_user_terminal_height')
    let g:runner_user_terminal_height = 5
endif

" Auto CD to project root
if !exists('g:runner_auto_cd_project_root')
    let g:runner_auto_cd_project_root = 1
endif

" Clear before execute
if !exists('g:runner_clear_before_execute')
    let g:runner_clear_before_execute = 1
endif

" Project root markers (priority order)
if !exists('g:runner_project_root_markers')
    let g:runner_project_root_markers = ['.vsettings.json', '.git', 'Cargo.toml', 'stack.yaml']
endif
