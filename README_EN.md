<p align="center">
  <a href="./README.md"><img alt="中文" src="https://img.shields.io/badge/🇨🇳_中文-Read-red?style=for-the-badge"></a>
  <a href="./README_EN.md"><img alt="English" src="https://img.shields.io/badge/🇺🇸_English-Current-blue?style=for-the-badge"></a>
</p>

# PokePilot Pokémon Champions Assistant

A local tool for Pokémon Champions-style battles: use a browser with a **capture card / webcam** feed to grab in-game UI screenshots, run **OCR and image recognition** to build **your team and the opponent’s team**, manage **multiple team slots**, and get **simplified damage range estimates** in the browser.

## Prerequisites

| Item | Notes |
|------|-------|
| **Python** | 3.11 or higher |
| **Git** | For cloning the repository |
| **Disk space** | **3GB+** recommended (Python dependencies + optional offline assets) |
| **Network** | Required to install dependencies; for offline setup, see [Optional: Offline Assets](#optional-offline-assets) below |

> Use **either Conda or venv** to isolate the Python environment from your system install.

Core battle data is already bundled in the repo (`data/champions_roster.json`, `data/pikalytics_cache.json`, `data/pokedb_cache.json`, etc.). **After cloning, you do not need to run `init.sh` / `init.ps1`.**

## Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/lqf20050214/pokepilot.git
cd pokepilot
```

### 2. Create a Virtual Environment

> If `sprites.rar` / `OCR模型.zip` are missing after clone, install [Git LFS](https://git-lfs.com/) and run `git lfs pull`.

**Conda (recommended):**

```bash
conda create -n pokepilot python=3.11
conda activate pokepilot
```

**venv:**

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS / Linux
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

You can start the app after this step. Dependencies include OpenCV, Flask, EasyOCR, and PyTorch; the first install may take a while.

## Start the Server

```bash
python -m pokepilot.ui.ui_server
```

Open in your browser: **http://localhost:8765**

The server listens on `0.0.0.0` by default, so other devices on your LAN can connect.

**Optional flags:**

```bash
python -m pokepilot.ui.ui_server --port 8080   # custom port
python -m pokepilot.ui.ui_server --debug       # debug mode
```

---

## Optional: Offline Assets

The repository root includes offline packages (hosted via **Git LFS**; install [Git LFS](https://git-lfs.com/) when cloning):

| File | Purpose |
|------|---------|
| `sprites.rar` | Champions menu sprites (opponent team detection) |
| `OCR模型.zip` | EasyOCR + ResNet50 weights (player OCR / sprite matching) |

If these files are missing after clone, run `git lfs pull`.

### Sprites — `sprites.rar`

Opponent detection needs Champions menu sprites under `sprites/champions/` and `sprites/champions_shiny/`.

**Offline (recommended — bundled in repo):**

1. Extract `sprites.rar` from the repository root
2. Confirm that `sprites/champions/` exists

   **Windows:** extract with 7-Zip / WinRAR into the `pokepilot` folder

   **macOS / Linux:**
   ```bash
   unrar x sprites.rar
   # or: 7z x sprites.rar
   ```

**Online (if you have network access):**

```bash
python -m pokepilot.data.download_sprites
```

### OCR and Image Recognition Models

**Offline (recommended — bundled in repo):**

Extract `OCR模型.zip` and place the files as follows:

| Purpose | Target path |
|---------|-------------|
| EasyOCR models | `~/.EasyOCR/model/` |
| ResNet50 weights | `~/.cache/torch/hub/checkpoints/` |

**Online:** models are downloaded automatically on first **player OCR** or **opponent team detection**.

> If OCR hangs on `Downloading:` and you see 0-byte `*.partial` files under `~/.cache/torch/`, you likely cannot reach the internet — extract `OCR模型.zip` or use a proxy.

---

## Usage

### Web UI Features

- **Capture card preview:** open the webcam in the browser and point it at the game feed
- **Save screenshots:** PNGs go to `screenshots/team/` (player) or `screenshots/opp_team/` (opponent)
- **Your team:** moves + stats screenshots → OCR draft → edit in browser → build → save to `data/my_team/`
- **Opponent team:** upload opponent screenshot → results written to `data/opp_team/temp.json`
- **Damage ranges:** click your move to estimate damage and HP% vs each opponent (simplified formula, level 50 baseline)
- **Layout tuning:** adjust `pokepilot/config/card_layout.json` and `opponent_team_layout.json` for different resolutions

### Refreshing Data for a New Season (Advanced)

When the battle format updates or new Pokémon are added, refresh local data as needed (**not required for daily use**):

```bash
python -m pokepilot.data.download_sprites   # update sprites
python -m pokepilot.data.build_roster       # update available Pokémon list
python -m pokepilot.data.build_pikalytics   # update opponent move/item/ability usage
```

To refresh move Chinese names, base stats, etc. in the PokeDB cache, clone [PokeAPI api-data](https://github.com/PokeAPI/api-data) and run `python -m pokepilot.data.pokedb --all`. If you already have `data/pokedb_cache.json`, you can usually skip this.

---

## Project Structure

```
pokepilot/
├── pokepilot/              # Python package
│   ├── common/             # data models, builder, sprite detection
│   ├── config/             # layout JSON (writable from web UI)
│   ├── data/               # data build scripts
│   ├── detect_team/        # player OCR / opponent detection
│   ├── ui/                 # Flask web server and frontend
│   └── tools/              # OCR engine and utilities
├── data/                   # bundled battle data and runtime cache
│   ├── champions_roster.json
│   ├── pikalytics_cache.json
│   ├── pokedb_cache.json
│   ├── my_team/            # player teams (generated at runtime)
│   └── opp_team/           # opponent teams (generated at runtime)
├── sprites.rar             # offline sprite pack (Git LFS)
├── OCR模型.zip             # offline OCR/ResNet model pack (Git LFS)
├── sprites/                # extracted sprites (not tracked)
├── screenshots/            # screenshot directory (generated at runtime)
├── requirements.txt
└── README.md
```

## FAQ

**Q: Do I still need to run `init.sh` / `init.ps1`?**  
A: No. The repo ships with core JSON data; clone, install dependencies, and start the server. The init scripts are only for rebuilding caches from PokeAPI from scratch (advanced users).

**Q: Opponent detection fails or returns nothing?**  
A: Make sure `sprites/champions/` exists. Run `download_sprites` online, or extract `sprites.rar` offline.

**Q: First OCR run is slow or stuck?**  
A: EasyOCR and ResNet50 are downloading models. See [Optional: Offline Assets](#optional-offline-assets) above.

**Q: How do I change the port?**  
A: `python -m pokepilot.ui.ui_server --port 9000`, then open `http://localhost:9000`.

**Q: How do I access the UI from another device on the LAN?**  
A: The server listens on `0.0.0.0` by default. On the same Wi-Fi, use `http://<your-ip>:8765`.

## Dependencies

See `requirements.txt`. Highlights:

- **opencv-python**, **numpy**, **pillow** — image processing
- **flask**, **flask-cors** — web server
- **easyocr** — player text OCR
- **torch**, **torchvision** — opponent sprite feature matching

## License

This project uses data from [PokeAPI](https://pokeapi.co/). Please respect their license terms.
