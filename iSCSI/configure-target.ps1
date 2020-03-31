Invoke-Command -ComputerName HL-DC-MAIN -Credential HOMELAB\Administrator -ScriptBlock {
                                                                                            New-ISCSIServerTarget -TargetName "Cluster-Storage" 
                                                                                       }

# IQN: iqn.1991-05.com.microsoft:hl-dc-main-cluster-storage-target

Invoke-Command -ComputerName HL-DC-MAIN -Credential HOMELAB\Administrator -ScriptBlock {
                                                                                            Get-ISCSIServerTarget -TargetName "Cluster-Storage" 
                                                                                       }