$query1 = Read-Host "Please enter whole or partial VM Name *servername*"

get-vm -name $query1 | Get-View |
Select Name,

@{N='IPAddress';E={$_.Guest.ipAddress}},
@{N='Gateway';E={($_.Guest.ipstack.iprouteconfig.iproute.gateway.ipaddress | where{$_ -ne $null}) -join '|'}},
@{N='SubnetMask';E={
    $ipAddr = $_.Guest.ipAddress
    @(($_.Guest.Net.ipconfig.ipaddress | where{$ipAddr -contains $_.IpAddress -and $_.PrefixLength -ne 0}).PrefixLength | %{
        [IPAddress]$ip = 0;
        $ip.Address = (([UInt32]::MaxValue) -shl (32 - $_) -shr (32 - $_))
        $ip.IPAddressToString
    }) -join '|'
}},
@{N='DNS';E={[string]::Join(',',($_.Guest.IpStack.DnsConfig.IpAddress))}},
@{N='MacAddress';E={($_.Config.Hardware.Device | where{$_ -is [VMware.Vim.VirtualEthernetCard]}).MacAddress -join '|'}},
@{N='VlanId';E={$folder = Get-Folder VM
        $folderView = Get-View $folder -Property "[VirtualMachine]ChildEntity.Network.*"
        $folderView.LinkedView.ChildEntity[0].LinkedView.Network | Select-Object -ExpandProperty Name}},
@{N='Network Adapter';E={$_.Config.Hardware.Device  |  Where {$_ -is [VMware.Vim.VirtualEthernetCard]} | ForEach {$_.GetType().Name.Replace('Virtual','')}}} 
