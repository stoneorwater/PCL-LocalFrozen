[CmdletBinding()]
param(
    [string]$DotNetPath = 'dotnet',
    [ValidateSet('Release', 'Debug', 'Snapshot')]
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'
$buildRoot = Join-Path $PSScriptRoot '.build'
New-Item -ItemType Directory -Path $buildRoot -Force | Out-Null
$env:DOTNET_CLI_HOME = Join-Path $buildRoot 'dotnet-home'
$env:NUGET_PACKAGES = Join-Path $buildRoot 'packages'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE = '1'
$env:DOTNET_GENERATE_ASPNET_CERTIFICATE = 'false'

if (-not (Test-Path (Join-Path $PSScriptRoot 'MeloongCore/Shared/MeloongCore.csproj'))) {
    throw 'MeloongCore source is missing. Use the complete source archive, or initialize the pinned Git submodule.'
}
& $DotNetPath --version
if ($LASTEXITCODE -ne 0) { throw 'A Windows x64 .NET SDK is required (tested with 10.0.402).' }
& $DotNetPath restore (Join-Path $PSScriptRoot 'PCLCS/PCLCS.csproj') --verbosity minimal
if ($LASTEXITCODE -ne 0) { throw 'NuGet restore failed.' }
$referenceRoot = Join-Path $env:NUGET_PACKAGES 'microsoft.netframework.referenceassemblies.net48/1.0.3/build/'
if (-not (Test-Path $referenceRoot)) { throw 'The .NET Framework 4.8 reference package was not restored.' }
& $DotNetPath msbuild (Join-Path $PSScriptRoot 'Plain Craft Launcher 2/Plain Craft Launcher 2.vbproj') `
    "-p:Configuration=$Configuration" "-p:TargetFrameworkRootPath=$referenceRoot" `
    '-p:CodeAnalysisRuleSet=' -verbosity:minimal -nologo -m:1 -nr:false
if ($LASTEXITCODE -ne 0) { throw 'Launcher build failed.' }
$builtExe = Join-Path $PSScriptRoot 'Plain Craft Launcher 2/bin/Plain Craft Launcher 2.exe'
Write-Output "Built: $builtExe"
Get-FileHash -LiteralPath $builtExe -Algorithm SHA256
