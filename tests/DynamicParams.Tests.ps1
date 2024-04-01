[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Write-Verbose "Path to the module: [$Path]" -Verbose

Describe 'DynamicParams' {
    Context 'Module' {
        It 'The module should be available' {
            Get-Module -Name 'DynamicParams' -ListAvailable | Should -Not -BeNullOrEmpty
            Write-Verbose (Get-Module -Name 'DynamicParams' -ListAvailable | Out-String) -Verbose
        }
        It 'The module should be importable' {
            { Import-Module -Name 'DynamicParams' -Verbose -RequiredVersion 999.0.0 -Force } | Should -Not -Throw
        }
    }

    Context "Function: New-DynamicParamDictionary" {
        It "New-DynamicParamDictionary should not throw an exception" {
            New-DynamicParamDictionary | Should -BeOfType 'System.Management.Automation.RuntimeDefinedParameterDictionary'
        }
    }

    Context "Function: New-DynamicParam" {
        It "New-DynamicParam should not throw an exception" {
            $dictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'Param1'
                Type                   = [string]
                ValidateSet            = 'A', 'B', 'C'
                DynamicParamDictionary = $dictionary
            }
            New-DynamicParam @dynParam | Should -Not -Throw
        }

        It "New-DynamicParam should return a RuntimeDefinedParameter" {
            $dictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'Param1'
                Type                   = [string]
                ValidateSet            = 'A', 'B', 'C'
                DynamicParamDictionary = $dictionary
            }
            $param = New-DynamicParam @dynParam
            $param | Should -BeOfType 'System.Management.Automation.RuntimeDefinedParameter'
        }

        It "New-DynamicParam should return a RuntimeDefinedParameter with the correct name" {
            $dictionary = New-DynamicParamDictionary
            $dynParam = @{
                Name                   = 'Param1'
                Type                   = [string]
                ValidateSet            = 'A', 'B', 'C'
                DynamicParamDictionary = $dictionary
            }
            $param = New-DynamicParam @dynParam
            $param.Name | Should -Be 'Param1'
        }
    }

    Context 'Integration' {
        BeforeAll {
            filter Test-DynParam {
                [CmdletBinding()]
                param (
                    [Parameter()]
                    [ValidateSet('A', 'B', 'C')]
                    [string]$Param1
                )

                DynamicParam {
                    $DynamicParamDictionary = New-DynamicParamDictionary

                    $dynParam2 = @{
                        Name                   = 'Param2'
                        Type                   = [string]
                        ValidateSet            = Get-Process | Select-Object -ExpandProperty Name
                        DynamicParamDictionary = $DynamicParamDictionary
                    }
                    New-DynamicParam @dynParam2

                    $dynParam3 = @{
                        Name                   = 'Param3'
                        Type                   = [string]
                        ValidateSet            = Get-ChildItem -Path C:\ | Select-Object -ExpandProperty Name
                        DynamicParamDictionary = $DynamicParamDictionary
                    }
                    New-DynamicParam @dynParam3

                    return $DynamicParamDictionary
                }

                process {
                    $Param1 = $PSBoundParameters['Param1']
                    $Param2 = $PSBoundParameters['Param2']
                    $Param3 = $PSBoundParameters['Param3']

                    Write-Verbose "Param1: $Param1"
                    Write-Verbose "Param2: $Param2"
                    Write-Verbose "Param3: $Param3"
                }
            }

            filter Test-DynParam2 {
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
        }

        It "Test-DynParam should not throw an exception" {
            Test-DynParam -Param1 A -Param3 PerfLogs -Verbose | Should -Not -Throw
        }

        It "Test-DynParam2 should not throw an exception" {
            Test-DynParam2 -Param1 A -Verbose | Should -Not -Throw
        }
    }
}
