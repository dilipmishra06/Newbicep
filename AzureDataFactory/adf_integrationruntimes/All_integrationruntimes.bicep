param applicationName string
param environmentAffix string
param virtualNetworkName string
param dataFactoryName string


var azureSqlIntegrationRuntimeName = 'ir-${applicationName}-azurestlrft-${environmentAffix}'

module ir_AzureSTLRFT 'ir_azureSTLRFT.bicep' = {
  name: 'add-ir-azureSTLRFT'
  params: {
    azureSqlIntegrationRuntimeName: azureSqlIntegrationRuntimeName
    dataFactoryName: dataFactoryName
    virtualNetworkname: virtualNetworkName
  }
}

output azureIntegrationRuntimeName string = ir_AzureSTLRFT.outputs.irname
