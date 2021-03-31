$certPath = $env:SSL_CERT_PATH;

if ($certPath -and (Test-Path -Path "$certPath" -PathType Leaf))
{
  Write-Host "Certificate configured, (re)creating HTTPS binding..."

  Import-Module IISAdministration;
  Import-Module WebAdministration;

  $siteName = "Default Web Site";

  Write-Host "Importing certificate..."
  $certPswd = ConvertTo-SecureString -String "$env:SSL_CERT_PASSWORD" -Force -AsPlainText;
  $cert = Import-PfxCertificate -Exportable -FilePath "$certPath" -CertStoreLocation cert:\localMachine\My -Password $certPswd;

  Write-Host "Check if binding exist already..."
  $binding = Get-WebBinding -Name "$siteName" -Protocol "https";
  if ($binding)
  {
    Write-Host "Binding for HTTPS exists already, skipping..."
  }
  else
  {
    Write-Host "Creating new HTTPS binding and assigning certificate..."
    New-WebBinding -Name "$siteName" -IPAddress "*" -Port 443 -Protocol "https";
    $binding = Get-WebBinding -Name "$siteName" -Protocol "https";
    $binding.AddSslCertificate($cert.GetCertHashString(), "my");
  }
}

Write-Host "Starting IIS..."
C:\ServiceMonitor.exe w3svc
