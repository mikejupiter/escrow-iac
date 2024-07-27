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

    # Get the volume object for the new disk (assumes it's Disk 1)
    $disk = Get-Disk | Where-Object { $_.OperationalStatus -eq 'Online' -and $_.PartitionStyle -eq 'RAW' }
    Add-Content -Path $LogFile -Value "Unformatted disks: $disk"

    if ($disk) {
    # Bring the disk online if it's offline
        if ($disk.Status -eq 'Offline') {
            Add-Content -Path $LogFile -Value "Bringing disk $($disk.Number) online."
            Set-Disk -Number $disk.Number -IsOffline $false
        }

        Add-Content -Path $LogFile -Value "Initialize the disk: $disk"
        Initialize-Disk -Number $disk.Number -PartitionStyle MBR

        Add-Content -Path $LogFile -Value "Create a new partition and format it: $disk"
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel "JumpboxData" -Confirm:$false

        Add-Content -Path $LogFile -Value "Map to a specific drive letter for: $disk"
        $driveLetter = (Get-Partition -DiskNumber $disk.Number | Select-Object -First 1).DriveLetter
        Add-Content -Path $LogFile -Value "Disk initialized and formatted. Drive letter: $driveLetter"
    } else {
        Add-Content -Path $LogFile -Value "No RAW disk found."
    }


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