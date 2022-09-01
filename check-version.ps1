$repoName = "desktop/desktop"
$releasesUri = "https://api.github.com/repos/$repoName/tags"
$tag = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).name[0]
$tag2 = $tag
Write-Host $tag2
if ($tag2 -match "alpha")
{
  Write-Host "Found alpha."
  echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "beta")
{
  Write-Host "Found beta."
  echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "RC")
{
  Write-Host "Found Release Candidate."
  echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "test")
{
  Write-Host "Found test."
  echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
else{
    echo "UPSTREAM_TAG=$tag2" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    $repoName2 = "thosoo/GitHubDesktopPortable"
    $releasesUri2 = "https://api.github.com/repos/$repoName2/tags"
    $local_tag = (Invoke-WebRequest $releasesUri2 | ConvertFrom-Json).name[0]
    if ($local_tag -ne $tag2){
        echo "SHOULD_BUILD=yes" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    }
    else{
        Write-Host "No changes."
        echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    }
}
