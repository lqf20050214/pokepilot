# PokePilot 安装教程（Windows 小白版）

> 这份教程是写给**完全没用过命令行、Python**的朋友的。照着做就行。

---

## 第零步：你需要先装两样东西

### 0.1 安装 Python

1. 打开浏览器，访问 **https://www.python.org/downloads/**
2. 点击页面上大大的「**Download Python 3.xx**」按钮，下载安装包
3. 双击打开下载的 `.exe` 文件
4. **最关键的一步**：安装界面底部有一个复选框写着「**Add python.exe to PATH**」—— **一定要勾上！** 不勾的话后面全部会出错
5. 然后点「**Install Now**」，等安装完成，点「Close」

**怎么验证装好了？** 按键盘 `Win + R`，输入 `cmd`，回车。在弹出的黑色窗口里输入 `python --version`，回车。如果看到类似 `Python 3.12.x` 的文字，说明装好了。如果提示"不是内部命令"，说明没勾 PATH，需要卸载重装并勾上。

### 0.2 安装 Git

1. 访问 **https://git-scm.com/download/win**
2. 页面会自动开始下载，等它下完
3. 双击打开，安装过程中**一路点「Next」**，所有选项保持默认
4. 最后点「Install」→「Finish」

**怎么验证？** 重新打开命令行（`Win + R` → `cmd` → 回车），输入 `git --version`，看到版本号就行。

### 0.3 确认磁盘空间

PokePilot 需要大约 **2GB** 磁盘空间（主要是宝可梦的图片数据）。确保你要安装的盘有足够空间。

---

## 第一步：下载 PokePilot

1. 用浏览器打开 **https://github.com/haoanwang0829/pokepilot**
2. 点击页面上绿色的「**Code**」按钮
3. 在弹出的菜单里点「**Download ZIP**」
4. 下载完成后，找到这个 ZIP 文件（一般在"下载"文件夹里）
5. **右键** → 「**全部解压缩**」→ 选择解压到**桌面**
6. 解压完后你会在桌面看到一个文件夹，可能叫 `pokepilot-main`。把它**重命名**为 `pokepilot`（右键 → 重命名）

---

## 第二步：创建 Python 环境并安装依赖

1. 打开命令行：按 `Win + R` → 输入 `cmd` → 回车
2. 进入 pokepilot 文件夹：

```
cd Desktop\pokepilot
```

3. 创建一个专门给 PokePilot 用的 Python 虚拟环境：

```
python -m venv venv
```

> 这会在文件夹里创建一个叫 `venv` 的子文件夹，是 PokePilot 专属的"小房间"，不会影响电脑上的其他东西。

4. **激活环境**（非常重要！以后每次用 PokePilot 都要先运行这句）：

```
venv\Scripts\activate
```

> 成功后命令行最前面会出现 `(venv)` 字样，像这样：
> `(venv) C:\Users\你的用户名\Desktop\pokepilot>`

5. 安装 PokePilot 需要的依赖：

```
pip install -r requirements.txt
```

> 这一步会自动下载安装一堆工具包，可能需要几分钟，耐心等它跑完。

---

## 第三步：解压zip
解压 `sprites.zip`

---

## 第四步：启动 PokePilot！

输入：

```
python -m pokepilot.ui.ui_server
```

看到类似这样的输出就说明启动成功了：

```
 * Running on http://localhost:8765
```

打开浏览器，在地址栏输入 **http://localhost:8765** ，回车，就能看到 PokePilot 的界面了！

用完之后，回到命令行按 `Ctrl + C` 停止服务器。

---

## 以后每次使用（只需要 4 步）

1. 打开命令行：`Win + R` → `cmd` → 回车
2. 进入文件夹：`cd Desktop\pokepilot`
3. 激活环境：`venv\Scripts\activate`
4. 启动服务：`python -m pokepilot.ui.ui_server`

浏览器打开 **http://localhost:8765** 就行。

---

## 常见问题

### "python" 不是内部命令？

安装 Python 时没有勾选「Add python.exe to PATH」。卸载 Python 后重新安装，这次一定要勾上。

### 精灵图下载失败？

网络问题导致下载不了的话，可以找作者要一份 `sprites.rar` 离线包，放到 `pokepilot` 文件夹里，用解压软件（7-Zip 或 WinRAR）解压到当前文件夹即可。

### pip install 报错一大堆红字？

常见原因是 Python 版本太低。确保装的是 **Python 3.11 或更高版本**。可以输入 `python --version` 检查。

### 浏览器打开是空白页？

确保地址是 `http://localhost:8765`，注意是 **http** 不是 **https**。

### 提示端口被占用？

换一个端口：`python -m pokepilot.ui.ui_server --port 9000`，然后浏览器访问 `http://localhost:9000`。

---

## 名词小解释

| 词 | 意思 |
|---|---|
| **命令行 / CMD** | 黑色的打字窗口，输入命令让电脑做事 |
| **Python** | 一种编程语言，PokePilot 用它写的 |
| **venv** | Python 的"虚拟环境"，给 PokePilot 一个独立的小房间 |
| **pip** | Python 的"应用商店"，用来安装需要的工具 |
| **Git** | 下载代码和数据的工具 |
| **localhost** | "你自己的电脑"，PokePilot 在你电脑上开了一个小网站 |
| **端口 (port)** | 电脑上的"门牌号"，不同程序用不同的端口 |
