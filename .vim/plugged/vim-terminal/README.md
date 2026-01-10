# vim-terminal

A smart terminal and command execution plugin for Vim.

## Features

- **Two Independent Terminals**
  - **User Terminal** (Ctrl+Z): Free shell environment for general use
  - **Command Terminal** (\g): Project command execution with automatic cd to project root
  - Mutually exclusive display (only one visible at a time)

- **Smart Main File Tracking**
  - Automatically tracks the current working file across splits
  - Ignores terminal and special buffers (NERDTree, quickfix, etc.)
  - Preserves context when switching between windows

- **Project-Aware Configuration**
  - Searches for `.vsettings.json` in current and parent directories (upward search)
  - Auto-detects project root via `.vsettings.json`, `.git`, `Cargo.toml`, `stack.yaml`
  - **Priority order**: `.vsettings.json` > `.git` > `Cargo.toml` > `stack.yaml`
  - Configuration priority: `.vsettings.json` > Language defaults > Global defaults
  - Automatic mtime-based caching for performance

- **Dynamic Key Mappings**
  - Automatically creates shortcuts based on configuration
  - Works in both source files and command terminal (no need to exit terminal mode)
  - Language-specific defaults (Haskell, Rust, extensible)

- **Session Command Support**
  - Use `@@` prefix for REPL/session commands (e.g., `@@:reload` in ghci)
  - Normal commands close old terminal and create fresh environment
  - Session commands preserve the running process

## Installation

The plugin is located at `~/.vim/plugged/vim-terminal/` and is automatically loaded by Vim.

For vim-plug users, add to your `.vim/plugins.vim`:
```vim
Plug '~/.vim/plugged/vim-terminal'
```

Then run `:PlugInstall`.

## Quick Start

### Basic Usage

1. Open a Haskell or Rust file
2. Press `\l` to load/run
3. Press `\r` to reload/run again
4. Press `\g` to toggle command terminal
5. Press `Ctrl+Z` to toggle user terminal

### Language Defaults

**Haskell** (`.hs` files):
- `\l`: Load file in ghci (creates fresh terminal)
- `\r`: Reload in ghci (sends `:reload` to existing session)
- `\t`: Type check main (sends `:type main`)
- `\q`: Quit ghci (sends `:quit`)

**Rust** (`.rs` files):
- `\b`: `cargo build`
- `\r`: `cargo run`
- `\c`: `cargo check` (faster than build)
- `\t`: `cargo test`

## Custom Configuration

### Create `.vsettings.json`

Create `.vsettings.json` in your project root:

```json
{
  "l": "ghci {$}",
  "r": "@@:reload",
  "b": "cargo build --release",
  "t": "python3 {$}"
}
```

**Variables:**
- `{$}`: Current main file path (automatically quoted with `shellescape`)

**Future extensions** (not yet implemented):
- `{name}`: File name
- `{dir}`: File directory
- `{root}`: Project root
- `{ext}`: File extension

### Generate Template

Automatically generate `.vsettings.json` based on current file type:
```vim
:RunnerGenerateConfig
:RunnerGenerateConfig haskell
```

## Commands

| Command | Description |
|---------|-------------|
| `:RunnerReload` | Reload configuration from `.vsettings.json` |
| `:RunnerGenerateConfig [filetype]` | Generate `.vsettings.json` template |
| `:RunnerShowMainFile` | Show current main file info |
| `:RunnerExecute <cmd>` | Execute command in command terminal |
| `:RunnerToggleCommand` | Toggle command terminal |
| `:RunnerToggleUser` | Toggle user terminal |

## Configuration Options

Add to your `.vimrc`:

```vim
" Terminal heights
let g:runner_command_terminal_height = 10
let g:runner_user_terminal_height = 5

" Behavior
let g:runner_auto_cd_project_root = 1
let g:runner_clear_before_execute = 1

" Project root detection (priority order)
let g:runner_project_root_markers = ['.vsettings.json', '.git', 'Cargo.toml', 'stack.yaml']
```

## How It Works

### Main File Tracking
Updates on `BufEnter` (ignores terminals and special buffers). The main file is the last edited source file, even when focus moves to terminals or other windows.

### Configuration Loading
1. Searches for `.vsettings.json` upwards from current file
2. Caches with mtime check (auto-reloads on file change)
3. Merges with language defaults and global config

### Mapping Application
Dynamically creates `<leader>` mappings for:
1. Source file buffers (normal mode)
2. Command terminal buffer (terminal mode)

Mappings update automatically when:
- Entering a buffer (`BufEnter`)
- Configuration changes (`:RunnerReload` or automatic mtime detection)

### Command Execution

**Normal Commands** (no `@@` prefix):
1. Close old command terminal (kills processes)
2. Create new terminal
3. `cd` to project root (if `g:runner_auto_cd_project_root = 1`)
4. Execute command
5. Focus returns to source file

**Session Commands** (`@@` prefix):
1. Check if command terminal has a running process
2. Send command directly to existing session
3. Focus returns to source file

### Project Root Detection

Priority order (stops at first match):
1. `.vsettings.json`
2. `.git` directory (returns parent directory, not `.git/`)
3. `Cargo.toml`
4. `stack.yaml`

If none found, uses current file directory.

## Session Commands

Use `@@` prefix for commands that should be sent to an existing process:

```json
{
  "l": "ghci {$}",       // Starts ghci (closes old terminal)
  "r": "@@:reload",      // Sends :reload to existing ghci
  "t": "@@:type main"    // Sends :type main to existing ghci
}
```

**Why this matters:**
- `\l` creates a fresh ghci every time (useful for clean start)
- `\r` keeps your ghci session with loaded modules and state

## Examples

### Haskell Workflow

```bash
# Project structure
my-haskell-project/
├── .vsettings.json
├── stack.yaml
└── src/
    └── Main.hs
```

```json
// .vsettings.json
{
  "l": "ghci {$}",
  "r": "@@:reload",
  "t": "@@:type main",
  "q": "@@:quit"
}
```

Workflow:
1. `vim src/Main.hs`
2. `\l` → Loads file in ghci
3. Edit code, `Ctrl-S` to save
4. `\r` → Reloads in same ghci session
5. `\t` → Type check
6. `\g` → Hide terminal

### Rust Workflow

```bash
# Project structure
my-rust-project/
├── Cargo.toml
└── src/
    └── main.rs
```

No `.vsettings.json` needed (uses defaults):

1. `vim src/main.rs`
2. `\c` → Quick check with `cargo check`
3. `\b` → Build with `cargo build`
4. `\r` → Run with `cargo run`
5. `\t` → Run tests

### Python with Custom Commands

```json
{
  "_comment": "Python development",
  "r": "python3 {$}",
  "t": "pytest",
  "f": "black {$}",
  "l": "pylint {$}"
}
```

### Multi-Language Project

```json
{
  "_comment": "Build system commands",
  "b": "make build",
  "r": "make run",
  "t": "make test",
  "c": "make clean",
  "d": "make docker-build"
}
```

## Troubleshooting

### Mappings not working

1. Check if plugin is loaded: `:echo exists('g:loaded_vim_terminal')`
2. Check filetype: `:echo &filetype`
3. Check main file: `:RunnerShowMainFile`
4. Reload configuration: `:RunnerReload`

### Configuration not loading

1. Check `.vsettings.json` syntax: `:!cat .vsettings.json`
2. Errors are shown in status line
3. Check project root: `:RunnerShowMainFile` (shows project_root)

### Terminal behavior issues

- If terminal doesn't close properly, check for stuck processes: `:!ps aux | grep vim`
- User terminal and command terminal are mutually exclusive by design

## Documentation

View full documentation:
```vim
:help vim-terminal
```

## License

MIT

## Contributing

This plugin was developed with assistance from Claude (Anthropic).
Contributions and feedback welcome!
