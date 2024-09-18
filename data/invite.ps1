$loc=Get-Location
$loc=$loc.Path


$path=$loc+"`\zrok.exe"
$copyRuns=$loc+"`\copy-files.ps1"




function Copy-Runnables {
& $copyRuns "l"
}



if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
 Write-Host -ForegroundColor Green "Zrok was already enabled!"
  Copy-Runnables
  Start-Sleep -Seconds 3
 return
}

Write-Host -ForegroundColor Yellow "Note: If you've already signed up on the zrok website you don't need to sign up again."
Write-Host -ForegroundColor Yellow "Just log into the zrok website and retrieve your code from your profile to enable your console."
Write-Host -ForegroundColor Blue "Make sure you log in via: api.zrok.io and NOT: myzrok.io"
Write-Host -ForegroundColor DarkGray "Enter any key to skip the invite process. Otherwise only press [ENTER] to be invited."
$press = [System.Console]::ReadKey()
$key = $press.Key
$key = $key.ToString().toLower()

if ($key -eq "enter") {
Start-Process -FilePath "$path" -ArgumentList "invite" -Wait
}
else {
    Clear-Host
    Write-Host -ForegroundColor Green "Skipping invite..."
}


Write-Host -ForegroundColor Blue "Enter the code which you obtained from signing up for zrok:"
$key=Read-Host ">"



while (1) {
Start-Process -FilePath "$path" -ArgumentList "enable $key" -Wait

if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
    break
} else {
    Write-Host -ForegroundColor Red "Zrok was not enabled! Check your token!"
    Write-Host -ForegroundColor Yellow "To try and setup another time, Press [ENTER] without writing anything."
    Write-Host -ForegroundColor Yellow "Otherwise you can continue trying to enter your token."
    $key=Read-Host ">"

    if ($key.Length -eq 0) {
        return
    }
 }
}

Copy-Runnables
Write-Host -ForegroundColor Green "Zrok enabled. You can now join servers via the client."
Start-Sleep -Seconds 3





