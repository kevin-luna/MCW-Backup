# MCW-Backup

A Powershell script that automate the process of create backups for your Minecraft worlds, both Bedrock and Java Edition.

## Getting started

### Dependencies

You need to have installed [7zip](https://www.7-zip.org/download.html) to use the option `-FileType` or create backups bigger than 2GB of size, if it's not, the cmdlet `Compress-Archive` will be used for the compression of the output file.

### Download

Go and click on the green button "Code" and select the option "Download ZIP" or if you have `git` installed then can clone the repository with:

`git clone https://github.com/kevin-luna/MCW-Backup.git`

### Usage

#### Parameters

- `-MinecraftVersion`: Set the Minecraft Version for the worlds to be backed-up, it's always required for the script working.The posible options are `Bedrock` or `Java`.

- `-OutputFolder`: Set the output path for the backup file. The default value is `$HOME\Minecraft Backups` and also can be changed from the source. If the folder does not exist it'll be created.

- `-BackupAll`: If it's set, a backup of all the worlds existing for the selected version will be created; also the `-World` option will not can be used.

- `-World`: If it's set, only will be created a backup for the world with the name given of the selected version.

- `-FileType`: If 7zip it's installed you can select from the diferent format files supported: `7z, zip, gzip, bzip2, tar`. The default value is `7z`. If 7zip it's not installed the `zip` format always be used.

#### Examples

Create a backup of your entire Minecraft Worlds folder for Minecraft Bedrock Edition and will store it at `D:\My Worlds Backup` folder.

`.\MCW-Backup -MinecraftVersion Bedrock -BackupAll -OutputFolder 'D:\My Worlds Backup'`

Create a backup of your entire Minecraft Worlds folder for Minecraft Java Edition and will store it at default folder (`$HOME\Minecraft Backups`).

`.\MCW-Backup -MinecraftVersion Java -BackupAll`

Create a backup of the world 'My World' for Minecraft Java Edition and will store it at default folder (`$HOME\Minecraft Backups`).

`.\MCW-Backup -MinecraftVersion Java -World 'My World'`