param(
    [switch]$SkipDependencyInstall
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Exe = Join-Path $Root "WeChatDownloader.exe"

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-Package {
    param([string]$Id)
    winget install --id $Id --exact --accept-source-agreements --accept-package-agreements
    Refresh-Path
}

Write-Host "=== WeChatDownloader 一键安装 ===" -ForegroundColor Green

if (-not (Test-Path $Exe)) {
    throw "找不到 WeChatDownloader.exe，请确认压缩包已完整解压。"
}

if (-not $SkipDependencyInstall) {
    if (-not (Test-Command "winget")) {
        throw "未找到 winget。请先安装 App Installer，然后重新运行本脚本。"
    }

    if (-not (Test-Command "python")) {
        Write-Host "安装 Python 3.12..." -ForegroundColor Cyan
        Install-Package "Python.Python.3.12"
    }

    if (-not (Test-Command "node")) {
        Write-Host "安装 Node.js LTS..." -ForegroundColor Cyan
        Install-Package "OpenJS.NodeJS.LTS"
    }

    if (-not (Test-Command "ffmpeg")) {
        Write-Host "安装 ffmpeg..." -ForegroundColor Cyan
        Install-Package "Gyan.FFmpeg"
    }
}

Refresh-Path

if (-not (Test-Command "mitmdump")) {
    Write-Host "安装 mitmproxy..." -ForegroundColor Cyan
    python -m pip install --upgrade mitmproxy
    Refresh-Path
}

Refresh-Path

foreach ($name in @("python", "node", "ffmpeg", "mitmdump")) {
    if (-not (Test-Command $name)) {
        throw "依赖安装后仍未找到 $name。请重新打开本脚本再试。"
    }
}

$CertPath = Join-Path $env:USERPROFILE ".mitmproxy\mitmproxy-ca-cert.cer"

if (-not (Test-Path $CertPath)) {
    Write-Host "启动一次应用以生成证书..." -ForegroundColor Cyan
    if (-not (Get-Process "WeChatDownloader" -ErrorAction SilentlyContinue)) {
        Start-Process -FilePath $Exe -WorkingDirectory $Root
    }

    $deadline = (Get-Date).AddSeconds(30)
    while (-not (Test-Path $CertPath) -and (Get-Date) -lt $deadline) {
        Start-Sleep -Milliseconds 500
    }
}

if (-not (Test-Path $CertPath)) {
    throw "证书生成超时。请先双击 WeChatDownloader.exe，再重新运行本脚本。"
}

Write-Host "导入 mitmproxy 证书..." -ForegroundColor Cyan
Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\CurrentUser\Root" | Out-Null

$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "WeChatDownloader.lnk"
if (-not (Test-Path $ShortcutPath)) {
    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $Exe
    $Shortcut.WorkingDirectory = $Root
    $Shortcut.Save()
}

Write-Host ""
Write-Host "安装完成。" -ForegroundColor Green
Write-Host "请完全退出微信后重新打开，再双击桌面上的 WeChatDownloader 启动。"
