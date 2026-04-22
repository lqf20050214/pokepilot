#!/bin/bash
set -e

echo "=========================================="
echo "PokePilot 初始化脚本"
echo "=========================================="
echo ""

# 1. 安装Python依赖
echo "[1/7] 安装Python依赖..."
pip install -r requirements.txt
echo "✓ 依赖安装完成"
echo ""

# 2. 克隆 api-data 仓库
echo "[2/7] 克隆 api-data 仓库..."
if [ -d "api-data" ]; then
    echo "api-data 目录已存在，跳过克隆"
else
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/api-data.git
fi
echo ""

# 3. 设置 api-data sparse checkout
echo "[3/7] 设置 api-data sparse checkout..."
cd api-data
git sparse-checkout add data/api/v2
cd ..
echo "✓ api-data 设置完成"
echo ""

# 4. 克隆 sprites 仓库
echo "[4/7] 克隆 sprites 仓库..."
if [ -d "sprites" ]; then
    echo "sprites 目录已存在，跳过克隆"
else
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/sprites.git sprites
fi
echo ""

# 5. 设置 sprites sparse checkout
echo "[5/7] 设置 sprites sparse checkout..."
cd sprites
git sparse-checkout add sprites/types/generation-ix/scarlet-violet
cd ..
echo "✓ sprites 设置完成"
echo ""

# 6. 下载精灵图片
echo "[6/7] 下载精灵图片..."
python -m pokepilot.data.download_sprites
echo "✓ 精灵图片下载完成"
echo ""

# 7. 构建数据库
echo "[7/7] 构建数据库..."
python -m pokepilot.data.build_roster
python -m pokepilot.data.build_pikalytics
python -m pokepilot.data.pokedb --all
echo "✓ 数据库构建完成"
echo ""

echo "=========================================="
echo "✓ 初始化完成！"
echo "=========================================="
