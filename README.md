# What does this script do
The script sets your wallpaper to today's top upvoted reddit post (wallpaper if selected such subreddit)

### How does it do that
The script first sends a request to reddit. From the JSON response it extracts the top posts. After it has done that, the script checks whether the post is an image, if not it continues to the next one. If it is, it finds the link where the image is hosted and downloads it. And after it's been downloaded it finally gets set as your wallpaper.

## How to run it
Just open powershell, navigate to the folder where the **SnuPape.ps1** script is located and run it. (`.\SnuPape.ps1`)

## Common errors

**Can't run powershell scripts:**
```
SnuePape.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details
```
- Open powershell as adminstrator and run this snippet:

    `set-executionpolicy remotesigned`

  

**SSL/TLS secure channel error:**
```
Invoke-WebRequest : The underlying connection was closed: Could not establish trust relationship f
or the SSL/TLS secure channel.
```
- If you get this error, run the `.\ignoreSSLCertifcate.ps1` script first and then `.\SnuPape.ps1`. You can combine the two by copying the `.\ignoreSSLCertificate.ps1` script at the start of the `.\SnuPape.ps1` so you don't have to run them separately