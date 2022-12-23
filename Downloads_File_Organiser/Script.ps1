$CurrentUser = (Get-ChildItem Env:\USERNAME).value
$DownloadFolderFiles = Get-ChildItem -file -Path "C:\Users\$CurrentUser\downloads" 



$ExtensionTypes = @{
    documents   = @{
        extensions = @('.doc', '.docx', '.csv', '.docx', '.scss', '.pdf', '.xls', '.xlsx', '.txt'); 
        folder     = @('Documents_Sorted')
    }
    images      = @{
        extensions = @('.ico', '.gif', '.jpg', '.jpeg', '.png', '.svg', '.bmp', '.psd', '.tif')
        folder     = @("Images_Sorted")
    }
    executables = @{
        extensions = @('.apk', '.bat', '.bin', '.cgi', '.pl', '.com', '.exe', '.gadget', '.jar', '.msi', '.py', '.wsf')
        folder     = @("Executables_Sorted")
    }
    audio       = @{
        extensions = @('.aif', '.cda', '.mid', '.midi', '.mp3', '.mpa', '.ogg', '.wav', '.wma', '.wpl', '.sfk')
        folder     = @("Audio_Sorted")
    }
    compressed  = @{
        extensions = @('.7z', '.arj', '.deb', '.pkg', '.rar', '.rpm', '.tar.gz', '.z', '.zip')
        folder     = @("Compressed_Sorted")
    }
    web         = @{
        extensions = @('.asp', '.cer', '.cfm', '.cgi', '.css', '.htm', '.html', '.js', '.jsp', '.part', '.php', '.rss', '.xhtml', '.json')
        folder     = @("Web_sorted")
    }
    video       = @{
        extensions = @('.3g2', '.3gp', '.avi', '.flv', '.h264', '.m4v', '.mkv', '.mov', '.mp4', '.mpg', '.mpeg', '.rm', '.swf', '.vob', '.wmv')
        folder     = @("Video_Sorted")
    }
}



function MoveFiles($enum) {
    
    foreach ($extension in $enum.Value.extensions) {
        $DownloadFolderFiles | Where-Object { $_.extension -eq $extension }  | Move-Item -Destination "C:\Users\$CurrentUser\downloads\$($enum.Value.folder)"
    }
    
}


function TestAndCreateFolders {
    foreach ($enum in $ExtensionTypes.GetEnumerator()) {
        
        if (Test-Path  -Path "C:\Users\$CurrentUser\downloads\$($enum.Value.folder)") {
            Write-Output "$($enum.Value.folder) already exists"
            MoveFiles($enum)
        }
        else {
            try {

                New-Item -Path "C:\Users\$CurrentUser\downloads" -name "$($enum.Value.folder)" -ItemType Directory
                MoveFiles($enum)
            }
            catch {
                Write-Warning "Unable to create $($enum.Value.folder)"
            }
        }


        
    }
}





TestAndCreateFolders