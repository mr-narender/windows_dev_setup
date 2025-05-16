# Dot-source the helpers.ps1 to import its functions
. "$PSScriptRoot\scripts\helpers.ps1"

# install.ps1

Write-Host "`n Starting dev environment setup..."

Set-Location -Path $PSScriptRoot

# Run only the UAC-related section as admin
# Invoke-AsAdmin -ScriptPath "$PSScriptRoot\scripts\disable-uac.ps1"

# Now run the rest of the setup normally
# . .\scripts\install-winget-packages.ps1
# . .\scripts\install-uv.ps1
# . .\scripts\copy-dotfiles.ps1
# . .\scripts\install-rust.ps1
# . .\scripts\configure-env.ps1
# . .\scripts\setup-vs-path.ps1

Invoke-AsAdmin -ScriptPath "$PSScriptRoot\scripts\install-zig.ps1"
# Invoke-AsAdmin -ScriptPath "$PSScriptRoot\scripts\setup-wsl.ps1"

Write-Host "`n Dev setup complete. Restart terminal or shell to apply all changes."
