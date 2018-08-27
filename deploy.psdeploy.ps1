# Nuget key in $ENV:NugetApiKey
# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName
# Publish to gallery with a few restrictions
if (
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy'
) {
    Deploy Script {
        By PSGalleryScript {
            FromSource "$($ENV:BHProjectPath)\Install-Git\Install-Git.ps1"
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
}
else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}