param dataFactoryName string
param azureSqlLinkedServiceName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource ds_ProcessLog 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: 'DatasetProcessLog'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: azureSqlLinkedServiceName
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'AzureSqlDWTable'
    schema: [
      {
        name: 'Id'
        type: 'bigint'
        precision: 19
      }
      {
        name: 'ProcessId'
        type: 'uniqueidentifier'
      }
      {
        name: 'LogDate'
        type: 'datetime2'
        scale: 0
      }
      {
        name: 'Message'
        type: 'varchar'
      }
      {
        name: 'Severity'
        type: 'varchar'
      }
    ]

    typeProperties: {
      schema: 'Log'
      table: 'ProcessLog'
    }
  }
}
