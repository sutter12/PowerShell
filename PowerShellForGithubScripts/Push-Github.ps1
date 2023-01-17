# Author: Alexander Sutter
# Date: 01/04/2023
# Latest Update: 
# PowerShell Version: 5.1

# Push-Github

$RepoURL = "https://github.com/sutter12/TestRepo.git"

Set-GitHubAuthentication

# Get-GitHubRepository -RepositoryUrl $RepoURL