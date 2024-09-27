Function InstallWindowsModules
{
    # Installs NuGet with Forced
    Install-PackageProvider -Name -NuGet -Force

    # Trusts Microsoft PSGallery
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted 

    # Install PSWindows Update
    Install-Module PSWindowsUpdate

    # Sets progress file to 1 to indicate modules have been installed 
    Set-Content C:\AutoUpdates\Progress.txt -Value 1
}


Function InstallWindowsUpdates
{
    # Gets latest Windows Update
    Get - WindowsUpdate | Out-File C:\AutoUpdates\History\Updates_"$((Get-Date).toString('dd-MM-yyyy_HH.mm.ss'))".txt

    # Installs updates, accepts all automically and reboots
    Install-WindowsUpdate -Install -AcceptAll   -AutoReboot
}

$ChkPath = "C:\AutoUpdates"
$PathExists = Test-Path $ChkPath
If ($PathExists -eq $false)
{
    New-Item C:\AutoUpdates\Progress.txt
    Set-Content C:\AutoUpdates\Progress.txt -Value 0
}

# Reads file for status 
# This is logic used to control installation process of server
$Status = Get-Content C:\AutoUpdates\Progress.txt -First 1

If ($Status -eq 0)
{
    #Installs required modules + updates
    InstallWindowsModules
    InstallWindowsUpdates
}
elseif ($Status -eq 1)
{
    # Installs Windows updates only
    InstallWindowsUpdates
}

