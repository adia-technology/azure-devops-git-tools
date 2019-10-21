param (
	[string]$basePath = '..\..'
)

Push-Location $basePath

$repos = Get-ChildItem -Directory | Select-Object -ExpandProperty 'Name'

foreach ($repo in $repos) {
	Write-Host "Updating $repo..."
	Push-Location -Path $repo
	& 'git' 'pull' '--recurse-submodules'
	Pop-Location
}

Pop-Location
