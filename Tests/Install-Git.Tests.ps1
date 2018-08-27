$ScriptFileName = 'Install-Git.ps1'
$ScriptFilePath = "$($env:BHProjectPath)\Install-Git\$ScriptFileName"

Describe 'File Tests' {
    It 'Passes Test-ScriptFileInfo' {
        Test-ScriptFileInfo -Path $ScriptFilePath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

. $ScriptFilePath

# reload the PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Describe "Install-Git tests" {
    Context "Installing git" {
        It "has downloaded an installer" {
            Test-Path "$($env:TEMP)\git-stable.exe" | Should Be $true
        }
        It "has installed git" {
            (git --version) -match "git version" | Should Be $true
        }
    }
}
