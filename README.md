# DynamicParams

A PowerShell module that makes it easier to use dynamic params.

## Prerequisites

No prerequisites are required to use this module.

## Installation

Provide step-by-step instructions on how to install the module, including any InstallModule commands or manual installation steps.

```powershell
Install-Module -Name DynamicParams
Import-Module -Name DynamicParams
```

## Usage

Here is a list of example that are typical use cases for the module.
This section should provide a good overview of the module's capabilities.

### Use dynamic parameters in a function

Here is an example of how to use dynamic parameters in a function.

```powershell
#Requires -Modules DynamicParams

function Get-Info {
    [CmdletBinding()]
    param ()

    dynamicparam {
        $DynamicParamDictionary = New-DynamicParamDictionary

        $dynParam = @{
            Name                   = 'Process'
            Alias                  = 'proc'
            Type                   = [string]
            ValidateSet            = Get-Process | Select-Object -ExpandProperty Name -Unique
            DynamicParamDictionary = $DynamicParamDictionary
        }
        New-DynamicParam @dynParam

        $dynParam2 = @{
            Name                   = 'Service'
            Alias                  = 'svc'
            Type                   = [string]
            ValidateSet            = Get-Service | Select-Object -ExpandProperty Name -Unique
            DynamicParamDictionary = $DynamicParamDictionary
        }
        New-DynamicParam @dynParam2

        return $DynamicParamDictionary
    }

    ...
}

```

## Contributing

Coder or not, you can contribute to the project! We welcome all contributions.

### For Users

If you don't code, you still sit on valuable information that can make this project even better. If you experience that the
product does unexpected things, throw errors or is missing functionality, you can help by submitting bugs and feature requests.
Please see the issues tab on this project and submit a new issue that matches your needs.

### For Developers

If you do code, we'd love to have your contributions. Please read the [Contribution guidelines](CONTRIBUTING.md) for more information.
You can either help by picking up an existing issue or submit a new one if you have an idea for a new feature or improvement.

## Links

- [about_Functions_Advanced_Parameters | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4#dynamic-parameters)
