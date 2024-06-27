using './main.bicep'

param name = 'synapseworkspacedempfl'
param tags = {}

param defaultDataLakeStorageAccountResourceId = '/subscriptions/subscriptionid/resourcegroups/rgname/providers/Microsoft.Storage/storageAccounts/storageaccountname'
param defaultDataLakeStorageFilesystem = 'demo'
param sqlAdministratorLogin = 'sqladmin'


