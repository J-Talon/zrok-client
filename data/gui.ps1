
$location = Get-Location
$location = $location.Path

$keyPath = "\keys.txt"
$recent = "\previous.txt"


$keyFile = $location+$keyPath
$previous = $location+$recent


if (-Not (Test-Path $keyFile -PathType Leaf)) {
  Write-Host -ForegroundColor red "===COULD NOT FIND KEY FILE==="
  Write-Host " ` ` ` "
  Write-Host "Calculated path: " ` $keyFile

  Write-Host -ForegroundColor Red "============================="
  Read-Host "Press [ENTER] to continue..."
  return
}


if (-Not (Test-Path $previous -PathType Leaf)) {
  Write-Host -ForegroundColor red "===COULD NOT LOAD RECENT KEYS==="
  Write-Host " ` ` ` "
  Write-Host "Calculated path: " ` $previous

  Write-Host -ForegroundColor Red "============================="
  Read-Host "Press [ENTER] to continue..."
}



$data = New-Object System.Collections.ArrayList


function Main-Menu($array) {

 while (1) {
 Write-Host -ForegroundColor green "What do you want to do?  [D] Delete key | [R] Run Zrok | [A] Add Key | [S] Show Keys | [E] Exit"
 $option = Read-Host ">"
 $option = $option.ToLower()

  switch ($option) {
   "r" {
    Run-key($array)
   } 

   "d" {
   Delete-Key($array)
   }

   "a" {
   Add-Key($array)
   }

   "s" {
    Show-Keys($array)
   }

   "e" {
   Exit
   }

   default {
   Write-Host -ForegroundColor Red "Invalid option "$option
   }
  }
 }
}


function Show-Keys($array) {
  if ($array.Count -eq 0) {
    Write-Host "You have no keys."
    return
  }

  for (($slot=0); $slot -lt $array.Count; $slot ++) {
    Write-Host [$slot] $array[$slot]
  }
}




function Delete-Key($array) {

while (1) {
 if ($array.Count -eq 0) {
 Write-Host "You have no keys to delete."
 return
 }

 Write-Host "Choose key to delete. [E] to exit."
 for (($slot=0); $slot -lt $array.Count; $slot ++) {
  Write-Host [$slot] $array[$slot]
 }

 $choice = Read-Host ">"
 $choice = $choice.ToLower()
 $res = 0

 if ([int]::TryParse($choice, [ref]$res)) {

  if ($res -eq 0 -and $array.Count -eq 1) {

  $removed = $array[$res]
  $array.RemoveAt(0)
  Clear-Content $keyFile

  Write-Host -ForegroundColor Yellow "Deleted key: "$removed
  }
  elseif (($res -gt 0 -or $res -eq 0) -and ($res -lt ($array.Count))) {
   $removed = $array[$res]
   $array.RemoveAt($res)
   Clear-Content $keyFile
  
   $array | Out-File $keyFile
  
   Write-Host -ForegroundColor Yellow "Deleted key: "$removed

  }
  else {
  Write-Host -ForegroundColor Red "Enter a number from 0 to"($array.Count-1)
  }


 }
 else {
 
 if ($choice -eq "e") {
 return
  }

  Write-Host -ForegroundColor Red "Invalid command."
 }

 } #while
}




function Add-Key($array) {
 Write-Host "Enter a new key:"
 $key = Read-Host ">"
 if ($key.Length -eq 0 -or $key.Length -lt 1) {
  Write-Host "Invalid key."
  return
 }

 $temp = $array.Add($key)
 Write-Host -ForegroundColor Green "Added new key: "$key

 Clear-Content $keyFile

 $array | Out-File $keyFile


}



function Start-Zrok($PRIVATE_ACCESS_TOKEN) {

$a=Get-Location
$a=$a.Path
$b="\zrok.exe"

$PATH_TO_ZROK=$a+$b



 if (Test-Path $PATH_TO_ZROK -PathType Leaf) {
        
  } else {
        Write-Host -ForegroundColor Red "==== PATH_TO_ZROK incorrect! ===="
        Write-Host " ` ` ` "
        Write-Host "Calculated:" ` $PATH_TO_ZROK
        Write-Host " ` ` ` "
        Write-Host "Working Dir:" ` $a
        return
  }


Write-Host " ` "
Write-Host " ` "
Write-Host " ` "

Write-Host -ForegroundColor Blue "Enter the server port. This should be a positive integer."

$PORT = Read-Host ">"

$value = 0
if ([int]::TryParse($PORT,[ref]$value)) {


 if ($value -gt 0) {
   Write-Host -ForegroundColor Green "Port number is valid. Continuing..."
   Write-Host " ` "
   Write-Host " ` "
   Write-Host " ` "
  } 
 else {
  Write-Host -ForegroundColor Red "Invalid port number, exiting."
  return 0
  }

}
else {
 Write-Host -ForegroundColor Red "Invalid port number, exiting."
 return 0
}

Write-Host -ForegroundColor Red "!!IMPORTANT!! When you want to exit zrok click on the window, hold down [CTRL],"
Write-Host -ForegroundColor Red "and while you are doing so, tap [C] UNTIL IT EXITS"
Write-Host -ForegroundColor Red "If you don't it will run in the background until you restart your PC. << This is bad."

#I know some impatient person is probably gonna 
#try to edit the code just to skip the 10 seconds. 
#So as long as you understand how to exit properly I don't care.
#Just don't come to me asking why you can't connect.


Write-Host -ForegroundColor DarkGray "Please press [ENTER] once you understand how to exit zrok properly."

Read-Host ">"

Write-Host " ` "
Write-Host -ForegroundColor Green "Zrok client is starting..."

Write-Host " ` "
Write-Host " ` "
Write-Host " ` "

Write-Host -ForegroundColor Blue "Please allow the process to run in the security window if it pops up."


#For the impatient people out there.
#Okay but still though like... why??? It's literally just 2 clicks and whatnot, but okay sure. 
$lastKey = $PRIVATE_ACCESS_TOKEN+" "+$PORT
Clear-Content $previous
$lastKey | Out-File $previous

Start-Sleep -Seconds 3

Start-Process -FilePath "$PATH_TO_ZROK" `
    -ArgumentList "access private $PRIVATE_ACCESS_TOKEN --bind 127.0.0.1:${PORT}" `
    -PassThru

return 1

}




function Run-Key($array) {

if (Test-Path "$env:USERPROFILE\.zrok\environment.json" -PathType Leaf) {
} else {
    Write-Host -ForegroundColor Red "Enable zrok first!"
    $copies=$location+"\copy-files.ps1"
    & $copies "s"
    return
}


if ($array.Count -eq 0) {
 Write-Host -ForegroundColor Yellow "You have no keys. Add one first."
 return
}

 while (1) {  #while true
 Write-Host -ForegroundColor Yellow "Choose key to run. [E] to exit: "

   for (($slot = 0); $slot -lt $array.Count; $slot ++) {
   Write-Host [$slot] $array[$slot]
   }
   $choice = Read-Host ">"
   $choice = $choice.ToLower()
   $res = 0

   if ([int]::TryParse($choice, [ref]$res)) {

   if ($res -eq  0 -and $array.Count -eq 1) {
    Write-Host "Starting zrok with key:" $array[$res]
    Start-Sleep -Seconds 1
    $res=Start-Zrok($array[$res])

    if ($res) {
      Exit
     }

    }
    elseif (($res -gt 0 -or $res -eq 0) -and ($res -lt ($array.Count))) {
      ##run the process here
      Write-Host -ForegroundColor Blue "Starting zrok with key:" $array[$res]
      Start-Sleep -Seconds 1
      Start-Zrok($array[$res])
      
      if ($res) {
        Exit
      }
    }
    else {
    Write-Host -ForegroundColor Red "Invalid option. Enter a number from 0 to"($array.Count-1)
    }
   }
   else {
    
    if ($choice -eq "e") {
    Write-Host "Exiting selection..."
     return
    }
    Write-Host -ForegroundColor Red "Invalid command"
   }
  }

}



################################################









foreach ($line in Get-Content $keyFile) {
 $temp = $data.Add($line)  #temp for no printing
}

Main-Menu($data)



