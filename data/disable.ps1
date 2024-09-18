$loc=Get-Location
$loc=$loc.Path

$path=$loc+"`\zrok.exe"
$copyEnable=$loc+"`\copy\setup.bat"
$copies=$loc+"`\copy-files.ps1"

if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
    Start-Process -FilePath $path -ArgumentList "disable" -Wait


    if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
       Write-Host "Failed to uninstall zrok from console."
    }
    else {
         & $copies "s"
        Write-Host -ForegroundColor Green "Zrok successfully uninstalled."
    }

    Start-Sleep -Seconds 3
 return
}
else {
    Write-Host -ForegroundColor Green "Zrok is not enabled. No action performed."
    Start-Sleep -Seconds 3
}