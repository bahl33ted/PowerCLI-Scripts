Get-Cluster |
Select Name,DrsEnabled,DrsMode,HAEnabled,HAAdmissionControlEnabled,
    @{N='Host failures cluster tolerates';E={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.FailOverLevel}},
    @{N='Define host failover capacity by';E={
        switch($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.GetTYpe().Name){
        'ClusterFailoverHostAdmissionControlPolicy' {'Dedicated Failover Hosts (H)'}
        'ClusterFailoverResourcesAdmissionControlPolicy' {'Cluster Resource Percentage (R)'}
        'ClusterFailoverLevelAdmissionControlPolicy' {'Slot Policy (s)'}
        }}},
    @{N='(S) Slot Policy ';E={
        if($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.SlotPolicy){'Fixed Slot Size (S-F)'}
        else{'Cover all powered-on VM'}
    }},
    @{N='HA Admission Policy ResourceReductionToToleratePercent';E={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.ResourceReductionToToleratePercent}},
    @{N='Hearthbeat Datastore Policy';E={
        switch($_.ExtensionData.Configuration.DasConfig.HBDatastoreCandidatePolicy){
        'allFeasibleDs' {'Automatically select datastores accessible from the host'}
        'allFeasibleDsWithUserPreference' {'Use datastores from the specified list and complement automatically (L)'}
        'userSelectedDs' {'Use datastores only from the specified list (L)'}
        }
    }},
    @{N='(L) Hearthbeat Datastore';E={(Get-View -Id $_.ExtensionData.Configuration.DasConfig.HeartbeatDatastore -property Name).Name -join '|'}},
    @{N='Host Monitoring';E={$_.ExtensionData.Configuration.DasConfig.HostMonitoring}},
    @{N='Host Failure Response';E={
        if($_.ExtensionData.Configuration.DasConfig.DefaultVmSettings.RestartPriority -eq 'disabled'){'Disabled'}
        else{'Restart VMs'}}},
    @{N='Host Isolation Response';E={$_.ExtensionData.Configuration.DasConfig.DefaultVmSettings.IsolationResponse}},
    @{N='Datastore with PDL';E={$_.ExtensionData.Configuration.DasConfig.DefaultVmSettings.VmComponentProtectionSettings.VmStorageProtectionForPDL}},
    @{N='Datastore with APD';E={$_.ExtensionData.Configuration.DasConfig.DefaultVmSettings.VmComponentProtectionSettings.VmStorageProtectionForAPD}},
    @{N='VM Monitoring';E={$_.ExtensionData.Configuration.DasConfig.VmMonitoring}},
    @{N='vCenter';E={$_.UID.Split(":")[0].Split("@")[1]}} |
export-csv -path $env:userprofile\clusterHA.csv -NoTypeInformation
