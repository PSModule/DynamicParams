function New-DynamicParamDictionary {
    <#
        .SYNOPSIS
        Creates a new RuntimeDefinedParameterDictionary

        .DESCRIPTION
        Creates a new RuntimeDefinedParameterDictionary

        .EXAMPLE
        New-DynamicParamDictionary

        Returns a new RuntimeDefinedParameterDictionary

        .EXAMPLE
        New-DynamicParamDictionary -ParameterDefinition $param1, $param2

        Outputs:
        ```powershell
        Key                 Value
        ---                 -----
        Variable            System.Management.Automation.RuntimeDefinedParameter
        EnvironmentVariable System.Management.Automation.RuntimeDefinedParameter
        ```

        Returns a new RuntimeDefinedParameterDictionary with the specified parameters.

        .EXAMPLE
        DynamicParams @(
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

        Outputs:
        ```powershell
        Key                 Value
        ---                 -----
        Variable            System.Management.Automation.RuntimeDefinedParameter
        EnvironmentVariable System.Management.Automation.RuntimeDefinedParameter
        ```

        Returns a new RuntimeDefinedParameterDictionary with the specified parameters.

        .EXAMPLE
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

        Outputs:
        ```powershell
        Key                 Value
        ---                 -----
        Variable            System.Management.Automation.RuntimeDefinedParameter
        EnvironmentVariable System.Management.Automation.RuntimeDefinedParameter
        ```

        Returns a new RuntimeDefinedParameterDictionary with the specified parameters.

        .LINK
        https://psmodule.io/DynamicParams/Functions/New-DynamicParamDictionary/
    #>
    [Alias('DynamicParams')]
    [OutputType([System.Management.Automation.RuntimeDefinedParameterDictionary])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change state.'
    )]
    [CmdletBinding()]
    param(
        # An array of hashtables or RuntimeDefinedParameter objects to add to the dictionary.
        [Parameter(ValueFromPipeline, ParameterSetName = 'RuntimeParamSet')]
        [ValidateNotNull()]
        [System.Management.Automation.RuntimeDefinedParameter[]] $RuntimeParameters,

        # An hashtables or RuntimeDefinedParameter objects to add to the dictionary.
        [Parameter(ValueFromPipeline, ParameterSetName = 'FromHashSet')]
        [ValidateNotNull()]
        [hashtable[]] $Hashtable
    )

    begin {
        $dictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'RuntimeParamSet' {
                foreach ($RuntimeParameter in $RuntimeParameters) {
                    $dictionary.Add($RuntimeParameter.Name, $RuntimeParameter)
                }
            }
            'FromHashSet' {
                foreach ($entry in $Hashtable) {
                    $dictionary.Add($entry.Name, $entry)
                }
            }
        }
    }

    end {
        return $dictionary
    }
}
