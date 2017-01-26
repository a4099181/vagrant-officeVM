# file    : non-privileged.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

$CfgFile="cfg.json"

Install-VisualStudio2017Extensions $CfgFile
Install-VisualStudioCodeExtensions $CfgFile
