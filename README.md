# Vim 配置管理指南

本仓库使用 **bare git repository** 方式管理 vim 配置文件。

## 快速开始

### vimgit 命令

`vimgit` 是管理此配置仓库的命令，用法与 `git` 完全相同：

```bash
# vimgit 实际上是：
# git --git-dir=$HOME/.vimconfig/ --work-tree=$HOME
```

### 克隆配置到新机器

```bash
# 1. 克隆配置仓库
git clone --bare https://github.com/dudujerry452/vimconfig.git $HOME/.vimconfig

# 2. 定义 vimgit alias
alias vimgit='git --git-dir=$HOME/.vimconfig/ --work-tree=$HOME'

# 3. 检出配置文件
vimgit checkout

# 4. 配置不显示未跟踪的文件（重要！）
vimgit config --local status.showUntrackedFiles no

# 5. 将 alias 添加到 shell 配置文件
echo "alias vimgit='git --git-dir=\$HOME/.vimconfig/ --work-tree=\$HOME'" >> ~/.zshrc
```

## 日常使用

### 1. 提交普通的配置更改

当你修改了 `.vimrc`、`.vim/` 下的配置文件时：

```bash
# 查看修改状态
vimgit status

# 查看具体改动
vimgit diff

# 添加修改的文件
vimgit add .vimrc
vimgit add .vim/toggleterm.vim

# 提交
vimgit commit -m "Update vim configuration"

# 推送到远程
vimgit push
```

### 2. 更新插件（推荐工作流：vim-plug + git 提交）

本仓库采用 **混合管理方式**：插件代码完整存储在仓库中，使用 vim-plug 更新，用 git 追踪版本。

#### 当前管理的插件：

- `.vim/plugged/coc.nvim` - 代码补全引擎
- `.vim/plugged/vim-airline` - 状态栏
- `.vim/plugged/vim-polyglot` - 语法高亮
- 其他 vim-plug 管理的插件

#### 推荐的插件更新流程：

**方法 1：使用 vim-plug（最简单，推荐日常使用）**

```vim
" 1. 在 vim 中执行更新
:PlugUpdate
```

```bash
# 2. 检查哪些插件被更新了
vimgit status

# 3. 查看具体改动（可选）
vimgit diff .vim/plugged/

# 4. 提交插件更新
vimgit add .vim/plugged/
vimgit commit -m "Update vim plugins via :PlugUpdate"

# 5. 推送到远程
vimgit push
```

**方法 2：使用 git subtree（更规范，但更复杂）**

如果你想保持完整的插件更新历史，可以用 subtree：

```bash
# 更新 coc.nvim
vimgit subtree pull --prefix=.vim/plugged/coc.nvim \
    https://github.com/neoclide/coc.nvim.git release --squash

# 更新 vim-airline
vimgit subtree pull --prefix=.vim/plugged/vim-airline \
    https://github.com/vim-airline/vim-airline.git master --squash

# 或者使用自动化脚本
./update-vim-plugins.sh

# 推送
vimgit push
```

**选择建议**：
- ✅ **日常使用方法 1**：简单快速，直接在 vim 中更新
- 🔧 **偶尔使用方法 2**：需要精确控制插件版本时

### 3. 添加新插件

在 `.vimrc` 中添加插件配置：

```vim
call plug#begin('~/.vim/plugged')
Plug 'author/plugin-name'
call plug#end()
```

然后安装并提交：

```vim
" 在 vim 中
:PlugInstall
```

```bash
# 提交新插件
vimgit add .vimrc
vimgit add .vim/plugged/plugin-name/
vimgit commit -m "Add plugin: plugin-name"
vimgit push
```

## Git Subtree vs Git Submodule

### 为什么使用 Subtree？

本仓库之前使用 submodule，现已改为 subtree：

| 特性 | Submodule | Subtree |
|------|-----------|---------|
| 存储方式 | 只存指针 | 完整代码 |
| 克隆复杂度 | 需要 `--recurse-submodules` | 普通 `git clone` |
| 依赖性 | 依赖外部仓库 | 完全独立 |
| 仓库大小 | 小 | 大 |
| 安全性 | 外部仓库删除会丢失 | 永久保存 |

**Subtree 的优势**：
- 更简单：其他人克隆后直接可用，不需要额外命令
- 更安全：即使原插件仓库被删除，你的配置不受影响
- 更友好：团队协作时不会因为忘记 `submodule update` 而出错

## 快速命令参考

**日常配置管理：**

```bash
# 查看状态
vimgit status

# 查看改动
vimgit diff

# 添加并提交
vimgit add <文件>
vimgit commit -m "提交信息"

# 推送
vimgit push

# 拉取最新配置
vimgit pull

# 查看提交历史
vimgit log --oneline
```

**更新插件（推荐）：**

```bash
# 方法 1：vim-plug（最简单）
# 在 vim 中执行 :PlugUpdate
# 然后：
vimgit add .vim/plugged/
vimgit commit -m "Update plugins"
vimgit push

# 方法 2：subtree（精确控制）
vimgit subtree pull --prefix=.vim/plugged/<插件名> <仓库URL> <分支> --squash
# 或使用脚本：
./update-vim-plugins.sh
```

## 注意事项

1. **不要在 Home 目录下运行普通的 `git` 命令**，始终使用 `vimgit`
2. **已配置忽略未跟踪文件**：`status.showUntrackedFiles = no`，只显示已跟踪的文件
3. **插件更新**：推荐在 vim 中用 `:PlugUpdate`，然后用 `vimgit add .vim/plugged/` 提交
4. **提交前检查**：运行 `vimgit status` 和 `vimgit diff` 确认改动内容
5. **`:PlugUpdate` 后记得提交**：插件更新不会自动提交到 git，需要手动 add 和 commit

## 故障排除

### 问题：vimgit 命令不存在

```bash
# 添加 alias 到 shell 配置
echo "alias vimgit='git --git-dir=\$HOME/.vimconfig/ --work-tree=\$HOME'" >> ~/.zshrc
source ~/.zshrc
```

### 问题：git status 显示太多文件

```bash
# 配置只显示已跟踪的文件
vimgit config --local status.showUntrackedFiles no
```

### 问题：`:PlugUpdate` 后 vimgit status 显示很多修改

这是正常的！插件更新后需要提交：

```bash
# 查看哪些插件被更新
vimgit status

# 查看具体改动（可选）
vimgit diff .vim/plugged/

# 提交所有插件更新
vimgit add .vim/plugged/
vimgit commit -m "Update plugins via :PlugUpdate"
vimgit push
```

### 问题：插件更新后无法正常使用

```bash
# 检查插件目录权限
ls -la ~/.vim/plugged/

# 重新安装插件
# 在 vim 中执行：
:PlugClean
:PlugInstall
```

## 仓库信息

- **远程仓库**：`https://github.com/dudujerry452/vimconfig.git`
- **Git 目录**：`$HOME/.vimconfig/`
- **工作目录**：`$HOME`
- **插件管理**：vim-plug + git 追踪（混合方式）
  - 插件代码完整存储在仓库中
  - 使用 `:PlugUpdate` 更新，用 `vimgit` 提交

---

最后更新：2026-01-09
