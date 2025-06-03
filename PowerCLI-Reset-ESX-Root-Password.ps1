$esxcli = Get-EsxCli -VMhost ESX1.domain.net -V2
$arguments = $esxcli.system.account.set.CreateArgs()
$arguments.id = 'root'
$arguments.password = 'T0tal1y$ecure'
$arguments.passwordconfirmation = 'T0tal1y$ecure'
$arguments

$esxcli.system.account.set.Invoke($arguments)
