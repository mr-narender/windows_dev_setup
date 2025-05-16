function Invoke-AsAdmin {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath,

        [string]$Arguments = ""
    )

    if (-not (Test-Path $ScriptPath)) {
        throw "Script '$ScriptPath' does not exist."
    }

    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" $Arguments" -Verb RunAs -Wait
}

function Invoke-Script {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath,

        [string]$Arguments = "",

        [bool]$AsAdmin = $false,

        [string]$LogFile = "$PSScriptRoot\..\invoke-script.log"
    )

    if (-not (Test-Path $ScriptPath)) {
        throw "Script '$ScriptPath' does not exist."
    }

    # Make sure the log file directory exists
    $logDir = Split-Path -Path $LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    # Escape script path and build redirection within cmd /c
    $escapedScriptPath = $ScriptPath.Replace('"', '""')
    $cmdLine = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$escapedScriptPath`" $Arguments >> `"$LogFile`" 2>>&1"
    $fullArgs = "/c $cmdLine"

    if ($AsAdmin) {
        Start-Process cmd.exe -ArgumentList $fullArgs -Verb RunAs -Wait
    } else {
        Start-Process cmd.exe -ArgumentList $fullArgs -Wait
    }
}

function Add-ToUserPath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PathToAdd
    )

    # Normalize the path
    $normalizedPath = [System.IO.Path]::GetFullPath($PathToAdd.Trim())

    # Get current user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    # Split and check if the path is already in PATH (case-insensitive)
    $pathList = $currentPath -split ';'
    if ($pathList -contains $normalizedPath) {
        Write-Host "Path already in user PATH: $normalizedPath"
    } else {
        # Add the new path
        $newPath = "$currentPath;$normalizedPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host " Added to user PATH: $normalizedPath"
    }
}