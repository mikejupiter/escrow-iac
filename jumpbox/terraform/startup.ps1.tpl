<powershell>
try {
    $LogFile = "C:\startup_log.txt"
    Add-Content -Path $LogFile -Value "Starting startup.ps execution to enable Ansimble access"
    # $DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("${admin_password}"))

    # New-LocalUser "admin" -AccountNeverExpires:$true -PasswordNeverExpires:$true -Password (ConvertTo-SecureString -AsPlainText -Force "$Password") -FullName "Ansible Admin" -Description "Admin account for Ansible"
    # Add-LocalGroupMember -Group "Administrators" -Member "admin"

    $UserAccount = Get-LocalUser -Name "administrator"
    $UserAccount | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText -Force "${admin_password}")
    Add-Content -Path $LogFile -Value "User creation and group addition succeeded $Password"

    # Enable PSRemoting
    Enable-PSRemoting -Force
    Add-Content -Path $LogFile -Value "Enable-PSRemoting Done"


    # Create a self-signed certificate
    $cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "localhost"

    # Get the thumbprint of the certificate
    $thumbprint = $cert.Thumbprint

    # Bind the certificate to WinRM HTTPS listener
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"localhost`"; CertificateThumbprint=`"$thumbprint`"}"
    Add-Content -Path $LogFile -Value "Create SSL cert $thumbprint"

    # Configure WinRM
    winrm quickconfig -transport:https
    Add-Content -Path $LogFile -Value "winrm quickconfig Done"

    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
    winrm set winrm/config @{MaxTimeoutms="1800000"}
    winrm set winrm/config/service @{AllowUnencrypted="false"}

    Add-Content -Path $LogFile -Value "winrm setup Done"

    # Restart WinRM service
    Restart-Service -Name winrm
    Add-Content -Path $LogFile -Value "winrm restarted Done"

    # Configure Windows Firewall to allow RDP
    New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
    New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow

    Add-Content -Path $LogFile -Value "Firewall RDP and WinRM has been opened"

} catch {
    Add-Content -Path $LogFile -Value "Error: $_"
}

</powershell>