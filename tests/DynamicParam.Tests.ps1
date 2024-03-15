Describe 'DynamicParam' {
    Context 'Module' {
        It 'The module should be available' {
            Get-Module -Name 'DynamicParam' -ListAvailable | Should -Not -BeNullOrEmpty
            Write-Verbose (Get-Module -Name 'DynamicParam' -ListAvailable | Out-String) -Verbose
        }
        It 'The module should be importable' {
            { Import-Module -Name 'DynamicParam' } | Should -Not -Throw
        }
    }
}
