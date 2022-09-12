$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | sort number
$driveLetters = 68..89 | ForEach-Object { [char]$_ }

if ($(@($disks | Measure-Object).Count) -ne 0) {
    $count = 0
    foreach ($disk in $disks) {
        $driveLetter = $driveLetters[$count].ToString()
        Write-Host "Found raw disk count: $(@($disk | Measure-Object).Count)"
        Write-Host "Raw disk list: $($disk | Format-List | Out-String)"

        Write-Host "Initailizing the disk."
        Write-Host "Drive letter: $driveLetter"

        Write-Verbose "Target Disk: $($disk | Format-List | Out-String)"

        $disk |
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "data$($count + 1)" -Confirm:$false -Force

        Write-Host "Finished Initializing disk"
        $count++
    }
}
else {
    throw "No found a raw disk mounted."
}