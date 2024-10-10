# Prompt for number of network devices
$deviceCount = Read-Host "Enter the number of network devices"

# Initialize an array to store device names
$deviceNames = @()

# Prompt for name of each network device
for ($i = 1; $i -le $deviceCount; $i++) {
$deviceName = Read-Host "Enter the name of network device $i"
$deviceNames += $deviceName
}

# Prompt for number of days
$days = Read-Host "Enter the number of days"

# Iterate through each device
foreach ($device in $deviceNames) {
    Write-Host "Pinging device $device..."

    # Ping the device
    $pingResult = Test-Connection -ComputerName $device -Quiet -Count 1

    # If device pings, list user profiles older than the specified number of days
    if ($pingResult) {
    Write-Host "Pinging successful!"

    # Get the user profiles older than the specified number of days
    $oldProfiles = Get-ChildItem -Path "\\$device\C$\Users" -Filter "*.*" -Directory |
    Where-Object { $_.Name -notin @("Public", "ADMINI~1") -and $_.Name -notlike @("*PKG*") -and $_.LastWriteTime -lt (Get-Date).AddDays(-$days) }

    # If there are any old profiles, prompt for confirmation
    if ($oldProfiles) {
        Write-Host "The following user profiles will be deleted:"
        $oldProfiles | Format-Table Name, LastWriteTime -AutoSize

        $confirmation = Read-Host "Do you want to delete these profiles? (Y/N)"

        # If user confirms deletion, force delete the profiles and show progress
        if ($confirmation -eq "Y") {
            foreach ($profile in $oldProfiles) {
            Write-Host "Deleting profile $($profile.Name)"
            Get-WmiObject -ComputerName $device -Class Win32_UserProfile | Where-Object {$_.localpath -eq $profile} | Remove-WmiObject
            #Get-ChildItem $profile.FullName -Recurse | Remove-Item -Recurse -Force
            Write-Progress -Activity "Deleting profiles" -Status "Deleting $($profile.Name)" -PercentComplete (($oldProfiles.IndexOf($profile) + 1) / $oldProfiles.Count * 100)
            }
        Write-Host "Deletion complete!"
        }
    else {
        Write-Host "Profile deletion cancelled."
    }
    }
    else {
        Write-Host "No user profiles found to delete."
    }
    }
else {
    Write-Host "Pinging failed for device $device"
}
}