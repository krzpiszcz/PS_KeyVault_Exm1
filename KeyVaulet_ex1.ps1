#variables
$ResourceGroupName = 'KP-KeyVault_EX1'
$Location = 'westeurope'
$SQLServerName = 'aslsoftsqlserver'
$DBName = 'MyDB'
$KeyVaultName = 'aslsoftSecureKeyVault'
$dbconnectionstring = 'dbconnection'

#Connect-AzAccount
#Get-AzSubscription

#create new resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force 
#not yet done