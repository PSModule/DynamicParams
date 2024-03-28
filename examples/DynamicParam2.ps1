function Test-DynParam {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('A', 'B', 'C')]
        [string]$Param1
    )
    DynamicParam {
        $DynamicParamDictionary = New-DynamicParamDictionary

        $dynParam = @{
            Name                   = 'Process'
            Alias                  = 'proc'
            Type                   = [string]
            ValidateSet            = Get-Process -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name -Unique
            DynamicParamDictionary = $DynamicParamDictionary
        }
        New-DynamicParam @dynParam

        $dynParam2 = @{
            Name                   = 'Service'
            Alias                  = 'svc'
            Type                   = [string]
            ValidateSet            = Get-Service -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name -Unique
            DynamicParamDictionary = $DynamicParamDictionary
        }
        New-DynamicParam @dynParam2

        return $DynamicParamDictionary
    }

    process {
        $PSBoundParameters.Keys | ForEach-Object {
            Set-Variable -Name $_ -Value $PSBoundParameters[$_]
        }

        Write-Verbose "Param1: $Param1"
        Write-Verbose "Process: $Process"
        Write-Verbose "Service: $Service"
    }
}

Test-DynParam -Param1 A -Service SDRSVC -Verbose
