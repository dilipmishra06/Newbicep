var applicationName = 'example-app'
var environmentAffix = 'example'
var dataFactoryName = ''

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource mvnet 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: 'managed-vnet'
  parent: dataFactory
  properties: {}
}

module adfIntegrationRuntimes 'adf_integrationruntimes/All_integrationruntimes.bicep' = {
  name: 'add-all-integrationruntimes'
  params: {
    applicationName: applicationName
    dataFactoryName: dataFactoryName
    environmentAffix: environmentAffix
    virtualNetworkName: mvnet.name
  }
}
