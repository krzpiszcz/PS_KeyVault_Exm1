#variables
$ResourceGroupName = 'KP-KeyVault_EX1'
$Location = 'westeurope'
$SQLServerName = 'aslsoftsqlserver'
$DBName = 'MyDB'
$KeyVaultName = 'aslsoftSecureKeyVault'
$dbconnectionstring = 'dbconnection'

### install packages
install-package azure.core
install-package microsoft.data.SqlClient
### Import modules
#Import-Module Az.KeyVault -force

##connect to Azure
#Connect-AzAccount

##list subscriptions
#Get-AzSubscription

#Resource group
# New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force 
##Get-AzResourceGroup

###create SQL Server and Database
# New-AzSqlServer -ServerName $SQLServerName `
#                 -ResourceGroupName $ResourceGroupName  `
#                 -Location $Location `
#                 -ServerVersion '12.0' `
#                 -SqlAdministratorCredentials (Get-Credential) `
#                 -Verbose

### create SQL DB in SQL Server
# New-AzSqlDatabase -DatabaseName $DBName `
#                     -ServerName $SQLServerName `
#                     -ResourceGroupName $ResourceGroupName `
#                     -Verbose

###It will create firewall rule for specific range of IP address on the database server
#New-AzSqlServerFirewallRule -ServerName $SQLServerName -FirewallRuleName 'dbfirewall' -ResourceGroupName $ResourceGroupName -StartIpAddress '10.10.10.10' -EndIpAddress '10.10.10.20' -Verbose

###It will create firewall rule for all IP address on the database server
#New-AzSqlServerFirewallRule -ServerName $SQLServerName -ResourceGroupName $ResourceGroupName -AllowAllAzureIPs 

###create Rule with ClientIP address



##It will create Key Vault in Azure
#New-AzKeyVault -Name $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location -Sku Standard 

##Below two commands will create a secret value for the database connection string and will add it to the Azure key vault as a secret.
##Once done, we do not need to keep connection string (sensitive information) in the script to connect to the database.
#$secretvalue = ConvertTo-SecureString -String 'Server=tcp:<serrrver>.database.windows.net,1433;Initial Catalog=MyDB;Persist Security Info=False;User ID=<user>;Password=<pass>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;' -AsPlainText -Force
#Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $dbconnectionstring -SecretValue $secretvalue 


##Section to create table and write some data to table in Azure SQL
##This line is reading Azure key vault for the database connection string (secret)
$connection = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $dbconnectionstring -AsPlainText

#### connection with Invoke-SQL
## wrote query here and it can be imported from sql script file.
$query = @"
            Create Table tblProduct
            (
                ID int IDENTITY(1,1) PRIMARY KEY,
                ProductName varchar(50) NOT NULL,
                Quantity int
            )
            Insert into tblProduct (ProductName,Quantity)
            Values ('iPhone',1)
"@

Invoke-Sqlcmd -query $query -ConnectionString $connection

#### connection with SQL Client
# $conn = New-Object System.Data.SqlClient.SqlConnection($connection)
# #Database connection established
# $conn.Open() 
### wrote query here and it can be imported from sql script file.
# $query = @"
#             Create Table tblProduct
#             (
#                 ID int IDENTITY(1,1) PRIMARY KEY,
#                 ProductName varchar(50) NOT NULL,
#                 Quantity int
#             )
#             Insert into tblProduct (ProductName,Quantity)
#             Values ('iPhone',1)
# "@

#$cmd= New-Object System.Data.SqlClient.SqlCommand($query,$conn)

###Database query executed
#$cmd.ExecuteNonQuery() 

###Database connection closed 
#$conn.Close() 