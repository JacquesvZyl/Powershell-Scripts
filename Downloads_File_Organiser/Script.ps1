
<# ================================ VARIABLES ================================ #>

$CurrentUser = (Get-ChildItem Env:\USERNAME).value
$BasePath = "C:\Users\$CurrentUser\downloads" 
$DownloadFolderFiles = Get-ChildItem -file -Path $BasePath

$ExtensionTypes = @{
    documents   = @{
        extensions = @('.doc', '.docx', '.csv', '.scss', '.pdf', '.xls', '.xlsx', '.txt'); 
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




<# ================================ FUNCTIONS ================================ #>

function New-Folder {
    param([string]$Path, [string]$FolderName)

    $Exists = Test-Path -Path "$Path\$FolderName" -PathType Container


    if ($Exists -eq $True) {
        Write-Warning "$FolderName already exists in $Path. Skipping folder creation"
    }
    else {
        New-Item -Path $Path -name $FolderName -ItemType Directory
    }
}

function Move-Files {
    param([string]$Destination, [object]$Files, [string]$ExtensionFilter = '*')

    $FilteredFiles = $Files | Where-Object { $_.extension -eq $extensionFilter } 
    
    foreach ($File in $FilteredFiles) {
        

        $Exists = Test-Path -Path "$Destination\$($File.name)"
        
            
        if ($Exists -eq $true) {
            Write-Host "File $($file.name) already exists in $Destination. Overwrite? (Y/N)" -ForegroundColor Red
            $Choice = Read-Host " "
            if ($Choice -eq 'y') {
                $file | Move-Item -Destination $Destination -ErrorAction Stop -Force
                Write-Host -ForegroundColor Green "File $($file.name) moved to $Destination"
            }
            else {
                Write-Host "Skipping File '$($file.name)'"
            }
        }
        else {
                
            $file | Move-Item -Destination $Destination -ErrorAction Stop
            Write-Host -ForegroundColor Green "File $($file.name) moved to $Destination"
        }
       
    }
    
    
    
    
    
}



<# ================================ LOGIC ================================ #>

foreach ($enum in $ExtensionTypes.GetEnumerator()) {

    
    New-Folder -Path $BasePath -FolderName $enum.value.folder
    

    foreach ($extension in $enum.Value.extensions) {
        
        Move-Files -Destination "$BasePath\$($enum.value.folder)" -Files $DownloadFolderFiles -ExtensionFilter $extension
    }
        

}