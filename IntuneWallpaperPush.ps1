#$ErrorActionPreference="SilentlyContinue"
#Stop-Transcript | out-null
#$ErrorActionPreference = "Continue"
Start-Transcript -path C:\P1\output.txt -append


$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$sysLightBool = (Get-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme").SystemUsesLightTheme 

# chose light or dark image path
if ($sysLightBool -eq 0)
{
    #System is in dark mode
    $url = "https://raw.githubusercontent.com/principleone/Wallpaper/main/P1Dark.jpg"
    Write-Warning "dark."
} else {
    #System is in light mode
    $url = "https://raw.githubusercontent.com/principleone/Wallpaper/main/P1Light.jpg"
    Write-Warning "light"
}

$WallpaperURL = $url

$ImageDestinationFolder = "C:\P1\Wallpaper" # Change to your fitting - this is the folder for the wallpaper image
md $ImageDestinationFolder -erroraction silentlycontinue # Creates the destination folder on the target computer
attrib +h "C:\P1"

$WallpaperDestinationFile = "$ImageDestinationFolder\wallpaper.png" # Change to your fitting - this is the Wallpaper image

# Downloads the image file from the source location
Start-BitsTransfer -Source $WallpaperURL -Destination "$WallpaperDestinationFile" -erroraction silentlycontinue

# Assigns the wallpaper 
$RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

Remove-Item -Path $RegKeyPath -Recurse -erroraction silentlycontinue
New-Item -Path $RegKeyPath -Force

New-ItemProperty -Path $RegKeyPath -Name "DesktopImageStatus" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value "0" -PropertyType DWORD -Force
New-ItemProperty -Path $RegKeyPath -Name "DesktopImagePath" -Value $WallpaperDestinationFile -PropertyType STRING -Force
New-ItemProperty -Path $RegKeyPath -Name "DesktopImageUrl" -Value $WallpaperDestinationFile -PropertyType STRING -Force


Stop-Transcript
