# file    : CryptoLib.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This file is a pseudo-library with basic functions for encryption.

function Encrypt($json, $key)
{
    $json.psobject.Properties                                              `
        | ForEach-Object                                                   `
        {                                                                  `
            $_.Value = ( $_.Value                                          `
                     | ConvertTo-SecureString   -AsPlainText               `
                                                -Force                     `
                     | ConvertFrom-SecureString -Key (Get-Content $key ) ) `
        }
}

function Decrypt ($json, $key)
{
    $json.psobject.Properties                                                           `
        | ForEach-Object                                                                `
        {                                                                               `
            $secureString = $_.Value                                                    `
                          | ConvertTo-SecureString -Key (Get-Content $key)              `

            $_.Value = ( New-Object System.Net.NetworkCredential ("n/a", $secureString) `
                         | Select-Object -ExpandProperty Password )                     `
        }
}
