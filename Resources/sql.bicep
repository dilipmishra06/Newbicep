param sqlServerName string
param databaseName string
param serviceConnection object
param dmzGreenIpAddresses array

module sqlServer '../../generic-modules/sql/server/main.bicep' = {
  name: sqlServerName
  params: {
    name: sqlServerName
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    administrators: {
      azureADOnlyAuthentication: true
      login: serviceConnection.name
      sid: serviceConnection.appId
      principalType: 'Application'
      tenantId: subscription().tenantId
    }
    restrictOutboundNetworkAccess: 'Disabled'

    firewallRules: [
      for (ipAddress, index) in dmzGreenIpAddresses: {
        name: 'DMZ-GREEN-ADF-SHIR-${index}'
        startIpAddress: ipAddress
        endIpAddress: ipAddress
      }
    ]
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: '${sqlServer.name}/${databaseName}'
  location: resourceGroup().location
  sku: {
    name: 'DataWarehouse'
    tier: 'DataWarehouse'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
    isLedgerOn: false
    maxSizeBytes: 263882790666240
  }
}

output sqldbResourceId string = sqlDatabase.id
