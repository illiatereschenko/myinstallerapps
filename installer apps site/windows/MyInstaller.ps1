# ==========================================
# MyInstaller Windows Installer
# ==========================================

$ErrorActionPreference = "Continue"

$InstallLog = "$env:TEMP\MyInstaller.log"

Start-Transcript -Path $InstallLog -Append

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "          MYINSTALLER" -ForegroundColor Cyan
Write-Host "       Windows Software Installer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# CHECK WINGET
# ------------------------------------------

$winget = Get-Command winget -ErrorAction SilentlyContinue

if (-not $winget) {

    Write-Host "ERROR: winget was not found." -ForegroundColor Red

    Write-Host ""
    Write-Host "Please install/update App Installer from Microsoft Store."
    Write-Host ""

    Read-Host "Press Enter to exit"

    Stop-Transcript

    exit 1
}


# ------------------------------------------
# CONFIG FILE
# ------------------------------------------

$configPath = Join-Path $PSScriptRoot "selection.json"


if (-not (Test-Path $configPath)) {

    Write-Host "ERROR: selection.json was not found." -ForegroundColor Red

    Read-Host "Press Enter to exit"

    Stop-Transcript

    exit 1
}


# ------------------------------------------
# READ CONFIG
# ------------------------------------------

try {

    $config = Get-Content $configPath -Raw |
        ConvertFrom-Json

}
catch {

    Write-Host "ERROR: Invalid selection.json" -ForegroundColor Red

    Read-Host "Press Enter to exit"

    Stop-Transcript

    exit 1
}


$programs = $config.programs


if (-not $programs -or $programs.Count -eq 0) {

    Write-Host "No programs selected." -ForegroundColor Yellow

    Read-Host "Press Enter to exit"

    Stop-Transcript

    exit 0
}


# ------------------------------------------
# PROGRAM DATABASE
# ------------------------------------------

$apps = @{

    "Google Chrome" = @{
        Id = "Google.Chrome"
        Name = "Google Chrome"
    }

    "Mozilla Firefox" = @{
        Id = "Mozilla.Firefox"
        Name = "Mozilla Firefox"
    }

    "Microsoft Edge" = @{
        Id = "Microsoft.Edge"
        Name = "Microsoft Edge"
    }


    "Transmission" = @{
        Id = "Transmission.Transmission"
        Name = "Transmission"
    }

    "uTorrent" = @{
        Id = "BitTorrent.uTorrent"
        Name = "uTorrent"
    }


    "Everything" = @{
        Id = "voidtools.Everything"
        Name = "Everything"
    }

    "KeePass" = @{
        Id = "KeePassXCTeam.KeePassXC"
        Name = "KeePass"
    }

    "Evernote" = @{
        Id = "Evernote.Evernote"
        Name = "Evernote"
    }


    "Viber" = @{
        Id = "Viber.Viber"
        Name = "Viber"
    }

    "WhatsApp" = @{
        Id = "WhatsApp.WhatsApp"
        Name = "WhatsApp"
    }

    "Telegram" = @{
        Id = "Telegram.TelegramDesktop"
        Name = "Telegram"
    }

    "Zoom" = @{
        Id = "Zoom.Zoom"
        Name = "Zoom"
    }

    "Discord" = @{
        Id = "Discord.Discord"
        Name = "Discord"
    }

    "Thunderbird" = @{
        Id = "Mozilla.Thunderbird"
        Name = "Thunderbird"
    }


    "Google Drive" = @{
        Id = "Google.GoogleDrive"
        Name = "Google Drive"
    }

    "Dropbox" = @{
        Id = "Dropbox.Dropbox"
        Name = "Dropbox"
    }

    "OneDrive" = @{
        Id = "Microsoft.OneDrive"
        Name = "OneDrive"
    }


    "7-Zip" = @{
        Id = "7zip.7zip"
        Name = "7-Zip"
    }

    "WinRAR" = @{
        Id = "RARLab.WinRAR"
        Name = "WinRAR"
    }


    "iTunes" = @{
        Id = "Apple.iTunes"
        Name = "iTunes"
    }

    "VLC Media Player" = @{
        Id = "VideoLAN.VLC"
        Name = "VLC Media Player"
    }

    "AIMP" = @{
        Id = "AIMP.AIMP"
        Name = "AIMP"
    }

    "Audacity" = @{
        Id = "Audacity.Audacity"
        Name = "Audacity"
    }

    "K-Lite Codec Pack" = @{
        Id = "CodecGuide.K-LiteCodecPack.Full"
        Name = "K-Lite Codec Pack"
    }

    "Spotify" = @{
        Id = "Spotify.Spotify"
        Name = "Spotify"
    }


    "VC Redist x64 2015+" = @{
        Id = "Microsoft.VCRedist.2015+.x64"
        Name = "VC Redist x64 2015+"
    }

    "VC Redist x86 2015+" = @{
        Id = "Microsoft.VCRedist.2015+.x86"
        Name = "VC Redist x86 2015+"
    }


    "Blender" = @{
        Id = "BlenderFoundation.Blender"
        Name = "Blender"
    }

    "Paint.NET" = @{
        Id = "dotPDN.PaintDotNet"
        Name = "Paint.NET"
    }

    "GIMP" = @{
        Id = "GIMP.GIMP"
        Name = "GIMP"
    }

    "IrfanView" = @{
        Id = "IrfanSkiljan.IrfanView"
        Name = "IrfanView"
    }

    "Inkscape" = @{
        Id = "Inkscape.Inkscape"
        Name = "Inkscape"
    }

    "FastStone" = @{
        Id = "FastStone.Viewer"
        Name = "FastStone"
    }


    "AnyDesk" = @{
        Id = "AnyDesk.AnyDesk"
        Name = "AnyDesk"
    }

    "TeamViewer" = @{
        Id = "TeamViewer.TeamViewer"
        Name = "TeamViewer"
    }

    "ImgBurn" = @{
        Id = "LIGHTNINGUK.ImgBurn"
        Name = "ImgBurn"
    }

    "RealVNC Server" = @{
        Id = "RealVNC.VNCServer"
        Name = "RealVNC Server"
    }

    "RealVNC Viewer" = @{
        Id = "RealVNC.VNCViewer"
        Name = "RealVNC Viewer"
    }

    "CDBurnerXP" = @{
        Id = "CanneverbeLimited.CDBurnerXP"
        Name = "CDBurnerXP"
    }

    "Revo Uninstaller" = @{
        Id = "RevoUninstaller.RevoUninstaller"
        Name = "Revo Uninstaller"
    }

    "WizTree" = @{
        Id = "AntibodySoftware.WizTree"
        Name = "WizTree"
    }

    "CCleaner" = @{
        Id = "Piriform.CCleaner"
        Name = "CCleaner"
    }

    "LibreOffice" = @{
        Id = "TheDocumentFoundation.LibreOffice"
        Name = "LibreOffice"
    }


    "Python" = @{
        Id = "Python.Python.3.13"
        Name = "Python"
    }

    "Git" = @{
        Id = "Git.Git"
        Name = "Git"
    }

    "Notepad++" = @{
        Id = "Notepad++.Notepad++"
        Name = "Notepad++"
    }

    "Visual Studio Code" = @{
        Id = "Microsoft.VisualStudioCode"
        Name = "Visual Studio Code"
    }
}


# ------------------------------------------
# INSTALL
# ------------------------------------------

$total = $programs.Count

$current = 0

$successful = 0

$failed = 0


foreach ($program in $programs) {

    $current++

    Write-Host ""
    Write-Host "------------------------------------------"
    Write-Host "[$current/$total] $program" -ForegroundColor Cyan
    Write-Host "------------------------------------------"


    if (-not $apps.ContainsKey($program)) {

        Write-Host "Unknown program: $program" -ForegroundColor Red

        $failed++

        continue
    }


    $app = $apps[$program]

    $id = $app.Id


    Write-Host "Package ID: $id"

    Write-Host "Installing..." -ForegroundColor Yellow


    try {

        & winget install `
            --id $id `
            --exact `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements `
            --disable-interactivity


        if ($LASTEXITCODE -eq 0) {

            Write-Host ""
            Write-Host "SUCCESS: $program installed." -ForegroundColor Green

            $successful++

        }
        else {

            Write-Host ""
            Write-Host "FAILED: $program" -ForegroundColor Red

            $failed++

        }

    }
    catch {

        Write-Host ""
        Write-Host "ERROR: $program" -ForegroundColor Red

        $failed++

    }

}


# ------------------------------------------
# FINISH
# ------------------------------------------

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "             INSTALLATION DONE" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""

Write-Host "Successful: $successful" -ForegroundColor Green

Write-Host "Failed:     $failed" -ForegroundColor Red

Write-Host "Total:      $total"

Write-Host ""

Write-Host "Log:"
Write-Host $InstallLog

Write-Host ""

Remove-Item $configPath -Force -ErrorAction SilentlyContinue

Stop-Transcript

Read-Host "Press Enter to close"