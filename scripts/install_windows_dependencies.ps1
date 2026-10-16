param(
    [switch]$SkipWinget
)

$ErrorActionPreference = "Stop"

if (-not $SkipWinget) {
    winget install --id Python.Python.3.12 --exact --accept-source-agreements --accept-package-agreements
    winget install --id OpenJS.NodeJS.LTS --exact --accept-source-agreements --accept-package-agreements
    winget install --id Gyan.FFmpeg --exact --accept-source-agreements --accept-package-agreements
}

python -m pip install --upgrade mitmproxy

Write-Host ""
Write-Host "Dependencies installed. Open a new terminal so PATH changes take effect."
