    Clear-Host
    Write-Host "============= Select a vCenter Environment ============="
    write-host "`n"
    Write-Host "`t 1: Press '1' for Production."
    Write-Host "`t 2: Press '2' for Azure."
    Write-Host "`t 3: Press '3' for eCOM."
    Write-Host "`t 4: Press '4' for Test/Dev."
    Write-Host "`t 5: Press '5' for Retail."
    Write-Host "`t 9: Press '9' for ALL."
    Write-Host "`t X: Press 'X' to disconnect."
    write-host "`n"

 $selection = Read-Host "Please make a selection"
 switch ($selection)
 {
     '1' {
         Write-Host "Connecting to Production..."
         $VCenters = @("ProdVC1.domain.net","ProdVC2.domain.net") #Prod
     } '2' {
         Write-Host "Connecting to Azure..."
         $VCenters = @("southcentralus.avs.azure.com","northcentralus.avs.azure.com") #Azure
     } '3' {
         Write-Host "Connecting to eCOM..."
         $VCenters = @("ECom1.domain.net","ECom2.domain.net") #ECom
     } '4' {
         Write-Host "Connecting to Test/Dev..."
         $VCenters = @("Dev1.domain.net","Dev2.domain.net") #Test/Dev
     } '5' {
         Write-Host "Connecting to Retail..."
         $VCenters = @("Retail1.domain.net","Retail2.domain.net") #Retail
     } '9' {
         Write-Host "Connecting to ALL vCenters..."
         $VCenters = @("ProdVC1.domain.net","ProdVC2.domain.net","southcentralus.avs.azure.com","northcentralus.avs.azure.com","ECom1.domain.net","ECom2.domain.net","Dev1.domain.net","Dev2.domain.net","Retail1.domain.net","Retail2.domain.net")
     } {$selection -match "^[\d\.]+$"} {
         $creds = get-credential
         $Error.Clear()
         Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null  #Ignore connection errors to vCenter
         foreach($vc in $VCenters) { 
            try {
                Connect-VIServer -Server $vc -credential $creds -WarningAction 0 -ErrorAction Stop # | Out-Null                
            }catch{
                Write-Host "vCenter with the name $vc is not responding" -ForegroundColor "Red"
                Continue
            }
         }
     } 'X' {
         Write-Host "Disconnecting..."
         Disconnect-VIServer -Server * -Confirm:$false
         Start-Sleep -Seconds 2
         Disconnect-VIServer -Server * -Confirm:$false
     } Default {
         Write-Host "Default Active"
     }
 }

 Exit

