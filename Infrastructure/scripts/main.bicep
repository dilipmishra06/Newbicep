var datafactoryName = 'adf-kavi-demo-fl'
module datafactory '../../generic-modules/data-factory/main.bicep' = {
  name: datafactoryName
  params: {
    name: datafactoryName
  }
}
