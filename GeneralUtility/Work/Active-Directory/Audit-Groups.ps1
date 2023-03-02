<# Audit Group Membership in FAIS AD #>

<# Auth: RWG 05/20/2020 #>

$ErrorActionPreference = 'SilentlyContinue'

$topLevel  = "OU=Finance and Administration,OU=WSU,DC=ad,DC=wsu,DC=edu"

function TimeStamp()
{
    <#
        I - System Time
        P - Format System Time
        O - Formatted Time String
     #>

    $timeStamp = Get-Date -Format "_MM_dd_yyyy_HH_mm_ss"

    return $timeStamp
}

function SetLocation()
{
    <#
        I - Username from environment
        P - Set location to user's Desktop
        O - Working directory is set to the user's desktop
     #>

    $currentUser = $env:USERNAME

    $subjectPath = "C:\Users\$currentUser\Desktop\"

    Write-Host -ForegroundColor Yellow "[~] Setting location to: $subjectPath "

    Set-Location -Path $subjectPath
}

function CreateDirectory()
{
    <# 
        I - No Inputs
        P - Create a directory for the audit results
        O - Directory is created for the storage of results
     #>

    $dirName   =  "Group_Audit"
    $time      = TimeStamp
    $dirName  += $time

    Write-Host -ForegroundColor Yellow "[*] Creating directory for results: $dirName " ; Start-Sleep -Seconds 1 

    try
    {
        New-Item -Type Directory -Path $dirName 

        Write-Host -ForegroundColor Green "[*] Created directory: $dirName " ; Start-Sleep -Seconds 1
    }
    catch
    {
        Write-Host -ForegroundColor Red "[!] Failed to create directory: $dirName " ; Start-Sleep -Seconds 1

        exit
    }

    Set-Location $dirName

    $subjectDirectoryPath = Get-Location 

    return $subjectDirectoryPath
}

function EnumerateGroups($topLevel)
{
    <#
        I - Topmost OU for the hierarchy of interest
        P - Enumerate AD groups into a standard array
        O - An array containing all of the subordinate groups
     #>

    $fais_groups = @()

    Get-ADGroup -SearchBase $topLevel -Filter * | Foreach-Object { $fais_groups += $_.Name }

    return $fais_groups
}

function GenerateFilename()
{
    <#
        I - No Inputs
        P - Create a unique filename
        O - Return a unique filename 
     #>

    $base  = "anomalies"
    $time  = TimeStamp
    $fname = $base+$time+".txt"
    return $fname
}

function CompareMembership($groups,$subject_path)
{
    <#
        I - Array of AD Groups and the current working directory
        P - 1) Iterate through groups
            2) Identify each group member
            3) Query the member's individual group affiliation via object assessment
            4) Determine if the current group is represented within the object's properties
            5) If group membership is not reflected within the object's properties, write the anomaly to a unique file
        O - Directory containing audit results
            Subordinate directories with group specific anomalies listed in a flat file 
     #>
    $groups | Foreach-Object {
                                    $group = $_ 

                                    Get-ADGroupMember -Identity $group | Foreach-Object { 
                                                                                            $fname = GenerateFilename

                                                                                            if((Get-ADObject -filter {Name -like "$candidate"}).objectclass -ne 'group')
                                                                                            {
                                                                                                $obj      = $_.Name
                                                                                                $segments = $obj.Split("{,}")
                                                                                                $name     = $segments[0] 

                                                                                                Write-Host -BackgroundColor Black -ForegroundColor Yellow "[~] Assessing assigned vs.actual group membership for-> $group : $name "

                                                                                                Start-Sleep -Seconds 1

                                                                                                Clear-Host

                                                                                                $arr = @()

                                                                                                $var = Get-ADObject -SearchBase "DC=ad,DC=wsu,DC=edu" -Filter {name -eq $obj} -Properties MemberOf

                                                                                                $var.MemberOf | Foreach-Object { 
                                                                                                                                    $cns        = $_.Split("{,}"); 
                                                                                                                                    $cn         = $cns[0]; 
                                                                                                                                    $strlen     = $cn.length;
                                                                                                                                    $limit      = $cn.length-3
                                                                                                                                    $cn_refined = $cn.subString(3,$limit)
                                                                                                                                    $arr       += $cn_refined
                                                                                                                               }

                                                                                                if($arr -contains $group)
                                                                                                {
                                                                                                    #Write-Host -ForegroundColor Green "[*] Object is properly associated "
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    #Write-Host -ForegroundColor Red "[!] Improper association: $obj -> $group"

                                                                                                    $target_path = $subject_path.Path+'\'+$group

                                                                                                    if(Test-Path -Path $target_path)
                                                                                                    {
                                                                                                        Set-Location -Path $target_path
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        New-Item -Type Directory -Path $target_path -Verbose:$false

                                                                                                        Set-Location -Path $target_path
                                                                                                    }

                                                                                                    "[!] Improper association: $obj -> $group" | Out-File $fname -Append

                                                                                                }
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                pass
                                                                                            }
                                                                                        } 
                               Set-Location -Path ../
                            }
}

function main($topLevel)
{
    SetLocation

    $subjectDirPath = CreateDirectory
      
    $groups         = EnumerateGroups $topLevel

    $file_name      = GenerateFilename

    CompareMembership $groups $subjectDirPath
}

main $topLevel