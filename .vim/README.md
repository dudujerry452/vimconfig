# Vim 配置说明

## 终端窗口

### 快捷键
- `Ctrl+Z` - 唤出/关闭终端窗口（普通模式和终端模式均可用）

### 特性
- 底部 5 行分屏
- 自动进入插入模式
- 保持同一个终端会话
- 隐藏后再打开，会话保留

---

## Rust Cargo 集成

### 快捷键（在 `.rs` 文件中）

| 快捷键 | 功能 | 备注 |
|--------|------|------|
| `\b` | `cargo build` | 编译项目 |
| `\r` | `cargo run` | 运行项目 |
| `\c` | `cargo check` | 快速检查（比 build 快） |
| `\t` | `cargo test` | 运行测试 |
| `\g` | 显示/隐藏 cargo 窗口 | - |

### 特性
- 自动查找上层最近的 `Cargo.toml`
- 底部 10 行 cargo 终端窗口
- 显示编译错误、警告和测试结果
- 自动切换到项目根目录执行命令
- **在 cargo 终端内也可使用 `\b` `\r` `\c` `\t` `\g`**（无需退出终端模式）

### 工作流示例
```rust
// src/main.rs
fn main() {
    println!("Hello, world!");
}
```

1. 打开 `src/main.rs`
2. 按 `\c` → cargo 窗口打开并执行 `cargo check`（快速检查语法）
3. 看到编译错误，修改代码
4. 在 cargo 窗口内按 `\c` → 重新检查
5. 确认无误后按 `\r` → 运行程序
6. 按 `\g` → 隐藏窗口继续编辑

---

## Haskell GHCi 集成

### 快捷键（在 `.hs` 文件中）

| 快捷键 | 功能 | 备注 |
|--------|------|------|
| `\l` | 加载当前文件到 ghci | 首次使用会创建 ghci 窗口 |
| `\r` | 重新加载（`:reload`） | 修改代码后快速重载 |
| `\g` | 显示/隐藏 ghci 窗口 | - |

### 特性
- 底部 10 行 ghci 窗口
- 自动加载当前 Haskell 文件
- 显示编译错误和警告
- 支持路径中包含空格的文件
- **在 ghci 终端内也可使用 `\l` `\r` `\g`**（无需退出终端模式）

### 工作流示例
```haskell
-- Main.hs
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

1. 打开 `Main.hs`
2. 按 `\l` → ghci 窗口打开并加载文件
3. 在 ghci 中测试：`factorial 10`
4. 修改代码
5. 在 ghci 窗口内按 `\r` → 重新加载
6. 按 `\g` → 隐藏窗口继续编辑

---

## 窗口导航

### 快捷键
- `Ctrl+h` - 跳转到左边窗口
- `Ctrl+j` - 跳转到下面窗口
- `Ctrl+k` - 跳转到上面窗口
- `Ctrl+l` - 跳转到右边窗口

### 特性
- 普通模式和终端模式均可用
- 在终端模式会自动退出终端模式并切换窗口
- 替代繁琐的 `Ctrl+W` 组合键

---

## 其他实用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+S` | 保存文件（普通/插入/可视模式） |
| `\ya` | 复制整个文件内容到系统剪贴板 |
| `\q` | 强制退出所有窗口 |
| `Esc` | 在终端模式退出到普通模式 |
| `Enter` | 清除搜索高亮 |
| `Ctrl+T` | 切换 NERDTree 文件树 |

---

## 文件结构

```
~/.vim/
├── toggleterm.vim          # 终端窗口配置
├── ftplugin/
│   ├── haskell.vim        # Haskell GHCi 集成
│   └── rust.vim           # Rust Cargo 集成
├── plugin-config.vim       # 插件配置（NERDTree, CoC）
├── plugins.vim             # 插件管理
├── autoclose.vim          # 自动闭合括号
└── directorylayout.vim    # 目录布局
```

---

## 注意事项

### 终端模式映射覆盖
使用 `Ctrl+hjkl` 在终端窗口切换会覆盖 shell 的默认快捷键：
- `Ctrl+H` - 原为删除字符
- `Ctrl+L` - 原为清屏

如需使用这些 shell 快捷键，请先按 `Esc` 退出终端模式。

### Leader 键
默认 Leader 键为 `\`（反斜杠），可在 `.vimrc` 中修改：
```vim
let mapleader = ","  " 改为逗号
```
