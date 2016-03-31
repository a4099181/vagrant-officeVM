# file    : Encrypt-Json.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# Simple file encryptor based on SecureString with symmetric encryption key file.
# Pretty well designed to encrypt JSON formatted data
# but it is able to encrypt every file with single line.
# Encrypted data are preformatted to single line for succesful encryption.
#
# Usage: powershell /C Encrypt-Json.ps1 <file-to-encrypt>
#
# When you want to store encrypted data to file use:
# powershell /C "Encrypt-Json.ps1 <file-to-encrypt> | Set-Content <output-file>"
#
# This is not a cmdlet.

Get-Content $args[0]                -Raw                                          `
   | Select-Object                                                                `
           @{ Name='Oneline';                                                     `
              Expression={ $_.Replace("`r","" ).Replace("`n","") } }              `
   | Select-Object                  -ExpandProperty Oneline                       `
   | ConvertTo-SecureString         -AsPlainText                                  `
                                    -Force                                        `
   | ConvertFrom-SecureString       -Key (Get-Content .\.vagrant\my-private.key)
