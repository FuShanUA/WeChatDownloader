# WeChatDownloader Windows 测试包

这是一个测试版 Windows 包，用于验证视频号捕获和直播录制链路。

## 安装依赖

1. 安装 Python 3.11 或 3.12。
2. 安装 Node.js LTS。
3. 安装 ffmpeg，并确保 `ffmpeg.exe` 在 `PATH` 中。
4. 在 Python 环境中安装 mitmproxy：

```powershell
python -m pip install --upgrade mitmproxy
```

也可以直接运行包里的 `install_windows_dependencies.ps1`。

## 运行

1. 解压测试包。
2. 双击 `WeChatDownloader.exe`。
3. 首次运行会生成 mitmproxy 证书。
4. 打开 Windows 证书管理器，导入：

```text
%USERPROFILE%\.mitmproxy\mitmproxy-ca-cert.cer
```

5. 将证书放入“受信任的根证书颁发机构”，并信任它。
6. 完全退出微信后重新打开微信，再进入视频号页面。

## 测试点

- 捕获队列是否能出现视频号内容。
- 点播下载和解密是否可用。
- 直播列表是否能显示当前频道。
- 右侧直播预览是否能播放。
- 直播录制停止后是否生成 MP4。

## 数据位置

- 捕获记录：`%APPDATA%\OpenXiaZai\wechat-captures.jsonl`
- 捕获 token：`%APPDATA%\OpenXiaZai\wechat_capture_token`
- 解密组件：`%APPDATA%\OpenXiaZai\vendor\wechat_files\raw`
- 下载文件：`%USERPROFILE%\Downloads\OpenXiaZai\WeChatChannels`
- 运行日志：`%APPDATA%\OpenXiaZai\wechat_downloader.log`
