# Dot-source the helpers.ps1 to import its functions
. "$PSScriptRoot\scripts\helpers.ps1"

Write-Host "`n Starting dev environment setup..."
Set-Location -Path $PSScriptRoot

# Run only the UAC-related section as admin
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\disable-uac.ps1" -AsAdmin $true
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-build-tools.ps1" -AsAdmin $true
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-zig.ps1" -AsAdmin $true
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-wsl.ps1" -AsAdmin $true

# Now run the rest of the setup normally
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-apps.ps1"
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-uv.ps1"
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-dotfiles.ps1"
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-rust.ps1 "
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-shell-envs.ps1"
Invoke-Script -ScriptPath "$PSScriptRoot\scripts\setup-fonts.ps1"

Write-Host "`n Dev setup complete. Restart terminal or shell to apply all changes."
