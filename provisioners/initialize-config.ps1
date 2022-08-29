$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Start-Transcript "$env:USERPROFILE\Desktop\initialize-config.log"

# Change network connection to Private so the default WinRM firewall rules work.
Write-Host "Switching network connection to Private for WinRM"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# Disable Floppy and DVD Drive
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\flpydisk -Name Start -Value 4    
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\cdrom -Name Start -Value 4 -Type DWord

# Turn off AutomaticManagedPangingfile for changing Temporary Storage Drive letter
"wmic computersystem set AutomaticManagedPagefile=False" | cmd

if ('${winrm_initialization}' -eq 'true') {
    winrm quickconfig -quiet

    try {
        Write-Host "Delete any existing WinRM listeners"
        winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
        winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null
    }
    catch {
        Write-Host $_.Exception.Message
    }

    Write-Host "Create a new WinRM listener and configure"
    winrm create winrm/config/listener?Address=*+Transport=HTTP
    winrm set winrm/config/winrs '@{MaxConcurrentUsers="20"}'
    winrm set winrm/config/winrs '@{MaxShellsPerUser="20"}'
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    winrm set winrm/config/client/auth '@{Basic="true"}'

    Write-Host "Configure UAC to allow privilege elevation in remote shells"
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $Setting = 'LocalAccountTokenFilterPolicy'
    Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

    Write-Host "turn off PowerShell execution policy restrictions"
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted

    Write-Host "Configure and restart the WinRM Service; Enable the required firewall exception"
    Stop-Service -Name WinRM
    Set-Service -Name WinRM -StartupType Automatic
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
    Start-Service -Name WinRM
}

Write-Host "Done!"