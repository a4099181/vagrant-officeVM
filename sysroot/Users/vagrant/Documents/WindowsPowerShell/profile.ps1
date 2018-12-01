$InformationPreference= 'Continue'

Get-ChildItem \\files\Users\sebastian.mach\.psrc.ps1, ~\OneDrive*\.psrc.ps1 -ErrorAction Ignore | ForEach-Object {
    . $_.FullName
}

@("${env:ProgramFiles(x86)}\Microsoft Visual Studio\", "${env:ProgramFiles}\Microsoft Visual Studio\") |
    Where-Object { Test-Path $_ } |
    ForEach-Object { Get-ChildItem $_ -Recurse -Include msbuild.exe, devenv.exe |
        Group-Object -Property Name |
        ForEach-Object { Set-Alias -Verbose -Name $_.Name[2].ToString().ToLower() -Value "$($_.Group[0].FullName)" }
    }

@("${env:ProgramFiles(x86)}\JetBrains", "${env:ProgramFiles}\IIS Express") |
    Where-Object { Test-Path $_ } |
    ForEach-Object {
        Get-ChildItem $_ -Recurse -Include iisexpress.exe, rider64.exe |
            Group-Object -Property Name |
            ForEach-Object { Set-Alias -Verbose -Name $_.Name[0].ToString().ToLower() -Value "$($_.Group[0].FullName)" }
    }

Get-Command docker, explorer, git, kubectl |
    ForEach-Object { Set-Alias -Verbose -Name $_.Name[0] -Value ( $_.Name -replace "$($_.Extension)$", "" ) }

function Update-SysRoot {
    param ([switch] $whatif)
    Get-ChildItem -Recurse C:\vagrant\sysroot\ -File |
    Select-Object @{N='local';E={[System.IO.FileInfo]::new(($_.FullName -replace 'C:\\vagrant\\sysroot\\', 'C:\'))}},@{N='remote';E={$_}} |
    Where-Object { $_.local.LastWriteTimeUtc -gt $_.remote.LastWriteTimeUtc } |
    ForEach-Object {
        Copy-Item -path $_.local.FullName -Destination $_.remote.FullName -Verbose -WhatIf:($whatif.IsPresent)
    }
}

function Get-FreeDiskSpace
{
    param (
        [string] $driveName = "C",
        [int] $yellowThreshold = 15,
        [int] $orangeThreshold = 10,
        [int] $redThreshold = 5
    )

    $drive = Get-PSDrive -Name $driveName
    $free = 100 * $drive.Free / ($drive.Used + $drive.Free)

    if ($free -lt $redThreshold) {
        @{
          "Light"= [ConsoleColor]::Red;
          "Free" = $drive.Free
        }
      }
    elseif ($free -lt $orangeThreshold) {
        @{
          "Light"= [ConsoleColor]::Yellow;
          "Free" = $drive.Free
        }
      }
    elseif ($free -lt $yellowThreshold) {
        @{
            "Light"= [ConsoleColor]::Gray;
            "Free" = $drive.Free
        }
    }
}

function Write-Tips
{
    Write-Information "WinRM tip: (<IP>) | % { Set-Item WSMan:\localhost\Client\TrustedHosts -Concatenate -Value `$_ }"
}

if ( ( Get-Command kubectl ) )
{
    if (Get-Command code -ErrorAction SilentlyContinue)
    {
        $env:KUBE_EDITOR='code --wait'
    }

        $__k8sPromptScriptBlock = {

        $state = @{ exitCode=$LASTEXITCODE; fail=(-not $?)}
        $date = Get-Date
        $date_offset = ($date-$date.ToUniversalTime()).TotalHours.ToString("+#") -replace "\+\-", "-"
        Write-Host $date.ToUniversalTime().ToString("HH:mm.ssZ$($date_offset)") -Foreground Cyan -NoNewLine
        if (($state.exitCode -gt 0) -or $state.fail ) {
            Write-Host " $($state.exitCode)" -Foreground Red -NoNewLine
        }
        Write-Host " [" -Foreground Yellow -NoNewLine
        Write-Host "k8s: " -Foreground DarkGray -NoNewLine
        Write-Host (( & ( Get-Command kubectl ).Source config view -o json) | ConvertFrom-Json | select -ExpandProperty contexts -first 1).context.namespace -Foreground Gray -NoNewLine
        Write-Host "] " -Foreground Yellow -NoNewLine

        $free = Get-FreeDiskSpace
        if ($free.Light -in ( [ConsoleColor]::Gray, [ConsoleColor]::Red, [ConsoleColor]::Yellow ))
        {
            Write-Host "[" -Foreground Yellow -NoNewLine
            Write-Host "$(($free.Free / 1gb).ToString('n1'))GB" -Foreground $free.Light -NoNewLine
            Write-Host "] " -Foreground Yellow -NoNewLine
        }

        if ( $GitPromptScriptBlock )
        {
            Invoke-Command -ScriptBlock $GitPromptScriptBlock
        }
    }

    Set-Item Function:\prompt -Value $__k8sPromptScriptBlock

    Import-Module PSKubectlCompletion
}
