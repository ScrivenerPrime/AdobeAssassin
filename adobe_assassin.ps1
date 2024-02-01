# Adobe Assassin 0.1.0 - Initial release
# a simple script to kill all known Adobe services and processes

Set-Location -Path $PSScriptRoot

# Check to make sure this script is running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $response = Read-Host "For best effectiveness, this script needs to run as Administrator.\n
    Do you want to restart in Administrator mode? (Y/n)"
    if ($response -eq 'Y') {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    } else {
        Write-Host "Very well. Running script in Regular Mode."
    }
}

$adobeApps = @("Photoshop.exe", "Adobe Audition.exe", "AfterFX.exe", "Illustrator.exe", "InDesign.exe", "InCopy.exe", "Acrobat.exe", "Bridge.exe", "Dreamweaver.exe", "Flash.exe", "FlashBuilder.exe", "Fireworks.exe", "Muse.exe", "Prelude.exe", "Premiere.exe", "SpeedGrade.exe")

foreach ($app in $adobeApps) {
    if (Get-Process $app -ErrorAction SilentlyContinue) {
        Write-Output "$app is still running."
        Read-Host "Press any key to exit..."
        exit
    }
}

# Write-Output "No Adobe applications are running. Stopping Adobe services..."

# Define the list of known Adobe services and processes
function Stop-AdobeServicesAndProcesses {
    $services = @(
        "AdobeUpdateService",
        "Adobe Genuine Software Integrity Service",
        "Adobe Acrobat Update Service",
        "AdobeFlashPlayerUpdateSvc",
        "Adobe Genuine Monitor Service",
        "AdobeARMservice",
        "AdobeDesktopService",
        "Adobe Crash Reporter Service",
        "Adobe Desktop Service"
    )

    $processes = @(
        "Adobe Installer",
        "AdobeNotificationClient",
        "Adobe Desktop Service",
        "Adobe CEF Helper",
        "CCLibrary",
        "CCXProcess",
        "CoreSync",
        "Creative Cloud Helper",
        "Creative Cloud",
        "AdobeIPCBroker",
        "Adobe Crash Processor"
    )

    # Stop known Adobe services
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    }
    # Stop known Adobe processes
    foreach ($process in $processes) {
        Stop-Process -Name $process -Force -ErrorAction SilentlyContinue
    }

    Write-Output "Known Adobe services and processes killed."
}

# Call the function
Stop-AdobeServicesAndProcesses

# Debugging:
# Write-Output "Known Adobe processes assassinated."
# Start-Sleep -s 5

Read-Host -Prompt "Press Enter to exit"