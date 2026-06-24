<p align="center">
  <a href="./README.md"><img alt="中文" src="https://img.shields.io/badge/🇨🇳_中文-当前-red?style=for-the-badge"></a>
  <a href="./README_EN.md"><img alt="English" src="https://img.shields.io/badge/🇺🇸_English-Read-blue?style=for-the-badge"></a>
</p>

# PokePilot 宝可梦冠军对战小助手

面向《宝可梦》冠军赛等对战场景的本地小工具：用浏览器配合**采集卡 / 摄像头画面**截取游戏 UI，通过 **OCR + 图像识别**生成己方与对方队伍数据，并在网页里做**队伍槽位管理**与**简化伤害区间估算**。

## 前置条件

| 项目 | 说明 |
|------|------|
| **Python** | 3.11 及以上 |
| **Git** | 用于克隆仓库 |
| **磁盘空间** | 建议预留 **3GB+**（Python 依赖 + 可选离线资源） |
| **网络** | 安装依赖时需要；若网络教程需要离线，见下文「可选：离线资源」 |

> **Conda 或 venv 二选一即可**，用于隔离 Python 环境，避免与系统 Python 冲突。

仓库已内置对战所需的核心数据（`data/champions_roster.json`、`data/pikalytics_cache.json`、`data/pokedb_cache.json` 等），**克隆后无需再运行 `init.sh` / `init.ps1` 做数据初始化**。

## 环境配置

### 1. 克隆仓库

```bash
git clone https://github.com/lqf20050214/pokepilot.git
cd pokepilot
```

### 2. 创建虚拟环境

> 克隆后若缺少 `sprites.rar` / `OCR模型.zip`，请先安装 [Git LFS](https://git-lfs.com/) 并执行 `git lfs pull`。

**Conda（推荐）：**

```bash
conda create -n pokepilot python=3.11
conda activate pokepilot
```

**venv：**

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS / Linux
source venv/bin/activate
```

### 3. 安装依赖

```bash
pip install -r requirements.txt
```

安装完成后即可启动。依赖主要包括 OpenCV、Flask、EasyOCR、PyTorch 等，首次安装体积较大，请耐心等待。

## 启动

```bash
python -m pokepilot.ui.ui_server
```

浏览器打开：**http://localhost:8765**

默认监听 `0.0.0.0`，局域网内其他设备也可访问。

**可选参数：**

```bash
python -m pokepilot.ui.ui_server --port 8080   # 指定端口
python -m pokepilot.ui.ui_server --debug       # 调试模式
```

---

## 可选：离线资源

仓库根目录已附带离线资源包（通过 **Git LFS** 托管，克隆时需安装 [Git LFS](https://git-lfs.com/)）：

| 文件 | 用途 |
|------|------|
| `sprites.rar` | Champions 菜单精灵图（对方队伍识别） |
| `OCR模型.zip` | EasyOCR + ResNet50 预训练权重（己方 OCR / 精灵图匹配） |

克隆后若看不到这两个文件，请先执行 `git lfs pull`。

### 精灵图 `sprites.rar`

对方队伍识别需要 `sprites/champions/` 与 `sprites/champions_shiny/` 下的 Champions 菜单精灵图。

**离线（推荐，仓库已附带）：**

1. 解压仓库根目录下的 `sprites.rar`
2. 确保出现 `sprites/champions/` 目录

   **Windows：** 用 7-Zip / WinRAR 解压到 `pokepilot` 文件夹

   **macOS / Linux：**
   ```bash
   unrar x sprites.rar
   # 或：7z x sprites.rar
   ```

**在线（有网络时，也可不用离线包）：**

```bash
python -m pokepilot.data.download_sprites
```

### OCR 与图像识别模型

**离线（推荐，仓库已附带）：**

解压 `OCR模型.zip`，将其中的文件分别放到：

| 用途 | 目标路径 |
|------|----------|
| EasyOCR 模型 | `~/.EasyOCR/model/` |
| ResNet50 权重 | `~/.cache/torch/hub/checkpoints/` |

**在线：** 首次进行**己方 OCR** 或**对方队伍识别**时，程序会自动下载模型。

> 若 OCR 长时间卡在 `Downloading:` 且 `~/.cache/torch/` 下出现大小为 0 的 `*.partial` 文件，通常是无法访问外网，请解压 `OCR模型.zip` 或配置代理。

---

## 使用说明

### 网页端功能

- **采集卡预览**：浏览器打开摄像头，对准采集卡上的游戏画面
- **截图入库**：保存 PNG 到 `screenshots/team/`（己方）或 `screenshots/opp_team/`（对方）
- **己方队伍**：技能页 + 能力页截图 → OCR 草稿 → 网页校对 → 构建 → 保存到 `data/my_team/`
- **对方队伍**：上传对方队伍截图 → 识别写入 `data/opp_team/temp.json`
- **伤害区间**：点击我方技能，估算对对方各宝可梦的伤害与血量百分比（简化公式，默认 50 级）
- **布局校准**：调整 `pokepilot/config/card_layout.json` 与 `opponent_team_layout.json`，适配不同分辨率

### 新赛季更新数据（进阶）

对战环境更新、新增宝可梦时，可按需刷新本地数据（**日常使用不必执行**）：

```bash
python -m pokepilot.data.download_sprites   # 更新精灵图
python -m pokepilot.data.build_roster       # 更新可用宝可梦名单
python -m pokepilot.data.build_pikalytics    # 更新对手常用技能/道具/特性
```

若需刷新招式中文名、种族值等 PokeDB 缓存，还需克隆 [PokeAPI api-data](https://github.com/PokeAPI/api-data) 后执行 `python -m pokepilot.data.pokedb --all`。已有 `data/pokedb_cache.json` 时，一般可跳过此步。

---

## 项目结构

```
pokepilot/
├── pokepilot/              # Python 包
│   ├── common/             # 数据模型、构建器、精灵识别
│   ├── config/             # 布局 JSON（可通过 Web 保存）
│   ├── data/               # 数据构建脚本
│   ├── detect_team/        # 己方 OCR / 对方队伍识别
│   ├── ui/                 # Flask Web 服务与前端
│   └── tools/              # OCR 引擎等工具
├── data/                   # 内置对战数据与运行时缓存
│   ├── champions_roster.json
│   ├── pikalytics_cache.json
│   ├── pokedb_cache.json
│   ├── my_team/            # 己方队伍（运行时生成）
│   └── opp_team/           # 对方队伍（运行时生成）
├── sprites.rar             # 离线精灵图包（Git LFS）
├── OCR模型.zip             # 离线 OCR/ResNet 模型包（Git LFS）
├── sprites/                # 解压后的精灵图（不入库）
├── screenshots/            # 截图目录（运行时生成）
├── requirements.txt
└── README.md
```

## 常见问题

**Q: 还需要运行 `init.sh` / `init.ps1` 吗？**  
A: 不需要。新版本仓库已自带核心 JSON 数据；克隆、装依赖、启动即可。`init` 脚本主要用于从零拉取 PokeAPI 数据并重建缓存，仅进阶用户需要。

**Q: 对方队伍识别报错或识别不出？**  
A: 确认 `sprites/champions/` 目录存在。可在线运行 `download_sprites`，或离线解压 `sprites.rar`。

**Q: 第一次 OCR 很慢或卡住？**  
A: EasyOCR 与 ResNet50 正在下载模型，见上文「可选：离线资源」。

**Q: 如何修改端口？**  
A: `python -m pokepilot.ui.ui_server --port 9000`，浏览器访问 `http://localhost:9000`。

**Q: 如何在局域网其他设备访问？**  
A: 服务默认监听 `0.0.0.0`，在同一 Wi-Fi 下用 `http://<本机IP>:8765` 访问即可。

## 依赖项

详见 `requirements.txt`，主要包括：

- **opencv-python**、**numpy**、**pillow** — 图像处理
- **flask**、**flask-cors** — Web 服务
- **easyocr** — 己方文字 OCR
- **torch**、**torchvision** — 对方精灵图特征匹配

## 许可证

本项目使用的数据来自 [PokeAPI](https://pokeapi.co/)，请遵守其许可条款。


