@echo off
chcp 65001 >nul
setlocal EnableExtensions

set "ROOT=%~dp0"
set "EXE=%ROOT%WeChatDownloader.exe"
set "CERT=%USERPROFILE%\.mitmproxy\mitmproxy-ca-cert.cer"

echo === WeChatDownloader 一键安装 ===

if not exist "%EXE%" (
    echo 找不到 WeChatDownloader.exe，请确认压缩包已完整解压。
    pause
    exit /b 1
)

where winget >nul 2>nul
if errorlevel 1 (
    echo 未找到 winget。请先安装 App Installer，然后重新运行本脚本。
    pause
    exit /b 1
)

where python >nul 2>nul
if errorlevel 1 (
    echo 安装 Python 3.12...
    winget install --id Python.Python.3.12 --exact --accept-source-agreements --accept-package-agreements
)

where node >nul 2>nul
if errorlevel 1 (
    echo 安装 Node.js LTS...
    winget install --id OpenJS.NodeJS.LTS --exact --accept-source-agreements --accept-package-agreements
)

where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo 安装 ffmpeg...
    winget install --id Gyan.FFmpeg --exact --accept-source-agreements --accept-package-agreements
)

for /f "usebackq delims=" %%P in (`powershell -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')"`) do set PATH=%%P

where python >nul 2>nul
if errorlevel 1 (
    echo Python 安装后仍未找到。请重新打开本脚本再试。
    pause
    exit /b 1
)

where node >nul 2>nul
if errorlevel 1 (
    echo Node.js 安装后仍未找到。请重新打开本脚本再试。
    pause
    exit /b 1
)

where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo ffmpeg 安装后仍未找到。请重新打开本脚本再试。
    pause
    exit /b 1
)

where mitmdump >nul 2>nul
if errorlevel 1 (
    echo 安装 mitmproxy...
    python -m pip install --upgrade mitmproxy
)

where mitmdump >nul 2>nul
if errorlevel 1 (
    echo mitmproxy 安装失败。请把日志发送给开发者。
    pause
    exit /b 1
)

if exist "%CERT%" goto importcert

echo 启动一次应用以生成证书...
start "" "%EXE%"

set /a TRIES=0

:waitcert
if exist "%CERT%" goto importcert
set /a TRIES+=1
if %TRIES% geq 60 goto certfail
timeout /t 1 /nobreak >nul
goto waitcert

:certfail
echo 证书生成超时。请先双击 WeChatDownloader.exe，再重新运行本脚本。
pause
exit /b 1

:importcert
echo 导入 mitmproxy 证书...
certutil -user -addstore Root "%CERT%" >nul
if errorlevel 1 (
    echo 证书导入失败。请右键本脚本，选择“以管理员身份运行”再试一次。
    pause
    exit /b 1
)

powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\WeChatDownloader.lnk');$s.TargetPath='%EXE%';$s.WorkingDirectory='%ROOT%';$s.Save()"

echo.
echo 安装完成。
echo 请完全退出微信后重新打开，再双击桌面上的 WeChatDownloader 启动。
pause
