# WeChatDownloader

WeChatDownloader 是一个 macOS 桌面应用，用于保存你在微信视频号中观看且有权保存的视频。它会通过本机 mitmproxy 捕获视频地址和解密参数，下载后自动解密为可播放的 MP4。

这不是微信官方产品，也没有复刻微信商标。请只下载自己有权保存的内容，并遵守所在地区的版权和平台规则。

## 功能

- 独立 macOS App，浅色界面，不依赖 OpenXiaZai 主程序
- 捕获当前正在播放的视频号内容
- 默认选择原片或最佳可用分辨率
- 显示下载进度、速度、已下载体积和预计剩余时间
- 下载完成后进入下载位置面板，可直接播放、在 Finder 中定位或用系统播放器打开
- 捕获 token 保存在本机，重启下载器后不需要重新注入旧页面

## 系统要求

- macOS 13 或更新版本，已在 Apple Silicon 上测试
- Homebrew 安装的依赖：

```bash
brew install mitmproxy node
```

App 内置 Python 运行时和界面代码。首次下载时会从微信官方 CDN 获取解密用的 WASM 组件，保存在你自己的用户目录中，仓库不会分发这些组件。

## 安装 Release 版

1. 打开 [Releases](../../releases) 页面。
2. 下载 `WeChatDownloader-macOS.zip`。
3. 解压后把 `WeChatDownloader.app` 拖到“应用程序”或桌面。
4. 首次打开时如果 Gatekeeper 提示无法验证开发者，请右键点击 App 并选择“打开”。

Release 使用 ad-hoc 签名，没有 Apple Developer ID 签名。朋友第一次打开时可能需要确认一次。

## 首次配置

1. 启动 `WeChatDownloader.app`。它会启动本机代理并创建 mitmproxy 证书。
2. 打开“钥匙串访问”，导入 `~/.mitmproxy/mitmproxy-ca-cert.pem`。
3. 双击证书，在“信任”部分选择“始终信任”。
4. 系统要求选择钥匙串时，选择 `login`。
5. 完全退出微信（`Cmd+Q`），再重新打开微信并进入视频号。
6. 播放一个视频，下载器的“注入”状态变为绿色后，列表会出现可下载内容。

“注入”指下载器把一小段捕获脚本插入微信视频号网页。微信把视频解密参数放在网页内部传递，这段脚本负责读取参数并回传给本机下载器。它只在本机代理链路中生效，不会修改微信安装包。

如果状态灯不亮，通常按顺序检查：

1. 下载器窗口顶部显示捕获服务正在运行。
2. mitmproxy 证书已经信任。
3. 微信是完全退出后重新打开的，视频号页面不是旧页面。
4. 播放视频后等待几秒，注入计数从 0 变为 1。

## 从源码构建

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python build_wechat_app.py
open dist/WeChatDownloader.app
```

构建脚本会生成图标、PyInstaller spec 和 `dist/WeChatDownloader.app`。

## 数据位置

- 捕获记录：`~/Library/Application Support/OpenXiaZai/wechat-captures.jsonl`
- 捕获 token：`~/Library/Application Support/OpenXiaZai/wechat_capture_token`
- 解密组件：`~/Library/Application Support/OpenXiaZai/vendor/wechat_files/raw`
- 下载文件：`~/Downloads/OpenXiaZai/WeChatChannels`
- 运行日志：`~/Library/Application Support/OpenXiaZai/wechat_downloader.log`

App 退出时会尝试恢复系统代理设置。如果 macOS 强制退出导致代理没有恢复，重新启动并正常退出一次 App 即可。

## 许可

源码使用 MIT License，见 [LICENSE](LICENSE)。微信、WeChat 和视频号相关商标归腾讯所有。
