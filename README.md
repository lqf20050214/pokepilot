# PokePilot

A comprehensive Pokémon data management and analysis tool built with Python.

## Prerequisites

- Python 3.7+
- Git
- 2GB+ disk space for Pokémon data

## Installation

### 1. Clone the Main Repository

```bash
git clone <this-repo-url>
cd pokepilot
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

## Data Setup

### Clone PokeAPI Data (Required)

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/api-data.git
cd api-data
git sparse-checkout add data/api/v2
cd ..
```

### Clone Pokémon Sprites (Required)

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/PokeAPI/sprites.git sprites
cd sprites
git sparse-checkout add sprites/types/generation-ix/scarlet-violet
cd ..
```

## Usage

### Step 1: Download Sprites

```bash
python -m pokepilot.data.download_sprites
```

This command downloads Pokémon sprites from the cloned repositories.

### Step 2: Build Roster

```bash
python -m pokepilot.data.build_roster
```

This command builds the Pokémon roster database.

### Step 3: Initialize PokeDB

```bash
python -m pokepilot.pokedb --all
```

This command initializes the Pokémon database with all data.

### Step 4: Launch UI Server

```bash
python -m pokepilot.tools.ui_server
```

This command starts the web UI server. Access it via your web browser (typically at `http://localhost:5000`).

## Project Structure

```
pokepilot/
├── common/           # Core Pokémon data models and utilities
├── config/           # Configuration files (regions, settings)
├── data/             # Data processing and management modules
│   ├── download_sprites.py
│   ├── build_roster.py
│   └── pokedb.py
├── tools/            # Tools and utilities
│   └── ui_server.py
├── api-data/         # PokeAPI data (sparse checkout)
└── sprites/          # Pokémon sprites (sparse checkout)
```

## Features

- Download and manage Pokémon sprites
- Build comprehensive Pokémon roster database
- Web-based UI for browsing Pokémon data
- Support for multiple generations and regions

## Requirements

See `requirements.txt` for detailed dependencies:
- opencv-python >= 4.9.0
- numpy >= 1.26.0

## License

Please refer to the PokeAPI license terms for data usage.

## Contributing

Feel free to submit issues and pull requests!
