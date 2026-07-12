# DynamicParams

DynamicParams is a PowerShell module that makes it easier to build dynamic parameters. It provides helper
commands to define individual dynamic parameters and to collect them into the dictionary that a function's
`dynamicparam` block returns, removing much of the boilerplate normally involved.

## Installation

Install the module from the PowerShell Gallery:

```powershell
Install-PSResource -Name DynamicParams
Import-Module -Name DynamicParams
```

## Usage

Use `New-DynamicParam` to define individual dynamic parameters and `New-DynamicParamDictionary` to build the
dictionary returned from a function's `dynamicparam` block.

### Example: Add dynamic parameters to a function

```powershell
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

    process {
        $process = $PSBoundParameters['Process']
        $service = $PSBoundParameters['Service']
    }
}
```

### Example: Define parameters with the DSL style

`DynamicParams` is a convenience DSL alias that wraps `New-DynamicParam` and `New-DynamicParamDictionary`:

```powershell
function Get-Info {
    [CmdletBinding()]
    param ()

    dynamicparam {
        DynamicParams @(
            @{
                Name        = 'Process'
                Alias       = 'proc'
                Type        = [string]
                ValidateSet = Get-Process | Select-Object -ExpandProperty Name -Unique
            }
            @{
                Name        = 'Service'
                Alias       = 'svc'
                Type        = [string]
                ValidateSet = Get-Service | Select-Object -ExpandProperty Name -Unique
            }
        )
    }

    process {
        $process = $PSBoundParameters['Process']
        $service = $PSBoundParameters['Service']
    }
}
```

### Example: Build parameters from a pipeline

```powershell
function Get-Info {
    [CmdletBinding()]
    param ()

    dynamicparam {
        $params = @(
            @{
                Name        = 'Variable'
                Type        = [string]
                ValidateSet = Get-Variable | Select-Object -ExpandProperty Name
            },
            @{
                Name        = 'EnvironmentVariable'
                Type        = [string]
                ValidateSet = Get-ChildItem -Path env: | Select-Object -ExpandProperty Name
            }
        )

        $params | ForEach-Object { New-DynamicParam @_ } | New-DynamicParamDictionary
    }

    process {
        $variable = $PSBoundParameters['Variable']
        $environmentVariable = $PSBoundParameters['EnvironmentVariable']
    }
}
```

## Documentation

Documentation is published at [psmodule.io/DynamicParams](https://psmodule.io/DynamicParams/).

Use PowerShell help and command discovery for module details:

```powershell
Get-Command -Module DynamicParams
Get-Help New-DynamicParam -Examples
```

## Links

- [about_Functions_Advanced_Parameters | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters#dynamic-parameters)
