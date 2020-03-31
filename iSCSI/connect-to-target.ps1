$target = "iqn.1991-05.com.microsoft:hl-dc-main-cluster-iscsi-target-target"

Invoke-Command -VMName HV-CORE-1 -Credential HOMELAB\Administrator -ScriptBlock {

                                                                                    Get-IscsiTarget

                                                                                }