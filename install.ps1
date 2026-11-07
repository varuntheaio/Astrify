# Astrify CLI Installer
# Developed by Varq
# Discord: http://discord.gg/astria

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#region Variables
$astrifyFolderPath = "$env:LOCALAPPDATA\astrify"
$spicetifyFolderPath = "$env:LOCALAPPDATA\spicetify"
$astrifyOldFolderPath = "$HOME\astrify-cli"
#endregion Variables

#region Functions
function Write-Success {
  [CmdletBinding()]
  param ()
  process {
    Write-Host -Object ' > OK' -ForegroundColor 'Green'
  }
}

function Write-Unsuccess {
  [CmdletBinding()]
  param ()
  process {
    Write-Host -Object ' > ERROR' -ForegroundColor 'Red'
  }
}

function Test-Admin {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object "Checking if the script is not being run as administrator..." -NoNewline
  }
  process {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    -not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
}

function Test-PowerShellVersion {
  [CmdletBinding()]
  param ()
  begin {
    $PSMinVersion = [version]'5.1'
  }
  process {
    Write-Host -Object 'Checking if your PowerShell version is compatible...' -NoNewline
    $PSVersionTable.PSVersion -ge $PSMinVersion
  }
}

function Move-OldAstrifyFolder {
  [CmdletBinding()]
  param ()
  process {
    if (Test-Path -Path $astrifyOldFolderPath) {
      Write-Host -Object 'Moving the old astrify folder...' -NoNewline
      Copy-Item -Path "$astrifyOldFolderPath\*" -Destination $astrifyFolderPath -Recurse -Force
      Remove-Item -Path $astrifyOldFolderPath -Recurse -Force
      Write-Success
    }
  }
}

function Get-Astrify {
  [CmdletBinding()]
  param ()
  begin {
    if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
      $architecture = 'x64'
    }
    elseif ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
      $architecture = 'arm64'
    }
    else {
      $architecture = 'x32'
    }
    if ($v) {
      if ($v -match '^\d+\.\d+\.\d+$') {
        $targetVersion = $v
      }
      else {
        Write-Warning -Message "You have specified an invalid astrify version: $v `nThe version must be in the following format: 1.2.3"
        Pause
        exit
      }
    }
    else {
      Write-Host -Object 'Fetching the latest astrify version...' -NoNewline
      $latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/astrify/cli/releases/latest'
      $targetVersion = $latestRelease.tag_name -replace 'v', ''
      Write-Success
    }
    $archivePath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "astrify.zip")
  }
  process {
    Write-Host -Object "Downloading astrify v$targetVersion..." -NoNewline
    $Parameters = @{
      Uri            = "https://github.com/astrify/cli/releases/download/v$targetVersion/astrify-$targetVersion-windows-$architecture.zip"
      UseBasicParsin = $true
      OutFile        = $archivePath
    }
    Invoke-WebRequest @Parameters
    Write-Success
  }
  end {
    $archivePath
  }
}

function Add-AstrifyToPath {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object 'Making astrify available in the PATH...' -NoNewline
    $user = [EnvironmentVariableTarget]::User
    $path = [Environment]::GetEnvironmentVariable('PATH', $user)
  }
  process {
    $path = $path -replace "$([regex]::Escape($astrifyOldFolderPath))\\*;*", ''
    if ($path -notlike "*$astrifyFolderPath*") {
      $path = "$path;$astrifyFolderPath"
    }
  }
  end {
    [Environment]::SetEnvironmentVariable('PATH', $path, $user)
    if (($env:PATH -split ';') -notcontains $astrifyFolderPath) {
      $env:PATH = "$env:PATH;$astrifyFolderPath"
    }
    Write-Success
  }
}

function Install-Astrify {
  [CmdletBinding()]
  param ()
  begin {
    Write-Host -Object 'Installing astrify...'
  }
  process {
    $archivePath = Get-Astrify
    Write-Host -Object 'Extracting astrify...' -NoNewline
    Expand-Archive -Path $archivePath -DestinationPath $astrifyFolderPath -Force
    Write-Success
    Add-AstrifyToPath
  }
  end {
    Remove-Item -Path $archivePath -Force -ErrorAction 'SilentlyContinue'
    Write-Host -Object 'astrify was successfully installed!' -ForegroundColor 'Green'
  }
}
#endregion Functions

#region Main
#region Checks
if (-not (Test-PowerShellVersion)) {
  Write-Unsuccess
  Write-Warning -Message 'PowerShell 5.1 or higher is required to run this script'
  Write-Warning -Message "You are running PowerShell $($PSVersionTable.PSVersion)"
  Write-Host -Object 'PowerShell 5.1 install guide:'
  Write-Host -Object 'https://learn.microsoft.com/skypeforbusiness/set-up-your-computer-for-windows-powershell/download-and-install-windows-powershell-5-1'
  Write-Host -Object 'PowerShell 7 install guide:'
  Write-Host -Object 'https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows'
  Pause
  exit
}
else {
  Write-Success
}
if (-not (Test-Admin)) {
  Write-Unsuccess
  Write-Warning -Message "The script was run as administrator. This can result in problems with the installation process or unexpected behavior. Do not continue if you do not know what you are doing."
  $Host.UI.RawUI.Flushinputbuffer()
  $choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Abort installation.'),
    (New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'Resume installation.')
  )
  $choice = $Host.UI.PromptForChoice('', 'Do you want to abort the installation process?', $choices, 0)
  if ($choice -eq 0) {
    Write-Host -Object 'astrify installation aborted' -ForegroundColor 'Yellow'
    Pause
    exit
  }
}
else {
  Write-Success
}
#endregion Checks

#region Astrify
$installedAstrify = Join-Path -Path $astrifyFolderPath -ChildPath 'astrify.exe'
if (-not (Test-Path -LiteralPath $installedAstrify -PathType Leaf)) {
  $installedCommand = Get-Command -Name 'astrify' -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($installedCommand) {
    $installedAstrify = $installedCommand.Source
  }
  else {
    $installedAstrify = $null
  }
}

if ($installedAstrify) {
  $Host.UI.RawUI.Flushinputbuffer()
  $choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Run astrify update.'),
    (New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'Continue with installation.')
  )
  $choice = $Host.UI.PromptForChoice('', 'Astrify is already installed. Do you want to fix your installation?', $choices, 0)
  if ($choice -eq 0) {
    & $installedAstrify update
    if ($LASTEXITCODE -ne 0) {
      throw "Astrify update failed with exit code $LASTEXITCODE."
    }
    return
  }
}

Move-OldAstrifyFolder
Install-Astrify
Write-Host -Object "`nRun" -NoNewline
Write-Host -Object ' astrify -h ' -NoNewline -ForegroundColor 'Cyan'
Write-Host -Object 'to get started'
#endregion Astrify

#region Marketplace
$Host.UI.RawUI.Flushinputbuffer()
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Install Astrify Marketplace."),
    (New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not install Astrify Marketplace.")
)
$choice = $Host.UI.PromptForChoice('', "`nDo you also want to install Astrify Marketplace? It will become available within the Spotify client, where you can easily install themes and extensions.", $choices, 0)
if ($choice -eq 1) {
  Write-Host -Object 'astrify Marketplace installation aborted' -ForegroundColor 'Yellow'
}
else {
  Write-Host -Object 'Starting the astrify Marketplace installation script..'
  $Parameters = @{
    Uri             = 'https://raw.githubusercontent.com/astrify/astrify-marketplace/main/resources/install.ps1'
    UseBasicParsing = $true
  }
  Invoke-WebRequest @Parameters | Invoke-Expression
}
#endregion Marketplace
#endregion Main
