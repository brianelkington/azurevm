param(
    [string]$StorageAccountName,
    [string]$ShareName,
    [string]$AccountKey,
    [string]$DriveLetter = "S"
)

$target = "$StorageAccountName.file.core.windows.net"
$user = "Azure\\$StorageAccountName"
$sharePath = "\\$target\$ShareName"

cmdkey /add:$target /user:$user /pass:$AccountKey
New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root $sharePath -Persist

schtasks.exe /Create /TN MapDataDrive /TR "powershell -ExecutionPolicy Bypass -File C:\\map-drive.ps1 -StorageAccountName $StorageAccountName -ShareName $ShareName -AccountKey $AccountKey -DriveLetter $DriveLetter" /SC ONLOGON /RL HIGHEST /RU SYSTEM /F
