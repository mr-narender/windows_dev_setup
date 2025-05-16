# Define the URL for the Visual Studio Build Tools installer
$vsBuildToolsUrl = "https://aka.ms/vs/17/release/vs_buildtools.exe"

# Define the path where the installer will be downloaded
$installerPath = "$env:TEMP\vs_installer.exe"

# Download the Visual Studio Build Tools installer if not exists
if (-Not (Test-Path $installerPath)) {
    Write-Host "Downloading Visual Studio Build Tools..."
    Invoke-WebRequest -Uri $vsBuildToolsUrl -OutFile $installerPath
}

# Check if the installer downloaded successfully
if (-Not (Test-Path $installerPath)) {
    Write-Error "Installer failed to download."
    exit 1
}

# Start the installer with the required workloads and components
Write-Host "Installing Visual Studio Build Tools for Python and Neovim..."

# Start the installer with the necessary workloads and components for Python and Neovim:
# - Desktop development with C++ (needed for compiling C++ dependencies)
# - Python development (needed for Python packages that require C++ compilation, e.g., numpy, scipy)
# - .NET Core tools (optional, for some Neovim plugins that might require .NET)
# - CMake tools for Windows (useful for compiling certain Neovim plugins)
Start-Process -FilePath $installerPath -ArgumentList `
    '--quiet', `
    '--wait', `
    '--add', 'Component.LinuxBuildTools', `
    '--add', 'Microsoft.VisualStudio.Component.Node.Build', `
    '--add', 'Microsoft.VisualStudio.Workload.NativeDesktop', `
    '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
    '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.22621',
    '--add', 'Microsoft.VisualStudio.Component.Windows10SDK.19041', `
    '--add', 'Microsoft.VisualStudio.Component.CMake', `
    '--add', 'Microsoft.VisualStudio.Component.VC.CMake.Project', `
    '--add', 'Microsoft.VisualStudio.Component.VC.Redist.MSM', `
    '--add', 'Microsoft.VisualStudio.Component.NuGet' `
    -NoNewWindow -Wait

# Clean up the installer
Remove-Item $installerPath

Write-Host "Build tools installation completed."