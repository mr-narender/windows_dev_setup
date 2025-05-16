# Requires: Run as administrator

# --- Configuration ---
$zigUrl = "https://ziglang.org/builds/zig-windows-x86_64-0.15.0-dev.558+9279ff888.zip"
$zigInstallDir = "C:\zig"
$zipFile = "$env:TEMP\zig.zip"

# --- Download Zig zip ---
Write-Host "Downloading Zig from: $zigUrl"
Invoke-WebRequest -Uri $zigUrl -OutFile $zipFile -UseBasicParsing

# --- Create install directory ---
if (!(Test-Path -Path $zigInstallDir)) {
    New-Item -Path $zigInstallDir -ItemType Directory | Out-Null
}

# --- Extract ZIP ---
Write-Host "Extracting Zig to: $zigInstallDir"
Expand-Archive -Path $zipFile -DestinationPath $zigInstallDir -Force

# --- Find the bin directory inside the extracted folder ---
$extractedFolder = Get-ChildItem -Path $zigInstallDir | Where-Object {
    $_.PSIsContainer -and $_.Name -like "zig-windows-*"
} | Select-Object -First 1

if (-not $extractedFolder) {
    Write-Error "Failed to locate Zig folder after extraction."
    exit 1
}

$zigBinPath = "$($extractedFolder.FullName)"

# --- Add Zig to system PATH ---
$existingPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($existingPath -notlike "*$zigBinPath*") {
    Write-Host "Adding Zig to system PATH..."
    $newPath = "$existingPath;$zigBinPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Zig path added to system PATH. Please restart your terminal or log out and back in."
} else {
    Write-Host "Zig is already in the system PATH."
}

# --- Verify installation ---
Write-Host "Verifying Zig installation..."
$env:PATH = "$zigBinPath;$env:PATH"  # Make it available in current session
zig version