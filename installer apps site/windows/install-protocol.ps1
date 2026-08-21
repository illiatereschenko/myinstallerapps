# ==========================================
# MyInstaller Protocol Installer
# ==========================================

$ErrorActionPreference = "Stop"


$installerFolder = $PSScriptRoot


$launcher = Join-Path `
    $installerFolder `
    "MyInstallerLauncher.ps1"


if (-not (Test-Path $launcher)) {

    Write-Host ""
    Write-Host "MyInstallerLauncher.ps1 not found!" -ForegroundColor Red
    Write-Host ""

    Read-Host "Press Enter to exit"

    exit 1
}


# ------------------------------------------
# REGISTRY PATH
# ------------------------------------------

$protocolPath =
    "HKCU:\Software\Classes\myinstaller"


# ------------------------------------------
# CREATE PROTOCOL
# ------------------------------------------

New-Item `
    -Path $protocolPath `
    -Force |
    Out-Null


Set-ItemProperty `
    -Path $protocolPath `
    -Name "(Default)" `
    -Value "URL:MyInstaller Protocol"


Set-ItemProperty `
    -Path $protocolPath `
    -Name "URL Protocol" `
    -Value ""


# ------------------------------------------
# SHELL
# ------------------------------------------

$commandPath =
    "$protocolPath\shell\open\command"


New-Item `
    -Path $commandPath `
    -Force |
    Out-Null


$command = @"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$launcher" "%1"
"@


Set-ItemProperty `
    -Path $commandPath `
    -Name "(Default)" `
    -Value $command


# ------------------------------------------
# DONE
# ------------------------------------------

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "       MYINSTALLER INSTALLED" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Protocol:"
Write-Host "myinstaller://"

Write-Host ""

Write-Host "You can now use the MyInstaller website."

Write-Host ""

Read-Host "Press Enter to close"