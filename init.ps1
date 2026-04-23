# PokePilot Initialization Script (PowerShell)
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PokePilot Init Script" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# 1. Install Python dependencies
Write-Host "[1/7] Installing Python dependencies..." -ForegroundColor Cyan
pip install -r requirements.txt
Write-Host "OK: Dependencies installed" -ForegroundColor Green
Write-Host ""

# 2. Clone api-data repository
Write-Host "[2/7] Cloning api-data repository..." -ForegroundColor Cyan
if (Test-Path "api-data") {
    Write-Host "api-data exists, skipping clone"
} else {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/api-data.git
}
Write-Host ""

# 3. Setup api-data sparse checkout
Write-Host "[3/7] Setting up api-data sparse checkout..." -ForegroundColor Cyan
Push-Location "api-data"
git sparse-checkout add data/api/v2
Pop-Location
Write-Host "OK: api-data setup complete" -ForegroundColor Green
Write-Host ""

# 4. Clone sprites repository
Write-Host "[4/7] Cloning sprites repository..." -ForegroundColor Cyan
if (Test-Path "sprites") {
    Write-Host "sprites exists, skipping clone"
} else {
    git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/sprites.git sprites
}
Write-Host ""

# 5. Setup sprites sparse checkout
Write-Host "[5/7] Setting up sprites sparse checkout..." -ForegroundColor Cyan
Push-Location "sprites"
git sparse-checkout add sprites/types/generation-ix/scarlet-violet
Pop-Location
Write-Host "OK: sprites setup complete" -ForegroundColor Green
Write-Host ""

# 6. Download sprites
Write-Host "[6/7] Downloading sprites..." -ForegroundColor Cyan
python -m pokepilot.data.download_sprites
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Online download failed" -ForegroundColor Yellow
    if (Test-Path "sprites.rar") {
        Write-Host "Found sprites.rar - please extract manually:" -ForegroundColor Yellow
        Write-Host "  Right-click sprites.rar > Extract to sprites/" -ForegroundColor Yellow
        Write-Host "  OR use: Expand-Archive sprites.rar -DestinationPath sprites" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press Enter after extraction to continue..."
        Read-Host | Out-Null
    } else {
        Write-Host "ERROR: Download failed and sprites.rar not found" -ForegroundColor Red
        Write-Host "Solutions:" -ForegroundColor Yellow
        Write-Host "1. Check network connection" -ForegroundColor Yellow
        Write-Host "2. Place sprites.rar in project root and re-run script" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "OK: Sprites downloaded" -ForegroundColor Green
}
Write-Host ""

# 7. Initialize database
Write-Host "[7/7] Initializing database..." -ForegroundColor Cyan
python -m pokepilot.data.build_pikalytics
python -m pokepilot.data.pokedb --all
Write-Host "OK: Database initialized" -ForegroundColor Green
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "OK: Initialization complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
