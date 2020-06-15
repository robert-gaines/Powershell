<# Create AD Groups #>

<#
    Departmental OU's
    -----------------
    OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
    OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local
 #>

 function CreateITGroups()
 {

    New-ADGroup -Path "OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "IT All Users" `
                -DisplayName "IT All Users" `
                -SamAccountName "IT-All-Users" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Parent group for the IT department"

    New-ADGroup -Path "OU=IT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "IT Administrators" `
                -DisplayName "IT Administrators" `
                -SamAccountName "IT-Administrators" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "IT Administrators"
 }

 function CreateFinanceGroups()
 {

    New-ADGroup -Path "OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Finance All Users" `
                -DisplayName "Finance All Users" `
                -SamAccountName "Finance-All-Users" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Parent group for the Finance department"

    New-ADGroup -Path "OU=FINANCE,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Finance Administrators" `
                -DisplayName "Finance Administrators" `
                -SamAccountName "Finance-Administrators" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Finance Administrators"
 }

 function CreateHRGroups()
 {

    New-ADGroup -Path "OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "HR All Users" `
                -DisplayName "HR All Users" `
                -SamAccountName "HR-All-Users" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Parent group for the HR department"

    New-ADGroup -Path "OU=HR,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "HR Administrators" `
                -DisplayName "HR Administrators" `
                -SamAccountName "HR-Administrators" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "HR Administrators"
 }

 function CreateSalesGroups()
 {

    New-ADGroup -Path "OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Sales All Users" `
                -DisplayName "Sales All Users" `
                -SamAccountName "SALES-All-Users" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Parent group for the Sales department"

    New-ADGroup -Path "OU=SALES,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Sales Administrators" `
                -DisplayName "Sales Administrators" `
                -SamAccountName "SALES-Administrators" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "SALES Administrators"
 }

 function CreateManagementGroups()
 {

    New-ADGroup -Path "OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Management All Users" `
                -DisplayName "Management All Users" `
                -SamAccountName "MANAGEMENT-All-Users" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "Parent group for the Managerial Staff"

    New-ADGroup -Path "OU=MANAGEMENT,OU=WINLAB-CORP,DC=homelab,DC=winlab,DC=local" `
                -Name "Management Administrators" `
                -DisplayName "Management Administrators" `
                -SamAccountName "MANAGEMENT-Administrators" `
                -GroupCategory "Security" `
                -GroupScope DomainLocal `
                -Description "MANAGEMENT Administrators"
 }

# CreateITGroups

# CreateFinanceGroups

# CreateHRGroups

# CreateSalesGroups

# CreateManagementGroups