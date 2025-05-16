Write-Host "`n Installing winget packages..."

$packages = @(
    "Neovim.Neovim",
    "Git.Git",
    "Microsoft.PowerToys",
    "wez.wezterm",
    "glzr-io.glazewm",
    "Microsoft.VisualStudio.2022.BuildTools",
    "Microsoft.VisualStudioCode",
    "OpenJS.NodeJS.LTS"
)

foreach ($pkg in $packages) {
    # Check if the package is already installed
    $isInstalled = winget list --id $pkg | Where-Object { $_ -match $pkg }

    if (-not $isInstalled) {
        Write-Host "Installing: $pkg"
        winget install --id $pkg --source winget --accept-package-agreements --accept-source-agreements --silent --force --disable-interactivity
    } else {
        Write-Host "Already installed: $pkg"
    }
}
