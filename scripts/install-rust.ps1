Write-Host "`n Installing Rust via rustup..."

# Define installer path
$rustInstaller = "$env:TEMP\rustup-init.exe"

# Download the installer
Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile $rustInstaller

# Run it silently with default options (installs stable Rust and cargo)
Start-Process -FilePath $rustInstaller -ArgumentList "-y" -NoNewWindow -Wait

# Add cargo bin directory to PATH (if not already present)
$cargoPath = "$HOME\.cargo\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

if ($currentPath -notlike "*$cargoPath*") {
    Write-Host " Adding $cargoPath to PATH..."
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$cargoPath", [EnvironmentVariableTarget]::User)
} else {
    Write-Host " Cargo path already in PATH"
}

# Check version
& "$cargoPath\cargo.exe" --version