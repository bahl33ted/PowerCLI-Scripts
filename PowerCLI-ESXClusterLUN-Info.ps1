$lunpathinfo = @()
foreach ($vmhost in get-cluster "*ESX-ClusterName*" | get-vmhost) {
$hostview= get-view $vmhost.id
$hostview.config.storagedevice.multipathinfo.lun | % { `
    $lunname=$_.id
    $lunpolicy=$_.policy.policy
    $_.path | % {
        $pathstate=$_.pathstate
        $lunpathinfo += "" | select @{name="Hostname"; expression={$vmhost.name}},
                                    @{name="LunName"; expression={$lunname}}, 
                                    @{name="LunPolicy"; expression={$lunpolicy}}, 
                                    @{name="PathState"; expression={$pathstate}}
    }
}
}
$lunpathinfo | export-csv -path $env:userprofile\ESXVCS.csv -NoTypeInformation
