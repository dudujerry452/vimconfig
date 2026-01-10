# vim-terminal

A smart terminal and command execution plugin for Vim.

## Features

- **Two Independent Terminals**
  - User Terminal (Ctrl+Z): Free shell environment
  - Command Terminal (\g): Project command execution and output

- **Smart Main File Tracking**
  - Automatically tracks the current working file across splits
  - Ignores terminal and special buffers

- **Project-Aware Configuration**
  - Searches for `.vsettings.json` in current and parent directories
  - Auto-detects project root (`.git`, `Cargo.toml`, `stack.yaml`, etc.)
  - Configuration priority: `.vsettings.json` > Language defaults > Global defaults

- **Dynamic Key Mappings**
  - Automatically creates shortcuts based on configuration
  - Works in both source files and command terminal
  - Language-specific defaults (Haskell, Rust)

- **Session Command Support**
  - Use `@@` prefix for REPL/session commands (e.g., `@@:reload` in ghci)
  - Regular commands execute independently with auto-cd to project root

## Quick Start

### Basic Usage

1. Open a Haskell or Rust file
2. Press `\l` to load/run
3. Press `\r` to reload/run again
4. Press `\g` to toggle command terminal
5. Press `Ctrl+Z` to toggle user terminal

### Language Defaults

**Haskell**:
- `\l`: Load file in ghci
- `\r`: Reload in ghci
- `\t`: Type check main
- `\q`: Quit ghci

**Rust**:
- `\b`: cargo build
- `\r`: cargo run
- `\c`: cargo check
- `\t`: cargo test

### Custom Configuration

Create `.vsettings.json` in your project root:

```json
{
  "l": "ghci {$}",
  "r": "@@:reload",
  "b": "cargo build --release",
  "t": "python3 {$}"
}
```

Variables:
- `{$}`: Current main file path (automatically quoted with shellescape)

Generate template:
```vim
:RunnerGenerateConfig
:RunnerGenerateConfig haskell
```

## Commands

- `:RunnerReload` - Reload configuration
- `:RunnerGenerateConfig [filetype]` - Generate .vsettings.json template
- `:RunnerShowMainFile` - Show current main file info
- `:RunnerExecute <cmd>` - Execute command in command terminal
- `:RunnerToggleCommand` - Toggle command terminal
- `:RunnerToggleUser` - Toggle user terminal

## Configuration

Add to your `.vimrc`:

```vim
let g:runner_command_terminal_height = 10
let g:runner_user_terminal_height = 5
let g:runner_auto_cd_project_root = 1
let g:runner_clear_before_execute = 1
let g:runner_project_root_markers = ['.git', 'Cargo.toml', 'stack.yaml', '.vsettings.json']
```

## How It Works

1. **Main File Tracking**: Updates on `BufEnter` (ignores terminals)
2. **Configuration Loading**: Searches for `.vsettings.json` upwards, caches with mtime check
3. **Mapping Application**: Dynamically creates `<leader>` mappings for both source and terminal buffers
4. **Command Execution**:
   - Regular commands: `clear` + `cd <project_root>` + execute
   - Session commands (@@): Send directly to running process

## Session Commands

Use `@@` prefix for commands that should be sent to an existing process:

```json
{
  "l": "ghci {$}",       // Starts ghci
  "r": "@@:reload",      // Sends :reload to existing ghci
  "t": "@@:type main"    // Sends :type main to existing ghci
}
```

## Installation

Plugin is located at `~/.vim/plugged/vim-terminal/` and automatically loaded by Vim.

## License

MIT
