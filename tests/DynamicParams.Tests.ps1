﻿Describe 'DynamicParams' {
    Context 'Function: New-DynamicParamDictionary' {
        It 'New-DynamicParamDictionary should not throw an exception' {
            { New-DynamicParamDictionary } | Should -Not -Throw
        }

        It 'New-DynamicParamDictionary should return a RuntimeDefinedParameterDictionary' {
            $dictionary = New-DynamicParamDictionary
            $dictionary | Should -BeOfType 'System.Management.Automation.RuntimeDefinedParameterDictionary'
        }
    }

    Context 'Function: New-DynamicParam' {
        It 'New-DynamicParam should not throw an exception' {
            $dictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'Param1'
                Type                   = [string]
                ValidateSet            = 'A', 'B', 'C'
                DynamicParamDictionary = $dictionary
            }
            { New-DynamicParam @dynParam } | Should -Not -Throw
        }

        It 'New-DynamicParam should add a RuntimeDefinedParameter to the dictionary' {
            $dictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'Param1'
                Type                   = [string]
                ValidateSet            = 'A', 'B', 'C'
                DynamicParamDictionary = $dictionary
            }
            New-DynamicParam @dynParam
            $dictionary.Keys | Should -Contain 'Param1'
        }
    }

    Context 'Integration' {
        BeforeAll {
            filter Test-DynParam {
                <#
                    .SYNOPSIS
                    This is a test of dynamic parameters.
                #>
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [ValidateSet('A', 'B', 'C')]
                    [string]$Param1
                )

                dynamicparam {
                    $DynamicParamDictionary = New-DynamicParamDictionary

                    $dynVariable = @{
                        Name                   = 'Variable'
                        Type                   = [string]
                        ValidateSet            = Get-Variable | Select-Object -ExpandProperty Name
                        DynamicParamDictionary = $DynamicParamDictionary
                    }
                    New-DynamicParam @dynVariable

                    $dynEnvironmentVariable = @{
                        Name                   = 'EnvironmentVariable'
                        Type                   = [string]
                        ValidateSet            = Get-ChildItem -Path env: | Select-Object -ExpandProperty Name
                        DynamicParamDictionary = $DynamicParamDictionary
                    }
                    New-DynamicParam @dynEnvironmentVariable

                    $DynamicParamDictionary
                }

                process {
                    $Variable = $PSBoundParameters['Variable']
                    $EnvironmentVariable = $PSBoundParameters['EnvironmentVariable']

                    Write-Verbose "Variable:            $Variable"
                    Write-Verbose "EnvironmentVariable: $EnvironmentVariable"
                }
            }
        }

        It 'Test-DynParam should not throw an exception' {
            { Test-DynParam -Variable HOME -EnvironmentVariable RUNNER_OS -Verbose } | Should -Not -Throw
        }
    }

    Context 'Integration - DSL' {
        BeforeAll {
            filter Test-DynParam {
                <#
                    .SYNOPSIS
                    This is a test of dynamic parameters.
                #>
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [ValidateSet('A', 'B', 'C')]
                    [string]$Param1
                )

                dynamicparam {
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
                }

                process {
                    $Variable = $PSBoundParameters['Variable']
                    $EnvironmentVariable = $PSBoundParameters['EnvironmentVariable']

                    Write-Verbose "Variable:            $Variable"
                    Write-Verbose "EnvironmentVariable: $EnvironmentVariable"
                }
            }
        }

        It 'Test-DynParam should not throw an exception' {
            { Test-DynParam -Variable HOME -EnvironmentVariable RUNNER_OS -Verbose } | Should -Not -Throw
        }
    }

    Context 'Integration - Pipelined construction' {
        BeforeAll {
            filter Test-DynParam {
                <#
                    .SYNOPSIS
                    This is a test of dynamic parameters.
                #>
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [ValidateSet('A', 'B', 'C')]
                    [string]$Param1
                )

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
                    $Variable = $PSBoundParameters['Variable']
                    $EnvironmentVariable = $PSBoundParameters['EnvironmentVariable']

                    Write-Verbose "Variable:            $Variable"
                    Write-Verbose "EnvironmentVariable: $EnvironmentVariable"
                }
            }
        }

        It 'Test-DynParam should not throw an exception' {
            { Test-DynParam -Variable HOME -EnvironmentVariable RUNNER_OS -Verbose } | Should -Not -Throw
        }
    }

    Context 'Integration - Pipelined construction - shorter pipeline' {
        BeforeAll {
            filter Test-DynParam {
                <#
                    .SYNOPSIS
                    This is a test of dynamic parameters.
                #>
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [ValidateSet('A', 'B', 'C')]
                    [string]$Param1
                )

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

                    $params | New-DynamicParamDictionary
                }

                process {
                    $Variable = $PSBoundParameters['Variable']
                    $EnvironmentVariable = $PSBoundParameters['EnvironmentVariable']

                    Write-Verbose "Variable:            $Variable"
                    Write-Verbose "EnvironmentVariable: $EnvironmentVariable"
                }
            }
        }

        It 'Test-DynParam should not throw an exception' {
            { Test-DynParam -Variable HOME -EnvironmentVariable RUNNER_OS -Verbose } | Should -Not -Throw
        }
    }
}
