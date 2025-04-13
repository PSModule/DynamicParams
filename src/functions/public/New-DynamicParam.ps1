filter New-DynamicParam {
    <#
        .SYNOPSIS
        Creates a new dynamic parameter for a function.

        .DESCRIPTION
        Creates a new dynamic parameter for a function.

        .EXAMPLE
        dynamicparam {
            $DynamicParamDictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'GitignoreTemplate'
                Alias                  = 'gitignore_template'
                Type                   = [string]
                ValidateSet            = Get-GitHubGitignoreList
                DynamicParamDictionary = $DynamicParamDictionary
            }
            New-DynamicParam @dynParam
            $dynParam2 = @{
                Name                   = 'LicenseTemplate'
                Alias                  = 'license_template'
                Type                   = [string]
                ValidateSet            = Get-GitHubLicenseList | Select-Object -ExpandProperty key
                DynamicParamDictionary = $DynamicParamDictionary
            }
            New-DynamicParam @dynParam2
            return $DynamicParamDictionary
        }

        .OUTPUTS
        [void]

        .OUTPUTS
        [System.Management.Automation.RuntimeDefinedParameterDictionary]

        .LINK
        https://psmodule.io/DynamicParams/Functions/New-DynamicParam/
    #>
    [Alias('DynamicParam')]
    [OutputType(ParameterSetName = 'Add to dictionary', [void])]
    [OutputType(ParameterSetName = 'Return parameter', [System.Management.Automation.RuntimeDefinedParameter])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidLongLines', '', Justification = 'Long links'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change state.'
    )]
    [CmdletBinding(DefaultParameterSetName = 'Return parameter')]
    param(
        # Specifies the name of the parameter.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        # Specifies the aliases of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]] $Alias,

        # Specifies the data type of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [type] $Type,

        # Specifies the parameter set name.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $ParameterSetName = '__AllParameterSets',

        # Specifies if the parameter is mandatory.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $Mandatory,

        # Specifies the parameters positional binding.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Position,

        # Specifies if the parameter accepts values from the pipeline.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $ValueFromPipeline,

        # Specifies if the parameter accepts values from the pipeline by property name.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $ValueFromPipelineByPropertyName,

        # Specifies if the parameter accepts values from the remaining command-line arguments that are not associated with another parameter.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $ValueFromRemainingArguments,

        # Specifies the help message of the parameter.
        # Parameter Set specific
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $HelpMessage,

        # Specifies the comments of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Comment,

        # Specifies the validate script of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [scriptblock] $ValidateScript,

        # Specifies the validate regular expression pattern of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [regex] $ValidatePattern,

        # Specifies the validate regular expression pattern options of the parameter.
        # For more info see [RegexOptions](https://learn.microsoft.com/dotnet/api/system.text.regularexpressions.regexoptions).
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Text.RegularExpressions.RegexOptions[]] $ValidatePatternOptions,

        # Specifies the validate number of items for the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateCount(2, 2)]
        [int[]] $ValidateCount,

        # Specifies the validate range of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [object] $ValidateRange,

        # Specifies the validate set of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [object] $ValidateSet,

        # Specifies the validate length of the parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateCount(2, 2)]
        [int[]] $ValidateLength,

        # Specifies if the parameter accepts null or empty values.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $ValidateNotNullOrEmpty,

        # The custom error message pattern that is displayed to the user if validation fails.
        # This parameter is not supported on Windows PowerShell Desktop Edition, if specified it will be ignored.
        #
        # Examples of how to use this parameter:
        # - `ValidatePattern` -> "The text '{0}' did not pass validation of the regular expression '{1}'". {0} is the value, {1} is the pattern.
        # - `ValidateSet` -> "The item '{0}' is not part of the set '{1}'. {0} is the value, {1} is the set.
        # - `ValidateScript` -> "The item '{0}' did not pass validation of script '{1}'". {0} is the value, {1} is the script.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $ValidationErrorMessage,

        # Specifies if the parameter accepts wildcards.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $SupportsWildcards,

        # Specifies if the parameter accepts empty strings.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $AllowEmptyString,

        # Specifies if the parameter accepts null values.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $AllowNull,

        # Specifies if the parameter accepts empty collections.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $AllowEmptyCollection,

        # Specifies the dynamic parameter dictionary.
        [Parameter(ParameterSetName = 'Add to dictionary')]
        [System.Management.Automation.RuntimeDefinedParameterDictionary] $DynamicParamDictionary,

        # Allows accepting an object or array of objects from the pipeline.
        [Parameter(ParameterSetName = 'Process array', ValueFromPipeline)]
        [object[]] $InputObject
    )
    begin {
        $isDesktop = $PSVersionTable.PSEdition -eq 'Desktop'
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Process array' {
                foreach ($item in $InputObject) {
                    $item | New-DynamicParam
                }
            }
            default {
                if ($isDesktop) {
                    if ($PSBoundParameters.ContainsKey('ValidationErrorMessage')) {
                        Write-Warning "Unsupported parameter: 'ValidationErrorMessage' is not supported in Windows PowerShell Desktop Edition. Skipping it."
                    }
                }

                $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

                # foreach ParameterSet in ParameterSets , Key = name, Value = Hashtable
                $parameterAttribute = New-Object System.Management.Automation.ParameterAttribute

                $parameterAttribute.ParameterSetName = $ParameterSetName
                if ($PSBoundParameters.ContainsKey('HelpMessage')) {
                    $parameterAttribute.HelpMessage = $HelpMessage
                }
                if ($PSBoundParameters.ContainsKey('Position')) {
                    $parameterAttribute.Position = $Position
                }
                $parameterAttribute.Mandatory = $Mandatory
                $parameterAttribute.ValueFromPipeline = $ValueFromPipeline
                $parameterAttribute.ValueFromPipelineByPropertyName = $ValueFromPipelineByPropertyName
                $parameterAttribute.ValueFromRemainingArguments = $ValueFromRemainingArguments
                $attributeCollection.Add($parameterAttribute)

                if ($PSBoundParameters.ContainsKey('Alias')) {
                    $Alias | ForEach-Object {
                        $aliasAttribute = New-Object System.Management.Automation.AliasAttribute($_)
                        $attributeCollection.Add($aliasAttribute)
                    }
                }

                # TODO: Add ability to add a param doc/comment

                if ($PSBoundParameters.ContainsKey('ValidateSet')) {
                    $validateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSet)
                    if ($PSBoundParameters.ContainsKey('ValidationErrorMessage') -and -not $isDesktop) {
                        $validateSetAttribute.ErrorMessage = $ValidationErrorMessage
                    }
                    $attributeCollection.Add($validateSetAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidateNotNullOrEmpty')) {
                    $validateNotNullOrEmptyAttribute = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                    $attributeCollection.Add($validateNotNullOrEmptyAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidateLength')) {
                    $validateLengthAttribute = New-Object System.Management.Automation.ValidateLengthAttribute($ValidateLength[0], $ValidateLength[1])
                    $attributeCollection.Add($validateLengthAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidateCount')) {
                    $validateCountAttribute = New-Object System.Management.Automation.ValidateCountAttribute($ValidateCount[0], $ValidateCount[1])
                    $attributeCollection.Add($validateCountAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidateScript')) {
                    $validateScriptAttribute = New-Object System.Management.Automation.ValidateScriptAttribute($ValidateScript)
                    if ($PSBoundParameters.ContainsKey('ValidationErrorMessage') -and -not $isDesktop) {
                        $validateScriptAttribute.ErrorMessage = $ValidationErrorMessage
                    }
                    $attributeCollection.Add($validateScriptAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidatePattern')) {
                    $validatePatternAttribute = New-Object System.Management.Automation.ValidatePatternAttribute($ValidatePattern)
                    if ($PSBoundParameters.ContainsKey('ValidationErrorMessage') -and -not $isDesktop) {
                        $validatePatternAttribute.ErrorMessage = $ValidationErrorMessage
                    }
                    if ($PSBoundParameters.ContainsKey('ValidatePatternOptions')) {
                        $validatePatternAttribute.Options = $ValidatePatternOptions
                    }
                    $attributeCollection.Add($validatePatternAttribute)
                }
                if ($PSBoundParameters.ContainsKey('ValidateRange')) {
                    $validateRangeAttribute = New-Object System.Management.Automation.ValidateRangeAttribute($ValidateRange)
                    $attributeCollection.Add($validateRangeAttribute)
                }
                if ($PSBoundParameters.ContainsKey('SupportsWildcards')) {
                    $supportsWildcardsAttribute = New-Object System.Management.Automation.SupportsWildcardsAttribute
                    $attributeCollection.Add($supportsWildcardsAttribute)
                }
                if ($PSBoundParameters.ContainsKey('AllowEmptyString')) {
                    $allowEmptyStringAttribute = New-Object System.Management.Automation.AllowEmptyStringAttribute
                    $attributeCollection.Add($allowEmptyStringAttribute)
                }
                if ($PSBoundParameters.ContainsKey('AllowNull')) {
                    $allowNullAttribute = New-Object System.Management.Automation.AllowNullAttribute
                    $attributeCollection.Add($allowNullAttribute)
                }
                if ($PSBoundParameters.ContainsKey('AllowEmptyCollection')) {
                    $allowEmptyCollectionAttribute = New-Object System.Management.Automation.AllowEmptyCollectionAttribute
                    $attributeCollection.Add($allowEmptyCollectionAttribute)
                }

                $runtimeDefinedParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, $Type, $attributeCollection)

                switch ($PSCmdlet.ParameterSetName) {
                    'Add to dictionary' {
                        $DynamicParamDictionary.Add($Name, $runtimeDefinedParameter)
                    }
                    'Return parameter' {
                        return $runtimeDefinedParameter
                    }
                }
            }
        }
    }

    end {}
}
