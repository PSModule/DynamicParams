Describe 'DynamicParams' {
    Context 'Module' {
        It 'The module should be available' {
            Get-Module -Name 'DynamicParams' -ListAvailable | Should -Not -BeNullOrEmpty
            Write-Verbose (Get-Module -Name 'DynamicParams' -ListAvailable | Out-String) -Verbose
        }
        It 'The module should be importable' {
            { Import-Module -Name 'DynamicParams' -Verbose -Force } | Should -Not -Throw
        }
    }
}
