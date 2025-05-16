Write-Host "`nSetting up PowerShell and Nushell environments..."

# --- PowerShell Configuration ---
Write-Host "`nConfiguring PowerShell profile..."

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

# Ensure PowerShell profile exists
if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}

# Load current profile content
$profileContent = Get-Content $PROFILE -Raw
$venvLine = '& "$HOME\.venv\Scripts\Activate.ps1"'
$starshipLine = 'Invoke-Expression (&starship init powershell)'

# Add uv venv activation if missing
if ($profileContent -notmatch [regex]::Escape($venvLine)) {
    Add-Content -Path $PROFILE -Value "`n# Activate uv venv`n$venvLine"
    Write-Host "Added .venv activation to PowerShell profile."
}

# Install Starship if not already installed
if (-not (Get-Command starship.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Starship not found. Installing..."
    winget install --id Starship.Starship
}

# Add Starship init if missing
if ($profileContent -notmatch [regex]::Escape($starshipLine)) {
    Add-Content -Path $PROFILE -Value "`n# Initialize Starship prompt`n$starshipLine"
    Write-Host "Added Starship to PowerShell profile."
}

# --- Nushell Installation ---
Write-Host "`nChecking for Nushell..."

$nuInstalled = Get-Command nu.exe -ErrorAction SilentlyContinue
if (-not $nuInstalled) {
    Write-Host "Nushell not found. Installing with winget..."
    winget install --id Nushell.Nushell --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Nushell is already installed."
}

# --- Nushell Configuration ---
Write-Host "`nConfiguring Nushell..."

$nuConfigDir = "$env:APPDATA\nushell"
$envFile = Join-Path $nuConfigDir "env.nu"

# Ensure env.nu exists
if (-not (Test-Path $envFile)) {
    New-Item -Path $envFile -ItemType File -Force | Out-Null
    Write-Host "Created env.nu at $envFile"
}

# Add Starship init to env.nu
$nuStarshipLine = 'mkdir ~/.cache/starship; starship init nu | save --force ~/.cache/starship/init.nu; source ~/.cache/starship/init.nu'
$envContent = Get-Content $envFile -Raw
if ($envContent -notmatch "starship init nu") {
    Add-Content -Path $envFile -Value "`n# Initialize Starship`n$nuStarshipLine"
    Write-Host "Added Starship initialization to Nushell env.nu"
} else {
    Write-Host "Starship already configured in Nushell env.nu"
}

Write-Host "`nShell setup complete. Restart your terminal to apply the changes."