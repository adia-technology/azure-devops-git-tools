# Repository Tools
This directory contains tools useful when operating on projects with multiple Git repositories on Azure Repos.
These scripts require Powershell Core.

## clone
This scripts automates cloning of all repositories within a project. Usage:

`.\Clone-Repos.ps1 -organisation <devops_organisation> -project <devops_project_name> -pat <devops_personal_access_token>`

The `organisation` and `project` parameters are properties of the Azure DevOps project to interact with. They can be extracted from the project's URL (it's in a form of `dev.azure.com/<organisation>/<project>`) or taken directly from the portal.

A personal access token should be generated in Azure DevOps security settings. A Code/Read permission should be enough.

An optional `-basePath <path>` parameter can be provided to customize cloning target directory.
By default, SSH is used to clone the repositories. To use HTTPS, pass in the `cloneWithHttps` flag.

## update
This scripts automates updating of repository contents using `git pull` command. Usage:

`.\Update-Repos.ps1`

And optional `-basePath <path>` parameter can be provided to customize the base directory of local repositories. The script assumes that all subdirectories of the `basePath` are Git repositories.