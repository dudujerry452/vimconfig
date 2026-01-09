#!/bin/bash

# ==============================================================================
# Quick Commit Script for Vim Config Changes
# ==============================================================================
#
# 使用方法：
#   ./quick-commit.sh               # 交互式提交所有更改
#   ./quick-commit.sh "message"     # 直接提交并推送
#   ./quick-commit.sh plugins       # 快速提交插件更新
#   ./quick-commit.sh config        # 快速提交配置更改
#
# ==============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 检查 vimgit 命令
if ! command -v vimgit &> /dev/null; then
    echo -e "${RED}错误: vimgit 命令不存在${NC}"
    exit 1
fi

# 快速提交类型
case "$1" in
    plugins)
        echo -e "${BLUE}提交插件更新...${NC}"
        vimgit add .vim/plugged/
        vimgit commit -m "Update vim plugins via :PlugUpdate"
        vimgit push
        echo -e "${GREEN}✓ 插件更新已提交并推送${NC}"
        exit 0
        ;;
    config)
        echo -e "${BLUE}提交配置更改...${NC}"
        vimgit add .vimrc .vim/*.vim
        vimgit commit -m "Update vim configuration"
        vimgit push
        echo -e "${GREEN}✓ 配置更改已提交并推送${NC}"
        exit 0
        ;;
esac

# 如果提供了提交信息，直接提交
if [ -n "$1" ]; then
    echo -e "${BLUE}提交所有更改: $1${NC}"
    vimgit add -u
    vimgit commit -m "$1"
    vimgit push
    echo -e "${GREEN}✓ 已提交并推送${NC}"
    exit 0
fi

# 交互式提交流程
echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Vim Config Quick Commit Tool        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}\n"

# 检查状态
echo -e "${YELLOW}当前状态：${NC}"
vimgit status
echo ""

# 检查是否有更改
if vimgit diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "${GREEN}没有需要提交的更改${NC}"
    exit 0
fi

# 显示详细改动
echo -e "${YELLOW}查看具体改动？(y/N)${NC}"
read -r show_diff
if [[ $show_diff =~ ^[Yy]$ ]]; then
    vimgit diff
    echo ""
fi

# 选择提交类型
echo -e "${YELLOW}选择提交类型：${NC}"
echo "1) 插件更新 (Update vim plugins via :PlugUpdate)"
echo "2) 配置更改 (Update vim configuration)"
echo "3) 自定义提交信息"
echo "4) 取消"
echo ""
read -p "请选择 [1-4]: " choice

case $choice in
    1)
        vimgit add .vim/plugged/
        commit_msg="Update vim plugins via :PlugUpdate"
        ;;
    2)
        vimgit add .vimrc .vim/*.vim
        commit_msg="Update vim configuration"
        ;;
    3)
        read -p "输入提交信息: " commit_msg
        vimgit add -u
        ;;
    4)
        echo "已取消"
        exit 0
        ;;
    *)
        echo -e "${RED}无效选择${NC}"
        exit 1
        ;;
esac

# 确认提交
echo ""
echo -e "${YELLOW}将要提交：${NC}"
vimgit status
echo ""
echo -e "${YELLOW}提交信息: ${commit_msg}${NC}"
read -p "确认提交并推送？(y/N) " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    vimgit commit -m "$commit_msg"
    vimgit push
    echo -e "${GREEN}✓ 提交成功并已推送到远程${NC}"
else
    echo "已取消"
    exit 0
fi
