# Define the registry path and key (use HKLM for system-wide persistence)
$regPath = "HKCU:\SOFTWARE\DisableUACRebootCheck"
$regKey = "HasRunBefore"

# Check if the registry key exists to track script execution
if ((Test-Path $regPath) -and (Get-ItemProperty -Path $regPath -Name $regKey).$regKey) {
    Write-Host "Script has already been executed. Skipping execution."
    exit 0
}

# If it hasn't run before, proceed with the task
Write-Host "`nDisabling UAC (EnableLUA)..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 0

Write-Host "`nForcing group policy update..."
gpupdate.exe /force

Write-Host "`nUAC disabled. Rebooting now..."

# Ensure the registry key exists and mark the script as executed
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

New-ItemProperty -Path $regPath -Name $regKey -Value 1 -PropertyType DWord -Force

# Delay to ensure the registry change is committed before rebooting
Start-Sleep -Seconds 5

# Reboot the system
Restart-Computer -Force