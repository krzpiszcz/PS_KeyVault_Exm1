#variables
$ResourceGroupName = 'KP-KeyVault_EX1'
$Location = 'westeurope'
$SQLServerName = 'aslsoftsqlserver'
$DBName = 'MyDB'
$KeyVaultName = 'aslsoftSecureKeyVault'
$dbconnectionstring = 'dbconnection'

#Connect-AzAccount
#Get-AzSubscription

#Resource group
## New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force 
#Get-AzResourceGroup

##create SQL Server and Database
New-AzSqlServer -ServerName $SQLServerName `
                -ResourceGroupName $ResourceGroupName  `
                -Location $Location `
                -ServerVersion '12.0' `
                -SqlAdministratorCredentials (Get-Credential) `
                -Verbose
                
#New-AzSqlDatabase -DatabaseName $DBName `
#                    -ServerName $SQLServerName `
#                    -