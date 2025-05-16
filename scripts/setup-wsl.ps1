Write-Host "`n Enabling WSL2 and installing Ubuntu..."

# Step 1: Enable WSL and Virtual Machine Platform features
Write-Host " Enabling Windows features for WSL..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -ErrorAction SilentlyContinue | Out-Null

# Step 2: Download and install the WSL2 kernel update (if needed)
$kernelInstaller = "$env:TEMP\wsl_update.msi"
Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $kernelInstaller
Start-Process -FilePath $kernelInstaller -Wait

# Step 3: Set WSL 2 as the default version
wsl --set-default-version 2

# Step 4: Install Ubuntu (if not already installed)
if (-not (wsl -l -q | Select-String -Pattern "Ubuntu")) {
    Write-Host " Installing Ubuntu..."
    Start-Process powershell.exe -ArgumentList '-NoExit', '-Command', 'wsl --install -d Ubuntu' -Wait
} else {
    Write-Host " Ubuntu is already installed."
}

Write-Host "A restart is required to complete WSL2 setup."
