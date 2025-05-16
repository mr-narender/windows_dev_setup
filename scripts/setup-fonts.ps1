# Define URLs for the fonts
$fontUrls = @{
    "CaskaydiaCove Nerd Font" = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CaskaydiaCove.zip"
    "Ubuntu Mono"             = "https://github.com/google/fonts/raw/main/ufl/ubuntu/UbuntuMono-Regular.ttf"
    "JetBrains Mono"          = "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
}

# Create a temp folder for downloading fonts
$tempDir = "$env:TEMP\FontInstall"
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
Set-Location -Path $tempDir

# Function to install .ttf fonts
function Install-FontFile {
    param (
        [string]$fontFile
    )
    $fontsFolder = "$env:WINDIR\Fonts"
    $fontName = Split-Path $fontFile -Leaf
    Copy-Item $fontFile -Destination $fontsFolder -Force
    Write-Host "Installed: $fontName"
}

# Download and extract/install each font
foreach ($font in $fontUrls.GetEnumerator()) {
    $name = $font.Key
    $url = $font.Value
    Write-Host "`nDownloading: $name..."

    $filename = "$tempDir\" + [System.IO.Path]::GetFileName($url)
    Invoke-WebRequest -Uri $url -OutFile $filename

    if ($filename -like "*.zip") {
        $extractPath = "$tempDir\$($name.Replace(' ', ''))"
        Expand-Archive -Path $filename -DestinationPath $extractPath -Force
        Get-ChildItem -Path $extractPath -Recurse -Include *.ttf | ForEach-Object {
            Install-FontFile -fontFile $_.FullName
        }
    }
    elseif ($filename -like "*.ttf") {
        Install-FontFile -fontFile $filename
    }
}

Write-Host "`n Fonts installed. You may need to restart applications to see them."