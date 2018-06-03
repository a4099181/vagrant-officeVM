### Known problems

```
==> vs: Running provisioner: shell...
    vs: Running: script: Copy-GitRepositories C:\Users\vagrant\cfg.json .vagrant\my-private.key
    vs:     Directory: C:\Users\vagrant
    vs: Mode                LastWriteTime         Length Name
    vs: ----                -------------         ------ ----
    vs: d-----       24.11.2018     11:05                MyProjects
    vs: Warning: Permanently added the RSA host key for IP address '140.82.118.3' to the list of known hosts.
    vs: fatal: destination path 'enova' already exists and is not an empty directory.
    vs: fatal: destination path 'generator' already exists and is not an empty directory.
```

> Can be ignored. Git commands needs a review.

```
==> vs: Running provisioner: shell...
    vs: Running: script: Install-VisualStudio2017Extensions C:\Users\vagrant\cfg.json
    vs: C:\Users\vagrant\AppData\Local\Temp\enovaMSDN.SonetaStudioExtPackage.vsix
    vs: powershell.exe : Invoke-WebRequest : {"$id":"1","innerException":null,"message":"Anonymous usage from IP address 178
    vs:     + CategoryInfo          : NotSpecified: (Invoke-WebReque... IP address 178:String) [], RemoteException
    vs:     + FullyQualifiedErrorId : NativeCommandError
    vs: .19.100.140 has exceeded our rate limits and is being blocked. Anonymous access from this IP addres
    vs: s will be unblocked within the next 1 minute. You can also consider logging in to get unblocked. Lo
    vs: gged in users have higher limits. Learn more: https://go.microsoft.com/fwlink/?LinkId=823950.","typ
    vs: eName":"Microsoft.TeamFoundation.Framework.Server.RequestBlockedException, Microsoft.TeamFoundation
    vs: .Framework.Server","typeKey":"RequestBlockedException","errorCode":0,"eventId":3000}
    vs: At C:\Program Files\WindowsPowerShell\Modules\vagrant-provvin\modules\vs2017.psm1:101 char:17
    vs: +                 Invoke-WebRequest -Uri  $uri `
    vs: +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    vs:     + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke
    vs:    -WebRequest], WebException
    vs:     + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWe
    vs:    bRequestCommand

    vs: C:\Users\vagrant\AppData\Local\Temp\enovaMSDN.SonetaPlatformDeveloper.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\MS-vsliveshare.vsls-vs.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\JaredParMSFT.VsVim.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\ZoltanKlinger.RelativeLineNumbers.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\VisualStudioProductTeam.ProductivityPowerPack2017.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\EWoodruff.VisualStudioSpellCheckerVS2017andLater.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\MikeWard-AnnArbor.VSColorOutput.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\MadsKristensen.FileNesting.vsix
    vs: C:\Users\vagrant\AppData\Local\Temp\JustinClareburtMSFT.ColorThemesforVisualStudio.vsix
```

> Rate limits breaks the installation... New ideas are needed.
