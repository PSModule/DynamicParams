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
}
