# How it works
First the script scrapes the today's top page of the selected page.
Then after it has found the most upvoted page for the day, it opens it and gets the link where the image is hosted (so the original quality can be preserved)
After that it downloads the image in the wallpapers folder. And then finally sets the downloaded image as your wallpaper.

## How to run it
Just open powershell, navigate to the folder where the **SnuPape.ps1** script is located and run it. (`.\SnuPape.ps1`)

### Important
Error that happens often when trying to run the script:
```
Invoke-WebRequest : The underlying connection was closed: Could not establish trust relationship f
or the SSL/TLS secure channel.
```
If you get this error, run the **ignoreSSLCertifcate.ps1** script first and then **SnuPape.ps1**. You can combine the two by copying the **ignoreSSLCertificate.ps1** script at the start of the **SnuPape.ps1** so you don't have to run them separately