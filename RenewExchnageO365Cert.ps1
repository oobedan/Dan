Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

Start-Transcript -Path "c:\automation\letsencrypt.txt"

function InstallCert ($certPath, [System.Security.Cryptography.X509Certificates.StoreName] $storeName)
{
    [Reflection.Assembly]::Load("System.Security, Version=2.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

    $flags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet -bor [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet

    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath, "", $flags)

    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($storeName, [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)

    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite);

    $store.Add($cert);

    $store.Close();
}

#fuction required to convert secure string to text so the PFX file can be written. This isnt required in PowerShell 7
Function ConvertFrom-SecureString-AsPlainText{

    [CmdletBinding()]

    param (

        [Parameter(

            Mandatory = $true,

            ValueFromPipeline = $true

        )]

        [System.Security.SecureString]

        $SecureString

    )

    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString);

    $PlainTextString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);

    $PlainTextString;

}

# Azure - Import modules
if (Get-Module -ListAvailable -Name Az.*) {
    Write-Host "Az module already available, do nothing.." -ForegroundColor Yellow
    
} else {
    Write-Host "Az module not yet available, installing..." -ForegroundColor Yellow
    Install-Module -Name Az -scope AllUsers -Confirm:$false -force
    Import-Module Az | Out-Null
}

$localservername = $env:COMPUTERNAME
 
#Needs managed identiy configured for KV access on VM or devops agent running this
Connect-AzAccount -Identity

#KeyVault variables
$KVvaultName = "KEYVAULTNAME"
$KVcertName = "KEYVAULTCERT"

$KVcert = Get-AzKeyVaultCertificate -VaultName $KVvaultName -Name $KVcertName

$KVsecret = Get-AzKeyVaultSecret -VaultName $KVvaultName -Name $KVcert.Name

#powershell 7 you can use ConvertFrom-SecureString -AsPlainText native command. If 7 use that and not this function
$KVsecretByte = [Convert]::FromBase64String(($KVsecret.SecretValue | ConvertFrom-SecureString-AsPlainText))

#write out cert secret to a local PFX file
[System.IO.File]::WriteAllBytes("c:\automation\cert.pfx", $KVsecretByte)

Import-PfxCertificate -FilePath C:\Automation\cert.pfx -CertStoreLocation Cert:\LocalMachine\My -Exportable

InstallCert -certPath C:\Automation\cert.pfx -storeName "My"

Write-host "Import the certificate to the local store from PFX file"
$cert = Import-ExchangeCertificate -FileName "c:\automation\cert.pfx" -PrivateKeyExportable $true
$cert


#Enable the certificate in Exchange
Enable-ExchangeCertificate -Thumbprint $cert.Thumbprint -Services SMTP -Force

#Get LetsEncrypt cert properties
$TLSCert = Get-ExchangeCertificate -Thumbprint $cert.Thumbprint
$TLSCertName = "<I>$($TLSCert.Issuer)<S>$($TLSCert.Subject)"

# Get a temporary cert while swapping out the old one
$tempcert = Get-ExchangeCertificate | where {$_.subject -like "cn=*.name*"} 
$tempTLSCert = Get-ExchangeCertificate -Thumbprint $tempcert.Thumbprint
$tempTLSCertName = "<I>$($tempTLSCert.Issuer)<S>$($tempTLSCert.Subject)"

# get o365 global send 
$o365send = Get-SendConnector | where {$_.Identity -like "Outbound to Office 365*"}

# get receive connector so we can set it later
$onpremreceive = Get-ReceiveConnector | where {$_.Identity -like "$localservername\Default Frontend*"}

# cert O365 send to another cert temporarily

Set-SendConnector $o365send.Name -TlsCertificateName $tempTLSCertName -force

#get old certs that have same subject but not match the new one and then remove it
$oldcert = Get-ExchangeCertificate | where {$_.thumbprint -ne $cert.Thumbprint -and $_.Subject -eq "CN=INSERTNAMEHERE.FQDN"}
write-host "############## Removing old cert #############"
$oldcert

Remove-ExchangeCertificate -Thumbprint $oldcert.thumbprint -Confirm:$false


# enable cert of send connector and recevice connectors for new Let's Encrypt
Set-SendConnector $o365send.Name -TlsCertificateName $TLSCertName -force

Set-ReceiveConnector $onpremreceive.Identity -TlsCertificateName $TLSCertName


Stop-Transcript