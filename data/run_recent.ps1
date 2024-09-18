

$recentKeys="`\previous.txt"

$location=Get-Location
$location=$location.Path
$path=$location+$recentKeys
$zrokPath="\zrok.exe"

$PATH_TO_ZROK=$location+$zrokPath

$line=Get-Content $path

$array=$line -split " "

if (!($array.Count -eq 2)) {
    Write-Host -ForegroundColor Red "No valid recent keys detected. Run the client first with a given key and port before attempting to perform fast-load."
    Write-Host -ForegroundColor DarkGray "Press any key to continue."
    [System.Console]::ReadKey()
    return
}

$key=$array[0]
$port=$array[1]

Write-Host -ForegroundColor Yellow "Attempting to fast-load zrok client from previous installation key..."


if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
} else {
    Write-Host -ForegroundColor Red "Enable zrok first!"
    $copies=$location+"\copy-files.ps1"
    & $copies "s"
    return
}



Write-Host -ForegroundColor Red "!!Reminder!! When you want to exit zrok click on the window, hold down [CTRL],"
Write-Host -ForegroundColor Red "and while you are doing so, tap [C] UNTIL IT EXITS"
Write-Host -ForegroundColor DarkGray "Press any key to continue..."

[System.Console]::ReadKey()


Start-Process -FilePath "$PATH_TO_ZROK" `
    -ArgumentList "access private $key --bind 127.0.0.1:${port}" `
    -PassThru -Wait


Write-Host -ForegroundColor Blue "This window will now close automatically..."
Write-Host -ForegroundColor Green "If zrok started successfully you should see the GUI pop up. Otherwise your last key and/or port may be incorrect."
Start-Sleep -Seconds 10

