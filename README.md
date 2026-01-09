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

### 2. 更新插件（Git Subtree 方式）

本仓库使用 **git subtree** 管理插件，插件代码完整存储在主仓库中。

#### 当前管理的插件（通过 subtree）：

- `.vim/plugged/coc.nvim` - 代码补全引擎
- `.vim/plugged/vim-airline` - 状态栏
- `.vim/plugged/vim-polyglot` - 语法高亮

#### 更新单个插件：

```bash
# 更新 coc.nvim 到最新版本
vimgit subtree pull --prefix=.vim/plugged/coc.nvim \
    https://github.com/neoclide/coc.nvim.git release --squash

# 更新 vim-airline
vimgit subtree pull --prefix=.vim/plugged/vim-airline \
    https://github.com/vim-airline/vim-airline.git master --squash

# 更新 vim-polyglot
vimgit subtree pull --prefix=.vim/plugged/vim-polyglot \
    https://github.com/sheerun/vim-polyglot.git master --squash
```

#### 添加新的插件（通过 subtree）：

```bash
vimgit subtree add --prefix=.vim/plugged/插件名 \
    https://github.com/用户名/插件名.git master --squash
```

#### 更新后推送：

```bash
vimgit push
```

### 3. 使用插件管理器更新插件

如果你使用 vim-plug 等插件管理器：

```vim
" 在 vim 中执行
:PlugUpdate
```

**注意**：插件管理器更新后，只是更新了本地插件文件，但**不会自动提交到 git**。

如果你想保留这些更新，需要手动提交：

```bash
# vim-plug 更新后，检查状态
vimgit status

# 你会看到插件目录有修改（如果用 subtree 管理）
# 由于我们用的是 subtree，插件更新应该通过上面的 subtree pull 命令
```

**推荐做法**：
- 对于通过 subtree 管理的插件，使用 `vimgit subtree pull` 更新
- 对于其他插件，正常使用 `:PlugUpdate`，然后用 `vimgit add` 提交

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

# 更新插件（subtree）
vimgit subtree pull --prefix=.vim/plugged/<插件名> <仓库URL> <分支> --squash
```

## 注意事项

1. **不要在 Home 目录下运行普通的 `git` 命令**，始终使用 `vimgit`
2. **已配置忽略未跟踪文件**：`status.showUntrackedFiles = no`，只显示已跟踪的文件
3. **插件管理**：优先使用 `vimgit subtree pull` 更新插件，而不是 `:PlugUpdate`
4. **提交前检查**：运行 `vimgit diff` 确认改动内容

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
- **插件管理**：Git Subtree + vim-plug

---

最后更新：2026-01-09
