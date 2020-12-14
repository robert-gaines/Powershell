$currentUser = $env:USERNAME

$coreList = @('WIN-M-CE-1','WIN-M-CE-2','WIN-M-CE-3','WIN-M-CE-4')

$desktopList = @('WIN-M-DC','WIN-M-DTP-1','WIN-M-DTP-2')

$coreList | Foreach-Object { 
                                New-Item -ItemType directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\$_" | Out-Null

                                Import-VM -Path "C:\Users\robert.gaines\Desktop\Lab\Source-VHD\Core-Disk\Virtual Machines\8232ED6A-DB9C-40E9-BB55-5856F38EB862.vmcx" `
                                          -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_" `
                                          -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                          -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                          -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\"

                                Rename-VM "Core-Disk" -NewName $_
                           }

$desktopList | Foreach-Object { 
                                New-Item -ItemType directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\$_" | Out-Null

                                Import-VM -Path "C:\Users\robert.gaines\Desktop\Lab\Source-VHD\Desktop-Disk\Virtual Machines\8232ED6A-DB9C-40E9-BB55-5856F38EB862.vmcx" `
                                          -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_" `
                                          -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                          -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\" `
                                          -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\$_\"

                                Rename-VM "Desktop-Disk" -NewName $_
                           }

New-Item -ItemType directory -Path "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1" | Out-Null

Import-VM -Path "C:\Users\robert.gaines\Desktop\Lab\Source-VHD\Core-Disk\Virtual Machines\8232ED6A-DB9C-40E9-BB55-5856F38EB862.vmcx" `
          -Copy -GenerateNewId -SmartPagingFilePath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1\" `
          -SnapshotFilePath   "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1\" `
          -VhdDestinationPath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1\" `
          -VirtualMachinePath "C:\Users\$currentUser\Desktop\Lab\VHD\WIN-M-CE-1\"

Rename-VM "Core-Disk" -NewName WIN-M-CE-1