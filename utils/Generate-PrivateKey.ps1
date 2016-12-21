# file    : Generate-PrivateKey.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * generates private key for symmetric encryption 
#   based on a hash of the input file

# Usage: powershell /C Generate-PrivateKey.ps1 <input-file>

# Please note, that it is extremely simple solution. 
# Encryption used in this project is powered by the SecureString.
# All needed scripts may be short, simple 
# and encrypted content quite secure still.
# I think, that's enough. Don't forget to take care of your private key ;)

$secureKey = '..\.vagrant\my-private.key'

 Get-FileHash            $args[0]  -Algorithm MD5                               `
     | Select-Object               -ExpandProperty Hash                         `
     | Select-Object  @{                                                        `
         Name="ByteArray";                                                      `
         Expression={[System.Text.Encoding]::ASCII.GetBytes( $_ ) }             `
       }                                                                        `
     | Select                      -ExpandProperty ByteArray                    `
     | Out-File      $secureKey
