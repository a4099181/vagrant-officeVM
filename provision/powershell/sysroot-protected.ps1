# file    : sysroot-protected.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * looks for every file in sysroot-protected folder
# * decrypts all files found
# * copies decrypted contents to expected destinations
#
# See also: utils\Encrypt-Json.ps1

$secureKey = 'C:\vagrant\.vagrant\my-private.key'
$bytes = [System.IO.File]::ReadAllBytes($secureKey)
[System.Array]::Resize([ref] $bytes, 32);

Get-ChildItem                              -Path 'C:\vagrant\sysroot-protected' `
                                           -Recurse -File                       `
    | Select-Object                        -ExpandProperty FullName             `
    | ForEach-Object                                                            `
{
    $secureString = Get-Content $_                                              `
                  | ConvertTo-SecureString -Key ($bytes)
    $destination  = $_.Replace("vagrant\sysroot-protected\","")

    New-Item -Path "$($destination)" -ItemType File -Force

    New-Object      System.Net.NetworkCredential ("n/a", $secureString)         `
        | Select-Object                    -ExpandProperty Password             `
        |  Set-Content   "$($destination)"
}

<# Sample 1.
 # Generate private key for symmetric encryption based on a hash of the file:
 Get-FileHash        .\input.file  -Algorithm MD5                               `
     | Select-Object               -ExpandProperty Hash                         `
     | Select-Object  @{                                                        `
         Name="ByteArray";                                                      `
         Expression={[System.Text.Encoding]::ASCII.GetBytes( $_ ) }             `
       }                                                                        `
     | Select                      -ExpandProperty ByteArray                    `
     | Out-File      .\private.key
 #>
