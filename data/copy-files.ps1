


param(
  [Parameter()]
  [String]$request
)

$copies="\copy\"

$location=Get-Location
$parent=Split-Path -Path $location -Parent
$location=$location.Path

$copyFolder=$location+$copies



$launches=@("run.bat", "run-previous.bat", "uninstall.bat")
$setups=@("setup.bat")


function Copy-LaunchFiles {
    for (($slot=0);$slot -lt $launches.Count; $slot++) {

        $currentPath=$copyFolder+($launches[$slot])
        if (!(Test-Path ($parent+"\"+($launches[$slot])) -PathType Leaf)) {
            Copy-Item $currentPath -Destination $parent
        }
    }

    for (($slot=0);$slot -lt $setups.Count; $slot++) {

        if (Test-Path ($parent+"\"+($setups[$slot])) -PathType Leaf) {
        Remove-Item ($parent+"\"+($setups[$slot]))
        }
    }
}


function Copy-SetupFiles {
    for (($slot=0);$slot -lt $setups.Count; $slot++) {

        $currentPath=$copyFolder+($setups[$slot])
        if (!(Test-Path ($parent+"\"+($setups[$slot])) -PathType Leaf)) {
            Copy-Item $currentPath -Destination $parent
        }
    }

    for (($slot=0);$slot -lt $launches.Count; $slot++) { 

        if (Test-Path ($parent+"\"+($launches[$slot])) -PathType Leaf) {
        Remove-Item ($parent+"\"+($launches[$slot]))
        }
    }
}



if ($request -eq "l") {
    Copy-LaunchFiles
}
elseif ($request -eq "s") {
    Copy-SetupFiles
}