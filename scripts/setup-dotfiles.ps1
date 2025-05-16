Write-Host "`n Cloning and copying dotfiles..."

$dotfilesRepo = "https://github.com/mr-narender/windows_dotfiles.git"
$tempPath = "$env:TEMP\dotfiles"

if (Test-Path $tempPath) {
    Remove-Item -Recurse -Force $tempPath
}
git clone $dotfilesRepo $tempPath

# Copy wezterm config
$weztermDest = "$HOME\AppData\Local\wezterm"
New-Item -ItemType Directory -Force -Path $weztermDest
# Copy-Item "$tempPath\.config\wezterm\*" -Destination $weztermDest -Recurse -Force
Write-Host " Wezterm config copied."

# Copy nvim config
$nvimDest = "$HOME\AppData\Local\nvim"
New-Item -ItemType Directory -Force -Path $nvimDest
# Copy-Item "$tempPath\.config\nvim\*" -Destination $nvimDest -Recurse -Force
Write-Host " Neovim config copied."