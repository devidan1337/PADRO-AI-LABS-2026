[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$OutputDirectory,
    [Parameter(Mandatory)][ValidatePattern('^\d{8}T\d{6}Z-[A-Za-z0-9]{4,16}$')][string]$RunId,
    [Parameter(Mandatory)][System.Net.IPAddress]$LocalResolver,
    [Parameter(Mandatory)][string]$ExpectedVlan30Prefix,
    [string]$TestDomain = 'example.com',
    [Parameter(Mandatory)][System.Net.IPAddress]$ExternalResolver,
    [string[]]$VpnServicePatterns = @(),
    [Parameter(Mandatory)][string]$RepositoryRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-UtcStamp { (Get-Date).ToUniversalTime().ToString('o') }

function Test-IsBelow([string]$Child, [string]$Parent) {
    $childPath = [IO.Path]::GetFullPath($Child).TrimEnd([IO.Path]::DirectorySeparatorChar) +
        [IO.Path]::DirectorySeparatorChar
    $parentPath = [IO.Path]::GetFullPath($Parent).TrimEnd([IO.Path]::DirectorySeparatorChar) +
        [IO.Path]::DirectorySeparatorChar
    return $childPath.StartsWith($parentPath, [StringComparison]::OrdinalIgnoreCase)
}

function Write-ReadOnlyCommandArtifact {
    param([string]$Name, [string]$CommandId, [scriptblock]$Action)
    $path = Join-Path $script:RawDirectory $Name
    if (Test-Path -LiteralPath $path) { throw "Refusing to overwrite: $path" }
    $started = Get-UtcStamp
    $exitStatus = 0
    $output = try { & $Action 2>&1 | Out-String -Width 240 } catch {
        $exitStatus = 1
        ($_ | Out-String)
    }
    @(
        "capture_timestamp_utc=$started"
        "command_identifier=$CommandId"
        "exit_status=$exitStatus"
        '--- output ---'
        $output
    ) | Set-Content -LiteralPath $path -Encoding utf8NoBOM
    return $exitStatus
}

$resolvedOutput = [IO.Path]::GetFullPath($OutputDirectory)
if (-not [IO.Path]::IsPathRooted($OutputDirectory)) {
    throw 'OutputDirectory must be an explicit absolute path.'
}
if (-not [IO.Path]::IsPathRooted($RepositoryRoot)) {
    throw 'RepositoryRoot must be an explicit absolute path.'
}
if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
    throw 'RepositoryRoot must identify an existing directory.'
}
if (Test-IsBelow $resolvedOutput $RepositoryRoot) {
    throw 'Refusing evidence output beneath the Git repository.'
}
if (Test-Path -LiteralPath $resolvedOutput) {
    throw 'Refusing to use an existing run directory.'
}
if ($ExpectedVlan30Prefix -notmatch '^\d{1,3}(?:\.\d{1,3}){2}\.$') {
    throw 'ExpectedVlan30Prefix must be an explicit three-octet prefix such as A.B.C.'
}

$script:RawDirectory = Join-Path $resolvedOutput 'raw'
$metadataDirectory = Join-Path $resolvedOutput 'metadata'
$logsDirectory = Join-Path $resolvedOutput 'logs'
$sanitizedDirectory = Join-Path $resolvedOutput 'sanitized'
New-Item -ItemType Directory -Path $resolvedOutput -ErrorAction Stop | Out-Null
New-Item -ItemType Directory -Path @($script:RawDirectory, $metadataDirectory, $logsDirectory, $sanitizedDirectory) | Out-Null

$addresses = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
    Where-Object { $_.IPAddress.StartsWith($ExpectedVlan30Prefix, [StringComparison]::Ordinal) }
if (-not $addresses) {
    throw 'STOP: the client is not verified on the expected VLAN 30 address class.'
}

$context = [ordered]@{
    schema_version = '1.0'
    run_id = $RunId
    capture_timestamp_utc = Get-UtcStamp
    collector = 'Collect-Vlan30DnsEvidence.ps1'
    collector_mode = 'read-only endpoint observations'
    expected_address_prefix = $ExpectedVlan30Prefix
    local_resolver_parameter_supplied = $true
    external_resolver_parameter_supplied = $true
    test_domain = $TestDomain
    configuration_changed = $false
    services_changed = $false
    adapters_changed = $false
}
$context | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $script:RawDirectory '00-RUN-CONTEXT.json') -Encoding utf8NoBOM

Write-ReadOnlyCommandArtifact '01-CLIENT-BASELINE.txt' 'PS-CLIENT-BASELINE' {
    Get-NetIPConfiguration -Detailed
    Get-NetAdapter
} | Out-Null
Write-ReadOnlyCommandArtifact '02-ROUTE-AND-DNS-STATE.txt' 'PS-ROUTE-DNS-STATE' {
    Get-NetRoute -AddressFamily IPv4
    Find-NetRoute -RemoteIPAddress $LocalResolver.IPAddressToString
    Get-DnsClientServerAddress -AddressFamily IPv4
} | Out-Null
Write-ReadOnlyCommandArtifact '03-LOCAL-RESOLVER-UDP.txt' 'PS-DNS-LOCAL-UDP' {
    Test-NetConnection -ComputerName $LocalResolver.IPAddressToString -Port 53 -InformationLevel Detailed
    Resolve-DnsName -Name $TestDomain -Server $LocalResolver.IPAddressToString -DnsOnly -NoHostsFile
} | Out-Null
Write-ReadOnlyCommandArtifact '04-LOCAL-RESOLVER-TCP.txt' 'PS-DNS-LOCAL-TCP' {
    Resolve-DnsName -Name $TestDomain -Server $LocalResolver.IPAddressToString -DnsOnly -NoHostsFile -TcpOnly
} | Out-Null
Write-ReadOnlyCommandArtifact '05-EXTERNAL-DNS-NEGATIVE-CONTROL.txt' 'PS-DNS-EXTERNAL-CONTROL' {
    Resolve-DnsName -Name $TestDomain -Server $ExternalResolver.IPAddressToString -DnsOnly -NoHostsFile
} | Out-Null
Write-ReadOnlyCommandArtifact '06-VPN-TAILSCALE-STATE-BEFORE.txt' 'PS-VPN-TAILSCALE-STATE' {
    Get-NetAdapter | Where-Object {
        $_.InterfaceDescription -match 'VPN|TAP|TUN|WireGuard|Tailscale'
    }
    if ($VpnServicePatterns.Count -gt 0) {
        Get-Service | Where-Object {
            $service = $_
            $VpnServicePatterns | Where-Object {
                $service.Name -like $_ -or $service.DisplayName -like $_
            }
        }
    } else {
        'VPN service matching not requested; supply VpnServicePatterns for product-neutral matching.'
    }
    $tailscale = Get-Command tailscale -ErrorAction SilentlyContinue
    if ($tailscale) { & $tailscale.Source status } else { 'tailscale command not installed or not on PATH' }
} | Out-Null

@(
    "completion_timestamp_utc=$(Get-UtcStamp)"
    'collector_changed_configuration=false'
    'collector_stopped_services=false'
    'collector_disabled_adapters=false'
    'collector_created_derivatives=false'
    'collector_uploaded_evidence=false'
) | Set-Content -LiteralPath (Join-Path $logsDirectory 'collector-summary.log') -Encoding utf8NoBOM

Write-Host "Read-only collection completed at $resolvedOutput. Packet captures, state changes, restoration, manifests, and derivatives require separate procedures."
