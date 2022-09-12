$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | sort number
$driveLetters = 68..89 | ForEach-Object { [char]$_ }

if ($(@($disks | Measure-Object).Count) -ne 0) {
    $count = 0
    foreach ($disk in $disks) {
        $driveLetter = $driveLetters[$count].ToString()
        Write-Information "Found raw disk count: $(@($disk | Measure-Object).Count)"
        Write-Information "Raw disk list: $($disk | Format-List | Out-String)"

        Write-Information "Initailizing the disk."
        Write-Information "Drive letter: $driveLetter"

        Write-Verbose "Target Disk: $($disk | Format-List | Out-String)"

        $disk |
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "data$($count + 1)" -Confirm:$false -Force

        Write-Information "Finished Initializing disk"
        $count++
    }
}
else {
    throw "No found a raw disk mounted."
}
