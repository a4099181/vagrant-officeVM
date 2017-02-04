---
external help file: vs2017-help.xml
online version: https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Install-VisualStudio2017Extensions.md
schema: 2.0.0
---

# Install-VisualStudio2017Extensions

## SYNOPSIS
This function installs Visual Studio 2017 extensions enumerated in configuration file.

## SYNTAX

```
Install-VisualStudio2017Extensions [-CfgFile] <String> [<CommonParameters>]
```

## DESCRIPTION
This function in details:
* takes a Visual Studio extensions list to install from configuration file,
* skips extensions marked as disabled,
* downloads all extensions left from Visual Studio Gallery,
* executes installer for each downloaded extension.

This script is designed to work with Visual Studio Marketplace.

## EXAMPLES

### Example 1
```
PS C:\> Install-VisualStudio2017Extensions cfg.json
```

### Example 2 Sample content of the `cfg.json`
```
{
    "vs2017"               : {
        "extensions"       : [
            {
                "publisher": "enovaMSDN",
                "name"     : "SonetaStudioExtPackage"
            },
            {
                "publisher": "enovaMSDN",
                "name"     : "SonetaPlatformDeveloper",
                "disabled" : true
            }
        ]
    }
}
```

## PARAMETERS

### -CfgFile
Configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Install-VisualStudio2017Extensions.md](https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Install-VisualStudio2017Extensions.md)

[https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/vs2017.psm1](https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/vs2017.psm1)

