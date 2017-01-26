<#
    .SYNOPSIS
    Encrypts Value property of the piece of JSON.

    .PARAMETER Json
    A piece of the JSON file.

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : crypto.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Encrypt(
      [Parameter(Mandatory=$true)] $Json
    , [Parameter(Mandatory=$true)][String] $KeyFile)
{
    $Json.psobject.Properties |
        % {
            $_.Value = ( $_.Value |
                ConvertTo-SecureString   -AsPlainText -Force |
                ConvertFrom-SecureString -Key (Get-Content $KeyFile ) )
        }
}
<#
    .SYNOPSIS
    Decrypts Value property of the piece of JSON.

    .PARAMETER Json
    A piece of the JSON file.

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : crypto.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Decrypt(
      [Parameter(Mandatory=$true)] $Json
    , [Parameter(Mandatory=$true)][String] $KeyFile)
{
    $Json.psobject.Properties |
        % {
            $secureString = $_.Value |
                ConvertTo-SecureString -Key (Get-Content $KeyFile)

            $_.Value = ( New-Object System.Net.NetworkCredential ("n/a", $secureString) |
                Select-Object -ExpandProperty Password )
        }
}
