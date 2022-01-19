#Options
[CmdletBinding()]
param (
    
    #Mandatory parameters
    [Parameter(Mandatory)]
    [String]$MinecraftVersion,
    
    #Optional parameters
    [Parameter()]
    #The default output folder is this
    [String]$Output = "C:\Users\$env:USERNAME\Minecraft Backups\"
    #Default file type for output backup is 7z
    # [String]$FileType = "7z"
)

#Select Minecraft Version
if($MinecraftVersion -eq "Bedrock"){
    $minecraft_worlds_folder = "C:\Users\$env:USERNAME\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds"
}elseif($MinecraftVersion -eq "Java"){
    $minecraft_worlds_folder = "C:\Users\Kevin\AppData\Roaming\.minecraft\saves"
}else {
    Write-Error "Minecraft version unrecognized, plase choose one of the follow: Bedrock, Java"
    exit
}


#The option for change the output file format its pendient
# #Select file output type if it's not default
# if(($FileType -ne "7z") -or ($FileType -ne "zip") -or ($FileType -ne "gzip") -or ($FileType -ne "bzip2") -or ($FileType -ne "tar")){

# }


$date =  Get-Date -Format "ddMMyyyy-HHmmss"
$output_filename = "$Output\Pichichi-$date"
Write-Host -ForegroundColor Green "Compressing the World..."

#Check if 7zip its installed
if(Test-Path "C:\Program Files\7-Zip\7z.exe"){
    #you can specify another path for 7zip installation
    Set-Alias -Name Compress -Value "C:\Program Files\7-Zip\7z.exe"
    Compress a -t7z "$output_filename.7z" "$minecraft_worlds_folder\HqG5YEinEgA=" -mx=9 -mmt=on
}else {
    Write-Host -ForegroundColor Yellow "7zip it's not installed, using Compress-Archive instead..."
    Compress-Archive -Path "$minecraft_worlds_folder\HqG5YEinEgA=" -DestinationPath "$output_filename.zip"
}


if($LASTEXITCODE -eq 0){
    Write-Host -ForegroundColor Green "Everything is ok"
    Write-Host -ForegroundColor Green "The backup was created successfully!"
}else{
    Write-Error "The backup couldnt be created"
}