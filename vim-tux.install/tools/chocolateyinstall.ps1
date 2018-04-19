﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$destDir = Join-Path $ENV:ProgramFiles "Vim\vim80"
if ($Env:ChocolateyPackageParameters -match '/InstallDir:\s*(.+)') {
	$destDir = $Matches[1]
	if ($destDir.StartsWith("'") -or $destDir.StartsWith('"')) { $destDir = $destDir -replace '^.|.$' }
}

$packageArgs = @{
        packageName = 'vim-tux.install'
        filetype    = 'exe'
        file        = gi $toolsDir\*_x32.exe
        file64      = gi $toolsDir\*_x64.exe
        silentArgs  = "-o`"$destDir`" -y"
        softwareName = 'vim*'
}

Install-ChocolateyPackage @packageArgs
Start-ChocolateyProcessAsAdmin "-create-batfiles vim gvim evim view gview vimdiff gvimdiff -install-popup -install-openwith -add-start-menu" "$destDir\install.exe" -validExitCodes '0'
Remove-Item -Force -ea 0 "$toolsDir\*_x32.exe","$toolsDir\*_x64.exe"
Write-Output "Build provided by TuxProject.de - consider donating to help support their server costs."
