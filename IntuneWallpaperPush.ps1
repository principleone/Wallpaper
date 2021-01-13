# Write script output to file
Start-Transcript -path C:\P1\output.txt -append

# Get system theme (dark or light)
# HKCU can be read with non-admin elevation
$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$sysLightBool = (Get-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme").SystemUsesLightTheme 

# Chose light or dark image path
if ($sysLightBool -eq 0)
{
    # System is in dark mode
    $theme = "Dark"
} else {
    # Default to white image
    # System is in light mode
    $theme = "Light"
}

# Construct wallpaper github url from theme
$WallpaperURL = "https://raw.githubusercontent.com/principleone/Wallpaper/main/P1$theme.jpg"

# Ensure destination folder exists and is hidden 
$ImageDestinationFolder = "C:\P1\Wallpaper" 
md $ImageDestinationFolder -erroraction silentlycontinue
attrib +h "C:\P1" # make hidden

# Downloads the image file from the source location
$WallpaperDestinationFile = "$ImageDestinationFolder\wallpaper.jpg"
Start-BitsTransfer -Source $WallpaperURL -Destination "$WallpaperDestinationFile" -erroraction silentlycontinue

# Wallpaper path will be C:\P1\Wallpaper\wallpaper.jpg

Stop-Transcript