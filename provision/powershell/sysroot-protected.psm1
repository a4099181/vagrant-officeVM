<#
    .SYNOPSIS
    This module copies sysroot-protected folder into c: drive.

    .DESCRIPTION
    This module:
    * looks for every file in sysroot-protected folder
    * decrypts all files found
    * copies decrypted contents to expected destinations

    See also: utils\Encrypt-Json.ps1

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : sysroot-protected.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Copy-SysrootProtected (
      [Parameter(Mandatory=$true)] [String] $KeyFile )
{
    Get-ChildItem -Path 'C:\vagrant\sysroot-protected' -Recurse -File |
        Select-Object -ExpandProperty FullName |
    % {
        $secureString = Get-Content $_ |
            ConvertTo-SecureString -Key (Get-Content $KeyFile)
        $destination  = $_.Replace("vagrant\sysroot-protected\","")

        New-Item -Path "$($destination)" -ItemType File -Force

        New-Object      System.Net.NetworkCredential ("n/a", $secureString) |
            Select-Object                    -ExpandProperty Password |
            Set-Content   "$($destination)"
    }
}
