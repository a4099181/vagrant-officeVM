# file    : extend-PATH-environment-variable.ps1
# author  : bryjamus <bryjamus@gmail.com>
# license : MIT

# This script:
# * Adds to %PTH% environment variable paths

Function AddTo-SystemPath {
  Param([array] $PathToAdd)
  $VerifiedPathsToAdd = $Null
  Foreach ($Path in $PathToAdd) {
    if ($env:Path -like "*$Path*") {
      Write-Host "Currnet item in path is: $Path"
      Write-Host "$Path already exists in Path statement"
    }
    else {
      $VerifiedPathsToAdd += ";$Path"
      Write-Host "`$VerifiedPathsToAdd updated to contain: $Path"
    }         

    if($VerifiedPathsToAdd -ne $null) {
      Write-Host "`$VerifiedPathsToAdd contains: $verifiedPathsToAdd"
      Write-Host "Adding $Path to Path statement now..."
      [Environment]::SetEnvironmentVariable("Path",$env:Path + $VerifiedPathsToAdd,"Process")
    }
  }
}

$Path = Join-Path $ENV:UserProfile 'bin'

AddTo-SystemPath(@($Path))