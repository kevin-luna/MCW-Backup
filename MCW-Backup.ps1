Set-Alias -Name 7zip -Value "C:\Program Files\7-Zip\7z.exe"
$username = $env:USERNAME

$minecraft_worlds_folder = "C:\Users\$username\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds"

$date =  Get-Date -Format "dd-MM-yyyy"
$output_filename = "Pichichi-$date.7z"

Write-Host -ForegroundColor Green "Compressing the World..."
7zip a -t7z $output_filename "$minecraft_worlds_folder\HqG5YEinEgA=" -mx=9 -mmt=on > $null

if($LASTEXITCODE -eq 0){
    Write-Host -ForegroundColor Green "Everything is ok"
    Write-Host -ForegroundColor Green "The backup was created successfully!"
}else{
    Write-Error "The backup couldnt be created"
}