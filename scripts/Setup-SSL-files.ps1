<#
.SYNOPSIS
	Sets up an Angular project to use SSL

.DESCRIPTION
	This script automates the setup of an Angular project to use https - SSL protocol

.PARAMETER ProjectPath
	The absolute path to the Angular project's root directory

.EXAMPLE
	.\Setup-SSL-files.ps1
	Runs the script using the default path, which is the project's root directory

#>
param (
	[Parameter(Mandatory = $false, HelpMessage = "Enter the absolute path to the Angular project's root directory.")]
	[string]$ProjectPath = $(
		# If running inside a VS Code workspace, $PWD contains the root
		if (Test-Path -Path "$PWD\.vscode") {
			$PWD.Path
		} else {
			$(Split-Path -Path $PSScriptRoot)  
		}
	)
)

# Corrected layout: targeting standard Angular asset directory structure
$assetsDir = "$ProjectPath\src\assets"
$sslDir = "$assetsDir\ssl"
$sslCert = "$sslDir\localhost.crt"

# If the assets directory does not exist for the Angular project, create it
if (-not (Test-Path -Path $assetsDir)) {
	New-Item -Path $assetsDir -ItemType Directory -Force
	Write-Host "$assetsDir created successfully." -ForegroundColor Green
} else {
	Write-Host "$assetsDir already exists."
}

# If the ssl directory does not exist for the Angular project, create it
if (-not (Test-Path -Path $sslDir)) {
	New-Item -Path $sslDir -ItemType Directory -Force
	Write-Host "$sslDir created successfully." -ForegroundColor Green
} else {
	Write-Host "$sslDir already exists."
}

# Handle Certificate Generation, Exporting, and System Trust together
if (-not (Test-Path -Path $sslCert -PathType Leaf)) {
	
	Write-Host "Generating a new self-signed certificate..." -ForegroundColor Cyan
	$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My" -KeyExportPolicy Exportable

	# Export the certificate (.crt) file to the project assets folder
	Export-Certificate -Cert $cert -FilePath "$sslCert"
	Write-Host "$sslCert created successfully" -ForegroundColor Green

	# --- AUTOMATED IMPORT AND TRUST SYSTEM ---
	Write-Host "Installing certificate into the Windows Trusted Root Store..." -ForegroundColor Cyan
	
	# Automatically binds and trusts the file natively in the Local Machine Root Certification store
	Import-Certificate -FilePath "$sslCert" -CertStoreLocation "Cert:\LocalMachine\Root"
	
	Write-Host "Success! Windows and your browsers now fully trust localhost." -ForegroundColor Green
} else {
	Write-Host "SSL certificate already exists and is configured." -ForegroundColor Yellow
}

Write-Host "SSL setup for $ProjectPath is complete and verified." -ForegroundColor Green
