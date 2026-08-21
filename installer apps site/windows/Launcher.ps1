# ==========================================
# MyInstaller Launcher
# ==========================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Url
)


$ErrorActionPreference = "Stop"


# ------------------------------------------
# CHECK PROTOCOL
# ------------------------------------------

if (-not $Url.StartsWith("myinstaller://")) {

    Write-Host "Invalid MyInstaller URL." -ForegroundColor Red

    exit 1
}


# ------------------------------------------
# GET APPS
# ------------------------------------------

$uri = [System.Uri]$Url


$query = $uri.Query


if ($query.StartsWith("?")) {

    $query = $query.Substring(1)

}


$parameters = @{}


foreach ($item in $query.Split("&")) {

    if ($item -match "=") {

        $parts = $item.Split("=", 2)

        $key = [System.Uri]::UnescapeDataString($parts[0])

        $value = [System.Uri]::UnescapeDataString($parts[1])

        $parameters[$key] = $value

    }

}


if (-not $parameters.ContainsKey("apps")) {

    Write-Host "No applications selected." -ForegroundColor Red

    exit 1
}


# ------------------------------------------
# DECODE APPLICATIONS
# ------------------------------------------

$appsString = $parameters["apps"]


$apps = $appsString.Split(",")


if ($apps.Count -eq 0) {

    Write-Host "No applications selected." -ForegroundColor Red

    exit 1
}


# ------------------------------------------
# SAVE SELECTION
# ------------------------------------------

$installerFolder = $PSScriptRoot


$configPath =
    Join-Path $installerFolder "selection.json"


$config = @{
    programs = @($apps)
    created = (Get-Date).ToString("o")
}


$config |
    ConvertTo-Json |
    Set-Content `
        -Path $configPath `
        -Encoding UTF8


# ------------------------------------------
# START INSTALLER
# ------------------------------------------

$installer = Join-Path `
    $installerFolder `
    "MyInstaller.ps1"


if (-not (Test-Path $installer)) {

    Write-Host "MyInstaller.ps1 not found." -ForegroundColor Red

    exit 1
}


Start-Process `
    powershell.exe `
    -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        "`"$installer`""
    )