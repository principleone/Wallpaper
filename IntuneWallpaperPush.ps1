Start-Transcript -path C:\P1\output.txt -append


$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$sysLightBool = (Get-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme").SystemUsesLightTheme 

# chose light or dark image path
if ($sysLightBool -eq 0)
{
    #System is in dark mode
    $theme = "dark"
    Write-Warning "dark"
} else {
    #System is in light mode
    $theme = "light"
    Write-Warning "light"
}

# seasonal wallpaper filepath construction
if ((Get-Date).Month -eq 12)
{
    # december
    $folder = "christmas"
}
else {
    # default
    $folder = "default"
}

$branch="adj97-patch-1"
$baseGitHubURL = "https://raw.githubusercontent.com/principleone/Wallpaper/$branch/img"
$WallpaperURL = "$baseGitHubURL/$folder/$theme.jpg"

$ImageDestinationFolder = "C:\P1\Wallpaper" # Change to your fitting - this is the folder for the wallpaper image
md $ImageDestinationFolder -erroraction silentlycontinue # Creates the destination folder on the target computer
attrib +h "C:\P1" # make hidden

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
