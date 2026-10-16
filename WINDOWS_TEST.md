# WeChatDownloader Windows 测试包

这是一个测试版 Windows 包，用于验证视频号捕获和直播录制链路。

## 傻瓜式安装

1. 解压测试包。
2. 双击 `1-一键安装.bat`。
3. 等待安装完成。
4. 完全退出微信后重新打开。
5. 双击桌面上的 `WeChatDownloader`，或运行 `2-启动 WeChatDownloader.bat`。

不需要打开终端，也不需要手动输入命令。

`1-一键安装.bat` 会自动完成：

- 安装 Python
- 安装 Node.js
- 安装 ffmpeg
- 安装 mitmproxy
- 生成并导入 mitmproxy 证书
- 创建桌面快捷方式

如果 Windows 弹出安全确认，请选择“允许”或“是”。

如果安装失败，可以右键 `1-一键安装.bat`，选择“以管理员身份运行”再试一次。

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
