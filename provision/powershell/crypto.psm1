Function Global:Encrypt
{
<#
    .SYNOPSIS
    Encrypts Value property of the piece of JSON.

    .PARAMETER Json
    A piece of the JSON file.

    .PARAMETER KeyFile
    Encryption key file.

    .INPUTS
    PSCustomObject (Json object)
#>
    Param ( [Parameter(Mandatory=$true)][String] $KeyFile
          , [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Json )

    Process
    {
        $Json.psobject.Properties |
            ForEach-Object {
                $_.Value = ( $_.Value |
                    ConvertTo-SecureString   -AsPlainText -Force |
                    ConvertFrom-SecureString -Key (Get-Content $KeyFile ) )
            }
    }
}

Function Global:Decrypt
{
<#
    .SYNOPSIS
    Decrypts Value property of the piece of JSON.

    .PARAMETER Json
    A piece of the JSON file.

    .PARAMETER KeyFile
    Encryption key file.

    .INPUTS
    PSCustomObject (Json object)
#>
    Param ( [Parameter(Mandatory=$true)][String] $KeyFile
          , [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Json )

    Process
    {
        $Json.psobject.Properties |
            ForEach-Object {
                $secureString = $_.Value |
                    ConvertTo-SecureString -Key (Get-Content $KeyFile)

                $_.Value = ( New-Object System.Net.NetworkCredential ("n/a", $secureString) |
                    Select-Object -ExpandProperty Password )
            }
    }
}

