<#
    .SYNOPSIS
    This module combines configuration files.

    .PARAMETER OutFile
    File path where combined configuration file is saved.

    .PARAMETER InFiles
    An Array of the files to merge.

    .NOTES
    File Name: config.psm1
    Author:    seb! <sebi@sebi.one.pl>
    License:   MIT
#>
Function Merge-ConfigurationFiles(
    [Parameter(Mandatory=$true)][String[]] $InFiles
    , [Parameter(Mandatory=$true)][String] $OutFile )
{
    $modulesPath="C:\Program Files\WindowsPowerShell\Modules"

    Get-Package newtonsoft.json |
        % { Add-Type -Path "$($modulesPath)\$($_.Name)\$($_.Version)\libs\$($_.Name).dll" }

    $cmmn = [Newtonsoft.Json.Linq.JObject]::Parse(
        ( Get-Content -Raw ( $InFiles | select -First 1 ) ) )

    $InFiles |
        select -Skip 1 |
        %{
            $other = [Newtonsoft.Json.Linq.JObject]::Parse( ( Get-Content -Raw -Path $_ ) )

            $sets = New-Object -TypeName Newtonsoft.Json.Linq.JsonMergeSettings
            $sets.MergeArrayHandling = [Newtonsoft.Json.Linq.MergeArrayHandling]::Union

            $cmmn.Merge( $other, $sets )
        }

    $cmmn.ToString() | Out-File -Encoding utf8 $OutFile
}

