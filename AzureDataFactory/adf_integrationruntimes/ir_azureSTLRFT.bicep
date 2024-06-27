param azureSqlIntegrationRuntimeName string
param dataFactoryName string
param virtualNetworkname string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource ir_azureSTLRFT 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: azureSqlIntegrationRuntimeName
  parent: dataFactory
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'East US'
        dataFlowProperties: {
          computeType: 'General'
          coreCount: 8
          timeToLive: 10
          cleanup: false
        }
      }
    }

    managedVirtualNetwork: {
      referenceName: virtualNetworkname
      type: 'ManagedVirtualNetworkReference'
    }
  }
}

output irname string = ir_azureSTLRFT.name
