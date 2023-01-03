<# ================================ DESCRIPTION================================ #>

# This script organizes your chosen directory according to file extension. It will create a new folder for each extension type object within the chosen directory
# Script not targeting a specific file extension? Check the $ExtensionTypes variable and add the extension to any of the extensions arrays, or add another file type array with your own folder name and extension types
# Note: This script is NOT run recursively i.e it only targets files directly in the downloads folder and NOT files in sub-folders



<# ================================ VARIABLES ================================ #>

$ErrorOccurred = $False




$ExtensionTypes = @(
    [PSCustomObject]@{
        type       = 'Documents'
        extensions = @('.doc', '.docx', '.csv', '.pdf', '.xls', '.xlsx', '.txt'); 
        folder     = 'Documents_Sorted'
    }
    [PSCustomObject]@{
        type       = 'Images'
        extensions = @('.ico', '.gif', '.jpg', '.jpeg', '.png', '.svg', '.bmp', '.psd', '.tif')
        folder     = "Images_Sorted"
    }
    [PSCustomObject]@{
        type       = 'Executables'
        extensions = @('.apk', '.bat', '.bin', '.cgi', '.pl', '.com', '.exe', '.gadget', '.jar', '.msi', '.py', '.wsf', '.img')
        folder     = "Executables_Sorted"
    }
    [PSCustomObject]@{
        type       = 'Audio'
        extensions = @('.aif', '.cda', '.mid', '.midi', '.mp3', '.mpa', '.ogg', '.wav', '.wma', '.wpl', '.sfk')
        folder     = "Audio_Sorted"
    }
    [PSCustomObject]@{
        type       = 'Compressed'
        extensions = @('.7z', '.arj', '.deb', '.pkg', '.rar', '.rpm', '.tar.gz', '.z', '.zip')
        folder     = "Compressed_Sorted"
    }
    [PSCustomObject]@{
        type       = 'Web'
        extensions = @('.asp', '.cer', '.cfm', '.cgi', '.css', '.scss', '.htm', '.html', '.js', '.jsp', '.part', '.php', '.rss', '.xhtml', '.json')
        folder     = "Web_sorted"
    }
    [PSCustomObject]@{
        type       = 'Video'
        extensions = @('.3g2', '.3gp', '.avi', '.flv', '.h264', '.m4v', '.mkv', '.mov', '.mp4', '.mpg', '.mpeg', '.rm', '.swf', '.vob', '.wmv')
        folder     = "Video_Sorted"
    }
)




<# ================================ FUNCTIONS & CMDLETS ================================ #>

function Get-Folder {

    Add-Type -AssemblyName System.Windows.Forms
    $OpenFolder = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
    $OpenFolder.ShowNewFolderButton = $true
    $OpenFolder.Description = "Select a folder to sort. (Sorting is NOT recursive)"
    $Result = $OpenFolder.ShowDialog()
     
    If ($result -eq 'OK') {
         
        $OpenFolder.SelectedPath
    }
    else {
            
        throw  "Please select a valid folder"
    }
}

function New-Folder {
    param([string]$Path, [string]$FolderName)

    $Exists = Test-Path -Path "$Path\$FolderName" -PathType Container


    if ($Exists -eq $True) {
        Write-Host "$FolderName already exists in $Path. Skipping folder creation" -ForegroundColor Gray
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
            Write-Host "File $($file.name) already exists in $Destination. Overwrite? (Y/N)" -ForegroundColor Red -BackgroundColor White
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
            try {

                $file | Move-Item -Destination $Destination -ErrorAction Stop
                Write-Host -ForegroundColor Green "File $($file.name) moved to $Destination"
            }
            catch {
                Write-Error "Unable to move file"
            }
        }
       
    }
}

<# ================================ LOGIC ================================ #>


try {

    $BasePath = Get-Folder -ErrorAction stop
    <# Can be used when -recurse is required
    $DownloadFolderFiles = Get-ChildItem -file -Path $BasePath -Recurse | Where-Object {$_.Directory -notlike "*_sorted"}  #>
    $DownloadFolderFiles = Get-ChildItem -file -Path $BasePath -ErrorAction stop

}
catch {
    Write-Warning $Error[0].Exception
    $ErrorOccurred = $true
}


if (!$ErrorOccurred) {

    foreach ($object in $ExtensionTypes) {
        
        New-Folder -Path $BasePath -FolderName $object.folder
        
        
        foreach ($extension in $object.extensions) {
            
            Move-Files -Destination "$BasePath\$($object.folder)" -Files $DownloadFolderFiles -ExtensionFilter $extension
        }
        
    }
}


