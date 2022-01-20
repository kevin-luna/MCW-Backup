#Options
[CmdletBinding()]
param (
    
    #Mandatory parameters
    [Parameter(Mandatory)]
    [ValidateSet("Bedrock","Java")]
    [String]$MinecraftVersion,
    
    #Optional parameters
    [Parameter()]
    #The default output folder is this
    [System.IO.DirectoryInfo]$OutputFolder = "C:\Users\$env:USERNAME\Minecraft Backups",
    [Switch]$BackupAll,
    [String]$World
    #Default file type for output backup is 7z
    # [String]$FileType = "7z"
)

    #Select Minecraft Version
    if($MinecraftVersion -eq "Bedrock"){
        $minecraft_worlds_folder = "C:\Users\$env:USERNAME\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds"
    }elseif($MinecraftVersion -eq "Java"){
        $minecraft_worlds_folder = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft\saves"
    }
    
    
    #The option for change the output file format its pendient
    # #Select file output type if it's not default
    # if(($FileType -ne "7z") -or ($FileType -ne "zip") -or ($FileType -ne "gzip") -or ($FileType -ne "bzip2") -or ($FileType -ne "tar")){
    # }
    
    function Get-WorldList{
        # $worlds stores all the folder objects inside the $minecraft_worlds_folder
        $worlds =  @(Get-ChildItem -Path $minecraft_worlds_folder -Directory)
        # $worldlist stores only the name and full path of each world founded
        $worldlist = @{}
        # Iterates over $worlds for each folder and adds and element to $worldlist
        foreach($item in $worlds) {
            $folderName = $item.Name
            #The full path of the world folder
            $folderFullPath = $item.FullName
            if($MinecraftVersion -eq "Bedrock"){
                #Reads the content of levelname.txt toget the world name
                $worldName =  Get-Content -Path "$folderFullPath\levelname.txt"
            }elseif ($MinecraftVersion -eq "Java"){
                $worldName = $folderName
            }
            
            $worldlist.Add($worldName,$folderFullPath)
        }
        $worldlist
    }
    
    Write-Host -ForegroundColor Yellow "Searching for worlds in the local folder..."
    $worldlist = Get-WorldList
    
    # If no worlds are founded the script exit
    if($worldlist.Count -lt 1){
        Write-Error "No worlds were founded!"
        exit
    }

    $date =  Get-Date -Format "ddMMyyyy-HHmmss"
    $output_filename = "$OutputFolder\$World-$date"
    
    if($BackupAll){
        $output_filename = "$OutputFolder\MyWorlds-$date"
        $worldBkp = $minecraft_worlds_folder
    }elseif($World -eq ""){
        do {
            $World = Read-Host -Prompt "Supply a world for the backup"
        } while ($World -eq "")
        $output_filename = "$OutputFolder\$World-$date"
    }
    
    #Checks if exists a world with the name given
    if($worldlist.ContainsKey($World)){
        $output_filename = "$OutputFolder\$World-$date"
        $worldBkp = $worldlist[$World]
        Write-Host -ForegroundColor Green "The world $World was founded!"
    }
    
    Write-Host -ForegroundColor Green "Compressing the World..."
    #Check if 7zip its installed
    if(Test-Path "C:\Program Files\7-Zip\7z.exe"){
        #you can specify another path for 7zip installation
        Set-Alias -Name Compress -Value "C:\Program Files\7-Zip\7z.exe"
        Compress a -t7z "$output_filename.7z" "$worldBkp" -mx=9 -mmt=on > $null
    }else {
        Write-Host -ForegroundColor Yellow "7zip it's not installed, using Compress-Archive instead..."
        Compress-Archive -Path "$worldBkp" -DestinationPath "$output_filename.zip" > $null
    }
    
    if($LASTEXITCODE -eq 0){
        # Write-Host -ForegroundColor Green "Everything is ok"
        Write-Host -ForegroundColor Green "The backup was created successfully!"
    }else{
        Write-Error "The backup couldnt be created"
    }
