$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

###############################
# Why need to change the drive letter of Temporary storage in Azure VM
# Temporary storage is allocated in "D" drive basically to manage Memory Paging files.
# However, "D" drive has been used as a data drive normaly.
# In order to prevent the conflict with common behaviour,
# this script is changing the Temporary storage drive letter from "D" to "T".
###############################

# Prerequisites
# 1. Turn off AutomaticManagedPangingfile for changing Temporary Storage Drive letter (Refer to initialize-config.ps1)
# 2. Restart VM

$newDriveLetter = "T"

# Get Temporary Stroage drive information
$Drive = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'D:'"

# Change the Temporary drive letter
$Drive | Set-CimInstance -Property @{DriveLetter = "$($newDriveLetter):" }

# Delete the c:\ pagefile and create new one
"wmic pagefileset where name=`"C:\\pagefile.sys`" delete" | cmd
"wmic pagefileset create name=`"$($newDriveLetter):`\pagefile.sys`"" | cmd
"wmic pagefileset where name=`"$($newDriveLetter):\\pagefile.sys`" set InitialSize=6144, MaximumSize=6144" | cmd
"wmic pagefileset list /format:list" | cmd

# Reboot
Write-Information "Restart VM..."
Restart-Computer -Force
