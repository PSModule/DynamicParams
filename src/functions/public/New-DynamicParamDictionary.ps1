function New-DynamicParamDictionary {
    <#
        .SYNOPSIS
        Creates a new RuntimeDefinedParameterDictionary

        .DESCRIPTION
        Creates a new RuntimeDefinedParameterDictionary

        .EXAMPLE
        New-DynamicParamDictionary

        Returns a new RuntimeDefinedParameterDictionary

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
        [Parameter(Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object[]] $ParameterDefinition
    )

    begin {
        $dictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
    }

    process {
        foreach ($param in $ParameterDefinition) {
            if ($param -is [hashtable]) {
                $param = New-DynamicParam @param
            }
            $dicationary.Add($param.Name, $param)
        }
    }

    end {
        return $dictionary
    }
}
