try {
  Import-Module PsIni
} catch {
  Install-Module -Scope CurrentUser PsIni
  Import-Module PsIni
}
$repoName = "desktop/desktop"
$releasesUri = "https://api.github.com/repos/$repoName/tags"
$tag = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).name[0]
$tag2 = $tag.replace('release-','') #-Replace '-.*',''
Write-Host $tag2
if ($tag2 -match "alpha")
{
  Write-Host "Found alpha."
  echo "SHOULD_COMMIT=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "beta")
{
  Write-Host "Found beta."
  echo "SHOULD_COMMIT=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "RC")
{
  Write-Host "Found Release Candidate."
  echo "SHOULD_COMMIT=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
elseif ($tag2 -match "test")
{
  Write-Host "Found test."
  echo "SHOULD_BUILD=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
else{
    echo "UPSTREAM_TAG=$tag2" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    $appinfo = Get-IniContent ".\GitHubDesktopPortable\App\AppInfo\appinfo.ini"
    if ($appinfo["Version"]["DisplayVersion"] -ne $tag2){
        $appinfo["Version"]["PackageVersion"]=-join($tag2,".0")
        $appinfo["Version"]["DisplayVersion"]=$tag2

        # Installer.ini
        $installer = Get-IniContent ".\GitHubDesktopPortable\App\AppInfo\installer.ini"
        $installer["DownloadFiles"]["DownloadURL"]="https://central.github.com/deployments/desktop/desktop/latest/GitHubDesktop-$tag2-x64-full.nupkg"
        $installer["DownloadFiles"]["DownloadName"]="GitHubDesktop-$tag2-x64-full.nupkg"
        $installer["DownloadFiles"]["DownloadFilename"]="GitHubDesktop-$tag2-x64-full.nupkg"
        $installer | Out-IniFile -Force -Encoding ASCII -Pretty -FilePath ".\GitHubDesktopPortable\App\AppInfo\installer.ini"

        #appinfo.ini
        #$appinfo["Control"]["BaseAppID"]=-join("%BASELAUNCHERPATH%\App\",$asset1.name.replace('.zip',''),"\prusa-slicer.exe")
        #$appinfo["Control"]["BaseAppID64"]=-join("%BASELAUNCHERPATH%\App\",$asset2.name.replace('.zip',''),"\prusa-slicer.exe")
        #$appinfo | Out-IniFile -Force -Encoding ASCII -FilePath ".\GitHubDesktopPortable\App\AppInfo\appinfo.ini"

        # launcher.ini
        ((Get-Content -path ".\GitHubDesktopPortable\App\AppInfo\Launcher\GitHubDesktopPortable.ini" -Raw) -replace 'app-\d{1,5}.\d{1,5}.\d{1,5}',"app-$tag2") | Set-Content -Path ".\GitHubDesktopPortable\App\AppInfo\Launcher\GitHubDesktopPortable.ini"

        # PortableApps.comInstallerCustom.nsh
        ((Get-Content -path ".\GitHubDesktopPortable\Other\Source\PortableApps.comInstallerCustom.nsh" -Raw) -replace 'app-\d{1,5}.\d{1,5}.\d{1,5}',"app-$tag2") | Set-Content -Path ".\GitHubDesktopPortable\Other\Source\PortableApps.comInstallerCustom.nsh"


        Write-Host "Bumped to "+$tag2
        echo "SHOULD_COMMIT=yes" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    }
    else{
      Write-Host "No changes."
      echo "SHOULD_COMMIT=no" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    } 
}
