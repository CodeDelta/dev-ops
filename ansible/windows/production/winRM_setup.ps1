# Start WinRM service
Enable-PSRemoting -Force
Set-Service winrm -startuptype automatic
Start-Service WinRM

# Create a self-signed certificate.
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {
   $_.EnhancedKeyUsageList -like "*Client Authentication*" -and
   $_.EnhancedKeyUsageList -like "*Server Authentication*"
} | Select-Object -First 1
if ($cert -eq $null) {
   Write-Host "No valid certificate found. Generating a new one..."
   $cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME `
   -CertStoreLocation "cert:\LocalMachine\My"
} else {
   Write-Host "Useing an existing certificate..."
}
$thumbprint = $cert.Thumbprint

# Setup WindowsRM indound rules
$firewallRule = Get-NetFirewallRule -DisplayName `
"Windows Remote Management (HTTPS-In)" -ErrorAction SilentlyContinue
if ($firewallRule -eq $null) {
   Write-Host "Setting up a firewall rule for WinRM HTTPS..."
   New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" `
   -Direction Inbound -LocalPort 5838 -Protocol TCP -Action Allow
} else {
   Write-Host "A firewall rule for WinRM HTTPS is already configured."
}

# Setup winRM HTTPS listener
$httpsListener = winrm enumerate winrm/config/listener | Select-String `
-Pattern "Transport = HTTPS"
if ($httpsListener -eq $null) {
   Write-Host "Setting up an HTTPS listener..."
   winrm create winrm/config/Listener?Address=*+Transport=HTTPS `
   "@{Hostname=`"$env:COMPUTERNAME`";CertificateThumbprint=`"$thumbprint`"}"
} else {
   Write-Host "An HTTPS listener is already configured."
}
