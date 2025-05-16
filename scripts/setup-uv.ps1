# Dot-source the helpers.ps1 to import its functions
. "$PSScriptRoot\helpers.ps1"

Write-Host " Installing uv Python tool..."
irm https://astral.sh/uv/install.ps1 | iex

$env:Path = "C:\Users\Narender\.local\bin;$env:Path"

Write-Host "`n Installing default Python tools..."

$venvPath = "$HOME\.venv"

if (-Not (Test-Path $venvPath)) {
    uv venv $venvPath
    Add-ToUserPath "$HOME\.venv\Scripts\"
    Write-Host " Created venv at $venvPath"
} else {
    Write-Host " venv already exists at $venvPath"
}

# Activate and install Python packages
& "$venvPath\Scripts\Activate.ps1"
uv pip install --upgrade pip
uv pip install black ruff pytest
Write-Host " Installed default Python tools (black, ruff, pytest)"
