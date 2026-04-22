# PokePilot 初始化脚本 (PowerShell)
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PokePilot 初始化脚本" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# 1. 安装Python依赖
Write-Host "[1/7] 安装Python依赖..." -ForegroundColor Cyan
pip install -r requirements.txt
Write-Host "✓ 依赖安装完成" -ForegroundColor Green
Write-Host ""

# 2. 克隆 api-data 仓库
Write-Host "[2/7] 克隆 api-data 仓库..." -ForegroundColor Cyan
if (Test-Path "api-data") {
    Write-Host "api-data 目录已存在，跳过克隆"
} else {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/api-data.git
}
Write-Host ""

# 3. 设置 api-data sparse checkout
Write-Host "[3/7] 设置 api-data sparse checkout..." -ForegroundColor Cyan
Push-Location "api-data"
git sparse-checkout add data/api/v2
Pop-Location
Write-Host "✓ api-data 设置完成" -ForegroundColor Green
Write-Host ""

# 4. 克隆 sprites 仓库
Write-Host "[4/7] 克隆 sprites 仓库..." -ForegroundColor Cyan
if (Test-Path "sprites") {
    Write-Host "sprites 目录已存在，跳过克隆"
} else {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/sprites.git sprites
}
Write-Host ""

# 5. 设置 sprites sparse checkout
Write-Host "[5/7] 设置 sprites sparse checkout..." -ForegroundColor Cyan
Push-Location "sprites"
git sparse-checkout add sprites/types/generation-ix/scarlet-violet
Pop-Location
Write-Host "✓ sprites 设置完成" -ForegroundColor Green
Write-Host ""

# 6. 下载精灵图片
Write-Host "[6/7] 下载精灵图片..." -ForegroundColor Cyan
python -m pokepilot.data.download_sprites
Write-Host "✓ 精灵图片下载完成" -ForegroundColor Green
Write-Host ""

# 7. 构建数据库
Write-Host "[7/7] 构建数据库..." -ForegroundColor Cyan
python -m pokepilot.data.build_roster
python -m pokepilot.data.build_pikalytics
python -m pokepilot.data.pokedb --all
Write-Host "✓ 数据库构建完成" -ForegroundColor Green
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "✓ 初始化完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
