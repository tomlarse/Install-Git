$ModuleFileName = 'Install-Git.ps1'
$ModuleFilePath = "$PSScriptRoot\..\Install-Git\$ModuleManifestName"

Describe 'File Tests' {
    It 'Passes Test-ScriptFileInfo' {
        Test-ScriptFileInfo -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

. $ModuleFilePath
Install-Git

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
