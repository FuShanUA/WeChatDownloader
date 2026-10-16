#!/usr/bin/env python3
"""Build the standalone Windows WeChatDownloader executable."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parent
DIST = ROOT / "dist"
BUILD = ROOT / "build" / "wechat-app-windows"
ICON_PNG = ROOT / "assets" / "wechat_downloader_icon.png"
ICON_ICO = ROOT / "assets" / "wechat_downloader_icon.ico"


def make_icon() -> None:
    ICON_PNG.parent.mkdir(parents=True, exist_ok=True)
    if ICON_ICO.exists():
        return
    image = Image.open(ICON_PNG).convert("RGBA")
    image.save(
        ICON_ICO,
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
    )


def build_app() -> None:
    if sys.platform != "win32":
        raise RuntimeError("This builder must run on Windows")

    make_icon()
    DIST.mkdir(parents=True, exist_ok=True)
    BUILD.mkdir(parents=True, exist_ok=True)

    data_separator = ";" if sys.platform == "win32" else ":"
    command = [
        sys.executable,
        "-m",
        "PyInstaller",
        str(ROOT / "wechat_launcher.py"),
        "--noconfirm",
        "--clean",
        "--onefile",
        "--noconsole",
        "--name", "WeChatDownloader",
        "--icon", str(ICON_ICO),
        "--add-data", f"{ROOT / 'wechat_capture'}{data_separator}wechat_capture",
        "--collect-data", "webview",
        "--hidden-import", "webview.platforms.edgechromium",
        "--distpath", str(DIST),
        "--workpath", str(BUILD),
    ]
    subprocess.run(command, cwd=ROOT, check=True)

    executable = DIST / "WeChatDownloader.exe"
    if not executable.is_file():
        raise RuntimeError("Build failed: WeChatDownloader.exe is missing")
    print(f"Built: {executable}")


if __name__ == "__main__":
    build_app()
