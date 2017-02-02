Function Merge-ConfigurationFiles
{
<#
    .SYNOPSIS
    This function combines configuration files.

    .DESCRIPTION
    This function in details:
    * loads Newtonsoft.Json library from specified location,
    * parses all input files,
    * merges them in the specified order,
    * uses Newtonsoft.Json library with setting MergeArrayHandling.Union.

    .PARAMETER Files
    An Array of the configuration files to combine.

    .PARAMETER ModulesPath
    Path where installed Newtonsoft.Json package can be found.

    .OUTPUTS
    String

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Merge-ConfigurationFiles.md

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/config.psm1

    .LINK
    http://www.newtonsoft.com/json/help/html/MergeJson.htm

    .LINK
    http://www.newtonsoft.com/
#>
    Param ( [Parameter(Mandatory=$true)][String[]] $Files
          , [String] $ModulesPath = "C:\Program Files\WindowsPowerShell\Modules" )

    Get-Package newtonsoft.json |
        ForEach-Object { Add-Type -Path "$($ModulesPath)\$($_.Name)\$($_.Version)\libs\$($_.Name).dll" }

    $cmmn = [Newtonsoft.Json.Linq.JObject]::Parse(
        ( Get-Content -Raw ( $Files | Select-Object -First 1 ) ) )

    $Files |
        Select-Object -Skip 1 |
        ForEach-Object{
            $other = [Newtonsoft.Json.Linq.JObject]::Parse( ( Get-Content -Raw -Path $_ ) )

            $sets = New-Object -TypeName Newtonsoft.Json.Linq.JsonMergeSettings
            $sets.MergeArrayHandling = [Newtonsoft.Json.Linq.MergeArrayHandling]::Union

            $cmmn.Merge( $other, $sets )
        }

    return $cmmn.ToString()
}
