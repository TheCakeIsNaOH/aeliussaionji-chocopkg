﻿Import-Module au

$releases = 'https://github.com/picotorrent/picotorrent/releases/latest'

function global:au_SearchReplace {
	@{
		".\tools\VERIFICATION.txt" = @{
			"(?i)(^\s*x32:).*"                  = "`${1} $($Latest.URL32)"
			"(?i)(^\s*x64:).*"                  = "`${1} $($Latest.URL64)"
			"(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType32)"
			"(?i)(^\s*checksum32\:).*"          = "`${1} $($Latest.Checksum32)"
			"(?i)(^\s*checksum64\:).*"          = "`${1} $($Latest.Checksum64)"
		}
	}
}
function global:au_BeforeUpdate() {
	Get-RemoteFiles -Purge
}

function global:au_GetLatest {
	$download_page = (iwr $releases -UseBasicParsing).Links.href | Select-String '/tag/v' | Select-Object -First 1
	$Matches = $null
	$download_page -match '\d+\.\d+\.\d+'
	$version = $Matches[0]
	$url32 = "https://github.com/picotorrent/picotorrent/releases/download/v$version/PicoTorrent-$version-x86.exe"
	$url64 = "https://github.com/picotorrent/picotorrent/releases/download/v$version/PicoTorrent-$version-x64.exe"

	return @{ Version = $version; URL32 = $url32; URL64 = $url64; }
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
	Update-Package -checksumfor none
}
