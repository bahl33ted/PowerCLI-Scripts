$cluster="Retail-Site-1"
$snapMsg="Snap to cleanup CBT issues for vmotion"

Write-host "VMs to be snapped"
get-cluster -name $cluster |get-vm|Where-Object { $_.Name -notlike '*SEC*' -and $_.powerstate -notlike 'PoweredOff'}
Write-Host "Changing all CDRoms to Client Device and disconnecting"
get-cluster -name $cluster |get-vm|Get-CDDrive | Where {$_.ISOPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$false
Write-host "----------Waiting 30 Seconds for removal CDRoms"
Start-Sleep -Seconds 30
Write-host "----------Snapping VMs, if you see errors investigate"
get-cluster -name $cluster |get-vm |Where-Object { $_.Name -notlike '*SEC*' -and $_.powerstate -notlike 'PoweredOff'}|New-Snapshot -Name "CBT Correction" -Description "Please Delete" -Quiesce:$true
Write-host "----------Waiting 30 Seconds for the snaps to be created"
Start-Sleep -Seconds 30
Write-host "----------Here are the snaps that were created"
get-cluster -name $cluster |get-vm|get-snapshot |select VM,Name,Description
Write-host "----------Waiting 30 Seconds then removing the snapshots.  Errors will be seen"
Start-Sleep -Seconds 30
get-cluster -name $cluster |get-vm|get-snapshot|Remove-Snapshot 
Write-host "----------Waiting 30 Seconds for removal of snapshots prior to checking"
Start-Sleep -Seconds 30
Write-host "----------Showing if any snapshots were left."
get-cluster -name $cluster |get-vm|get-snapshot |select VM,Name,Description
