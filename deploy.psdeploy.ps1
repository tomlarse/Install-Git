# Nuget key in $ENV:NugetApiKey
# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName
# Publish to gallery with a few restrictions
if (
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $PSVersionTable.PSVersion.Major -ge 6 -and
    $env:BHCommitMessage -match '!deploy'
) {
    Deploy Script {
        By PSGalleryScript {
            FromSource $ENV:BHPSModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
}
elseif ($PSVersionTable.PSVersion.Major -eq 5) {
    #do nothing
}
else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if (
    $env:BHProjectName -and $ENV:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -eq 'AppVeyor' -and
    $PSVersionTable.PSVersion.Major -eq 5
) {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}