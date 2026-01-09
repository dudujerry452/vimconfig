#!/bin/bash

# ==============================================================================
# Vim Plugins Update Script (Git Subtree)
# ==============================================================================
#
# 使用方法：
#   ./update-vim-plugins.sh          # 更新所有插件
#   ./update-vim-plugins.sh coc      # 只更新 coc.nvim
#   ./update-vim-plugins.sh airline  # 只更新 vim-airline
#
# ==============================================================================

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 vimgit 命令是否存在
if ! command -v vimgit &> /dev/null; then
    echo -e "${RED}错误: vimgit 命令不存在${NC}"
    echo "请在 shell 配置文件中添加："
    echo "alias vimgit='git --git-dir=\$HOME/.vimconfig/ --work-tree=\$HOME'"
    exit 1
fi

# 插件配置（名称 路径 仓库URL 分支）
declare -A PLUGINS=(
    ["coc"]=".vim/plugged/coc.nvim|https://github.com/neoclide/coc.nvim.git|release"
    ["airline"]=".vim/plugged/vim-airline|https://github.com/vim-airline/vim-airline.git|master"
    ["polyglot"]=".vim/plugged/vim-polyglot|https://github.com/sheerun/vim-polyglot.git|master"
)

# 更新单个插件
update_plugin() {
    local name=$1
    local info="${PLUGINS[$name]}"

    if [ -z "$info" ]; then
        echo -e "${RED}错误: 未知的插件 '$name'${NC}"
        echo "可用的插件: ${!PLUGINS[@]}"
        exit 1
    fi

    IFS='|' read -r prefix url branch <<< "$info"

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}正在更新: $name${NC}"
    echo -e "${YELLOW}路径: $prefix${NC}"
    echo -e "${YELLOW}仓库: $url${NC}"
    echo -e "${YELLOW}分支: $branch${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    cd ~
    vimgit subtree pull --prefix="$prefix" "$url" "$branch" --squash

    echo -e "${GREEN}✓ $name 更新完成${NC}\n"
}

# 主逻辑
main() {
    echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Vim Plugins Updater (Git Subtree)      ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}\n"

    # 检查工作区是否干净
    if ! vimgit diff-index --quiet HEAD -- 2>/dev/null; then
        echo -e "${YELLOW}警告: 工作区有未提交的更改${NC}"
        echo -e "${YELLOW}建议先提交或暂存更改再更新插件${NC}\n"
        read -p "是否继续？(y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "已取消"
            exit 0
        fi
    fi

    # 如果指定了插件名称，只更新该插件
    if [ $# -gt 0 ]; then
        for plugin in "$@"; do
            update_plugin "$plugin"
        done
    else
        # 更新所有插件
        echo -e "${GREEN}开始更新所有插件...${NC}\n"
        for plugin in "${!PLUGINS[@]}"; do
            update_plugin "$plugin"
        done
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}所有插件更新完成！${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # 提示推送
    echo -e "${YELLOW}记得推送到远程仓库:${NC}"
    echo -e "${YELLOW}  vimgit push${NC}\n"
}

# 显示帮助信息
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "使用方法:"
    echo "  $0                 # 更新所有插件"
    echo "  $0 <plugin>        # 更新指定插件"
    echo ""
    echo "可用的插件:"
    for plugin in "${!PLUGINS[@]}"; do
        echo "  - $plugin"
    done
    echo ""
    echo "示例:"
    echo "  $0                 # 更新所有插件"
    echo "  $0 coc             # 只更新 coc.nvim"
    echo "  $0 coc airline     # 更新 coc.nvim 和 vim-airline"
    exit 0
fi

main "$@"
