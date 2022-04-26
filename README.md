# PowerCLI-Scripts
My collection of VMWare PowerCLI scripts




Installing PowerCLI in Powershell
----------------------------------
1. Open powershell as Administrator and run each of the following
2. Find-Module -Name VMware.PowerCLI
3. Install-Module -Name VMware.PowerCLI -Scope CurrentUser
4. Get-Command -Module *VMWare*
5. Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false -InvalidCertificateAction Ignore
6. Connect to vcenter environment an test a command like Get-VM.
