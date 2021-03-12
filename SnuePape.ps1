Write-Host "
SnuePape v2.0
Made by 0Nikola0
GitHub: https://github.com/0Nikola0/SnuePape
" -ForegroundColor Green -BackgroundColor Black


<# 
You can change the subreddit to something else
Example subreddits: 
    r/Wallpaper
    r/Wallpapers
    r/MinimalWallpaper
    r/WQHD_Wallpaper
    r/EarthPorn
    r/CityPorn
    r/CarPorn
    r/ExposurePorn
#>
$subreddit = "r/MinimalWallpaper"


function getWallpaperLink($subreddit){
    Write-Host "[>]" -ForegroundColor Green -NoNewLine
    Write-Host "Sending request to the site"

    # Sending request to the site
    $URL = "http://www.reddit.com/{0}/top.json" -f $subreddit
    $response = Invoke-WebRequest -Uri $URL 
    $results = $response.Content | ConvertFrom-Json
    $data = $results.data.children.data

    Write-Host "[>]" -ForegroundColor Green -NoNewLine
    Write-Host "Looking for images"

    # Loops through the found links and checks for images
    foreach ($post in $data){
        if ($post.url.endsWith('.jpg') -or $post.url.endsWith('.png')){
            # Returns the post ONLY if its not NSFW (mature conent), if it is it continues looping
            if (!$post.over_18){
                return $post
            }
        }
    }
}


function downloadImage($post){
    # Get path to current directory and add the wallpapers folder
    $currentDirectory = Get-Location
    $folderPath = "{0}\Wallpapers\" -f $currentDirectory

    # Check if folder exists, if not create it
    if (!(Test-Path $folderPath)){
        New-Item -Path $folderPath -ItemType directory -Force | Out-Null
    }

    # Setting up path for downloading the image
    # Trimming for whitespace and replacing dots so it doesn''t change file type
    $fileName = $post.title.Trim()
    $fileName = $fileName.Replace(".", "-")
    # Square brackets are treated as wild cards and creates problems when saving the image
    $fileName = $fileName.Replace("[", "{") 
    $fileName = $fileName.Replace("]", "}")
    
    # Keeping the same file extension as the original
    $fileExtension = -join ($post.url[($post.url.Lenght-4)..($post.url.Lenght-1)])

    $wallpaperFile = "{0}{1}{2}" -f $folderPath, $fileName, $fileExtension
    Write-Host "[>]" -ForegroundColor Green -NoNewLine
    Write-Host "Downloading the image"

    # Downloading the image
    Invoke-WebRequest $post.url -OutFile $wallpaperFile
    Write-Host "[>]" -ForegroundColor Green -NoNewLine
    Write-Host "Image downloaded"

    # Return the path to the wallpaper
    return $wallpaperFile
}


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


Write-Host "[>]" -ForegroundColor Green -NoNewLine
Write-Host "Starting"

# Function calling starts here
$post = getWallpaperLink($subreddit)
$wallpaperFile = downloadImage($post)

Write-Host "[>]" -ForegroundColor Green -NoNewLine
Write-Host "Setting the image as your wallpaper"

# Apply the Change on the system 
[Win32.Wallpaper]::SetWallpaper($wallpaperFile)
