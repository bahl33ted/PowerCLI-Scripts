#Check Status Before
Get-VMHost -PipelineVariable VarHost | Get-VMHostService -Refresh | Where {$_.Key -eq "sfcbd-watchdog"} | select @{n='VMHost';e={$VarHost.name}}, key, label, Policy, Running, Required | export-csv -path .\CIM-before.csv -NoTypeInformation

#Disable CIM/Watchdog Service
Get-VMHost | Get-VMHostService | ?{$_.key -eq "sfcbd-watchdog" -and $_.running -eq $true} | Stop-VMHostService -Confirm:$false
Get-VMHost | Get-VMHostService | Where {$_.Key –eq "sfcbd-watchdog”} | Set-VMHostService -Policy Off -Confirm:$false

#Check Status After
Get-VMHost -PipelineVariable VarHost | Get-VMHostService -Refresh | Where {$_.Key -eq "sfcbd-watchdog"} | select @{n='VMHost';e={$VarHost.name}}, key, label, Policy, Running, Required | export-csv -path .\CIM-after.csv -NoTypeInformation
