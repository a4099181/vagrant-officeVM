Get-ChildItem $env:USERPROFILE\.docker -Filter "*.ps1" | % { . $_.FullName }

if ( Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\" )
{
    New-Alias -Verbose -Name b -Value (
        Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\" -Recurse -Include msbuild.exe |
        Select-Object -ExpandProperty FullName -last 1
    )
}

Get-Command docker, explorer, git, kubectl |
    ForEach-Object { New-Alias -Verbose -Name $_.Name[0] -Value ( $_.Name -replace "$($_.Extension)$", "" ) }

function Clear-TestDatabases
{
    sqllocaldb info |
        ForEach-Object {
            $i = $_;
            sqlcmd -S "(localdb)\$i" -E -h-1 -Q "SET NOCOUNT ON; SELECT name FROM sysdatabases" |
            Where-Object { $_ -like 'nunit_*' } |
            ForEach-Object {
                Write-Warning -Message $_
                sqlcmd -S "(localdb)\$i" -E -h-1 -Q "DROP DATABASE $_;"
            }
        }
}

if ( ( Get-Command kubectl ) )
{
    function Switch-K8sNamespace
    {
        Param(
            [Parameter(Mandatory=$true)]
            [ValidateSet('ci-soneta', 'default', 'kube-system', 'test-soneta')]
            [String]
            $namespace
        )

        & ( Get-Command kubectl ).Source config set-context --current --namespace $($namespace)

        ( ( & ( Get-Command kubectl ).Source config view -o json) | ConvertFrom-Json).contexts[0].context
    }

    New-Alias -Verbose -Name sn -Value Switch-K8sNamespace

        if ( (Get-Command ssh) -And ( -Not ( Test-Path ~\.kube\config ) ) )
        {
            New-Item ~\.kube -Verbose -ItemType Directory -Force | Out-Null
            ssh vagrant@master-vh1 cat ~/.kube/config | Set-Content -Verbose -Path ~/.kube/config
        }

        $__k8sPromptScriptBlock = {
        Write-Host (Get-Date).ToUniversalTime().ToString("HH:mm.ssZ") -Foreground Cyan -NoNewLine
        Write-Host " [" -Foreground Yellow -NoNewLine
        Write-Host "k8s: " -Foreground DarkGray -NoNewLine
        Write-Host (( & ( Get-Command kubectl ).Source config view -o json) | ConvertFrom-Json | select -ExpandProperty contexts -first 1).context.namespace -Foreground Gray -NoNewLine
        Write-Host "] " -Foreground Yellow -NoNewLine
        if ( $GitPromptScriptBlock )
        {
            Invoke-Command -ScriptBlock $GitPromptScriptBlock
        }
    }

    Set-Item Function:\prompt -Value $__k8sPromptScriptBlock

    Import-Module PSKubectlCompletion
}