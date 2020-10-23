$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$sysLightBool = (Get-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme" -ErrorAction SilentlyContinue).SystemUsesLightTheme 

# chose light or dark image path
if ($sysLightBool -eq 0)
{
    #System is in dark mode
    $url = "https://raw.githubusercontent.com/principleone/Wallpaper/main/P1Dark.jpg"
} else {
    #System is in light mode
    $url = "https://raw.githubusercontent.com/principleone/Wallpaper/main/P1Light.jpg"
}

$WallpaperURL = $url
# $LockscreenUrl = $url

$ImageDestinationFolder = "C:\P1\Wallpaper" # Change to your fitting - this is the folder for the wallpaper image
md $ImageDestinationFolder -erroraction silentlycontinue # Creates the destination folder on the target computer

$WallpaperDestinationFile = "$ImageDestinationFolder\wallpaper.png" # Change to your fitting - this is the Wallpaper image
# $LockScreenDestinationFile = "$ImageDestinationFolder\LockScreen.png" # Change to your fitting - this is the Lockscreen image

# Downloads the image file from the source location
Start-BitsTransfer -Source $WallpaperURL -Destination "$WallpaperDestinationFile" -erroraction silentlycontinue
# Start-BitsTransfer -Source $LockscreenUrl -Destination "$LockScreenDestinationFile" -erroraction silentlycontinue

# Assigns the wallpaper 
$RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

$DesktopPath = "DesktopImagePath"
$DesktopStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"

$DesktopStatusValue = "1"
$LockScreenStatusValue = "0"
$DesktopImageValue = "$WallpaperDestinationFile"  
# $LockScreenImageValue = "$LockScreenDestinationFile"

IF(!(Test-Path $RegKeyPath))

{

New-Item -Path $RegKeyPath -Force | Out-Null

New-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $DesktopStatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $LockScreenStatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -erroraction silentlycontinue
Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -erroraction silentlycontinue

}

ELSE {

New-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $DesktopStatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $LockScreenStatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -erroraction silentlycontinue
Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -erroraction silentlycontinue

}

# Clears the error log from powershell before exiting
    $error.clear()