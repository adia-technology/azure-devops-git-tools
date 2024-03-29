param (
	[Parameter(Mandatory=$true)][string]$organisation,
	[Parameter(Mandatory=$true)][string]$project,
	[Parameter(Mandatory=$true)][string]$pat,
	[string]$basePath = (Join-Path -Path '..' -ChildPath '..'),
	[switch]$cloneWithHttps
)

$securePat = ConvertTo-SecureString $pat -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($pat, $securePat)

$reposResponse = Invoke-WebRequest -Uri "https://dev.azure.com/$organisation/$project/_apis/git/repositories?api-version=5.1" -Authentication Basic -Credential $credentials
if ($reposResponse.StatusCode -ne 200) {
	Write-Error "Call to DevOps API failed with status code $($reposResponse.StatusCode): $($reposResponse.StatusDescription)"
	exit -1
}

$repoPathProperty = if ($cloneWithHttps) { 'remoteUrl' } else { 'sshUrl' }

$repos = ($reposResponse.Content | ConvertFrom-Json).value

foreach ($repo in $repos) {
	$repoPath = $repo."$repoPathProperty"

	if ($cloneWithHttps) {
		$repoPath = $repoPath -replace "https://.*@", "https://$($pat):$($pat)@"
	}

	$repoLocation = Join-Path -Path $basePath -ChildPath $repo.name
	Write-Host "Cloning $($repo.name) from $repoPath into $repoLocation"
	& 'git' 'clone' $repoPath $repoLocation

	Push-Location -Path $repoLocation
	& 'git' 'submodule' 'update' '--init' '--recursive'
	Pop-Location
}
