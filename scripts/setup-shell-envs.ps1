Write-Host "`nSetting up PowerShell 5, PowerShell 7, and Nushell environments..."

# ---------------------------------------------------------------------
# Profile paths
# ---------------------------------------------------------------------

$p5ProfilePath = $PROFILE  # Windows PowerShell 5.1 profile
$p7ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Write-Host "`nConfiguring PowerShell 5 profile at: $p5ProfilePath"
Write-Host "Configuring PowerShell 7 profile at: $p7ProfilePath"

# Ensure both profile files exist
foreach ($path in @($p5ProfilePath, $p7ProfilePath)) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType File -Force | Out-Null
    }
}

# Define common config lines
$venvLine = '& "$env:USERPROFILE\.venv\Scripts\Activate.ps1"'
$starshipLine = 'Invoke-Expression (&starship init powershell)'

# Function to append lines to a profile if not already present
function Add-LineIfMissing {
    param (
        [string]$Path,
        [string]$Line,
        [string]$Description
    )
    if (-not (Select-String -Path $Path -Pattern [regex]::Escape($Line) -Quiet)) {
        Add-Content -Path $Path -Value "`n# $Description`n$Line"
        Write-Host "Added $Description to $Path"
    } else {
        Write-Host "$Description already present in $Path"
    }
}

# Add lines to both profiles
foreach ($profilePath in @($p5ProfilePath, $p7ProfilePath)) {
    Add-LineIfMissing -Path $profilePath -Line $venvLine -Description ".venv activation"
    Add-LineIfMissing -Path $profilePath -Line $starshipLine -Description "Starship initialization"
}

# ---------------------------------------------------------------------
# Install Starship
# ---------------------------------------------------------------------

if (-not (Get-Command starship.exe -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Starship via winget..."
    winget install --accept-package-agreements --accept-source-agreements --id Starship.Starship
} else {
    Write-Host "`nStarship is already installed."
}

# ---------------------------------------------------------------------
# Install Nushell
# ---------------------------------------------------------------------

if (-not (Get-Command nu.exe -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Nushell via winget..."
    winget install --accept-package-agreements --accept-source-agreements --id Nushell.Nushell
} else {
    Write-Host "`nNushell is already installed."
}

# ---------------------------------------------------------------------
# Configure Nushell
# ---------------------------------------------------------------------

Write-Host "`nConfiguring Nushell..."

$nuConfigDir = Join-Path $env:APPDATA 'nushell'
$envFile = Join-Path $nuConfigDir 'env.nu'
$cacheDir = Join-Path $env:USERPROFILE '.cache\starship'
$initFile = Join-Path $cacheDir 'init.nu'
$initLine = 'source ~/.cache/starship/init.nu'

# Ensure .cache/starship directory exists
if (-not (Test-Path $cacheDir)) {
    New-Item -Path $cacheDir -ItemType Directory -Force | Out-Null
}

# Generate Starship init.nu
starship init nu | Set-Content -Path $initFile
Write-Host "Generated Starship init.nu at $initFile"

# Ensure env.nu exists
if (-not (Test-Path $envFile)) {
    New-Item -Path $envFile -ItemType File -Force | Out-Null
    Write-Host "Created env.nu at $envFile"
}

# Add starship source line if missing
$envContent = Get-Content $envFile -Raw
if ($envContent -notmatch [regex]::Escape($initLine)) {
    Add-Content -Path $envFile -Value "`n# Initialize Starship`n$initLine"
    Write-Host "Added source line to env.nu"
} else {
    Write-Host "Starship already sourced in env.nu"
}

# ---------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------

Write-Host "`nShell setup complete."

Write-Host "`nPlease restart your terminal sessions to apply changes."
Write-Host "Or run manually:"
Write-Host "  PowerShell 5: . '$p5ProfilePath'"
Write-Host "  PowerShell 7: . '$p7ProfilePath'"
Write-Host "  Nushell:      source ~/.cache/starship/init.nu"
