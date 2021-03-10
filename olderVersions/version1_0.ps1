"""
SnuPape v1.0
Made by 0Nikola0
GitHub: https://github.com/0Nikola0/SnuePape


This is an old version
It scrapes the HTML from the page 
and extracts the image links from there
It's slow and not reliable
If the top post is not an image
the script just stops working

Don't use this one, use the new one

Last update: 10.03.2021
"""

# Find the top upvoted post of the day
$subreddit = "r/wallpapers"
$postClassName = "_3jOxDPIQ0KaOWpzvSQo-1s"
$URL = "https://www.old.reddit.com/{0}/top" -f $subreddit
$Scraper = Invoke-WebRequest -Uri $URL
$postLink = $Scraper.ParsedHtml.getElementsByTagName("a") | Where {$_.className -eq $postClassName} | Select-Object -First 1
$postLink = $postLink.href
Write-Host "Looking for today's top upvoted post"

# Find the picture url
$imageClassName = "_2_tDEnGMLxpM6uOa2kaDB3 ImageBox-image media-element _1XWObl-3b9tPy64oaG6fax"
$Scraper = Invoke-WebRequest -Uri $postLink
$imageElement = $Scraper.ParsedHtml.getElementsByTagName("img") | Where {$_.className -eq $imageClassName} | Select-Object -First 1
# We can't directly find the anchor tag, so we have to find the preview image and then go to the parent node
$wallpaperLink = $imageElement.ParentNode.href

# Path to download folder
$currentDirectory = Get-Location
$folderPath = "{0}\Wallpapers\" -f $currentDirectory
# Check if folder exists, if not create it
if (!(Test-Path $folderPath)){
    New-Item -Path $folderPath -ItemType directory -Force | Out-Null
}

# Names and stuff
$fileName = -join $wallpaperLink[18..($wallpaperLink.Length-1)]
$wallpaperPath = ("{0}{1}" -f $folderPath, $fileName)
Write-Host "Downloading the image"

# Download the picture
Invoke-WebRequest $wallpaperLink -OutFile $wallpaperPath
Write-Host "Download finished"
Write-Host "Updating the wallpaper"

# Set it as wallpaper
$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
    }
 } 
'@

add-type $code 

#Apply the Change on the system 
[Win32.Wallpaper]::SetWallpaper($wallpaperPath)
