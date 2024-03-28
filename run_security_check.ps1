# Prompt user for directory path
$directoryPath = Read-Host "Please enter the directory path"

# Set execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Import the PESecurity module
$modulePath = Join-Path $PSScriptRoot "Get-PESecurity.psm1"
Import-Module $modulePath

# Get the directory of the batch file
$batchDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Create output folder if it doesn't exist
$outputFolder = Join-Path -Path $batchDirectory -ChildPath "output"
if (-not (Test-Path -Path $outputFolder -PathType Container)) {
    New-Item -Path $outputFolder -ItemType Directory | Out-Null
}

# Run Get-PESecurity command and export to CSV in the output folder
$outputPath = Join-Path -Path $outputFolder -ChildPath "binaryprotection.csv"
Get-PESecurity -directory $directoryPath -recursive | Export-CSV $outputPath -NoTypeInformation

# Print a message to confirm execution
Write-Host "Get-PESecurity executed successfully. Output saved to: $outputPath"

# Get the full path to sigcheck.exe
$sigcheckPath = Join-Path -Path $batchDirectory -ChildPath "sigcheck.exe"

# Run sigcheck.exe command
$outputPath2 = Join-Path -Path $outputFolder -ChildPath "sigcheck1.csv"
& $sigcheckPath -c -s $directoryPath | Out-File -FilePath $outputPath2 -Encoding ascii

# Print a message to confirm execution
Write-Host "sigcheck.exe executed successfully. Output saved to: $outputPath2"
