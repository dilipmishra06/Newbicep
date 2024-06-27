@maxLength(50)
@description('Required. The name of the Synapse Workspace.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource.')
param azureADOnlyAuthentication bool = false

@description('Required. Resource ID of the default ADLS Gen2 storage account.')
param defaultDataLakeStorageAccountResourceId string

@description('Required. The default ADLS Gen2 file system.')
param defaultDataLakeStorageFilesystem string

@description('Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace\'s primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.')
param defaultDataLakeStorageCreateManagedPrivateEndpoint bool = true

@maxLength(90)
@description('Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and \'-\', \'_\', \'(\', \')\' and\'.\'. Note that the name cannot end with \'.\'.')
param managedResourceGroupName string = ''

@description('Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.')
param managedVirtualNetwork bool = true

@description('Optional. Allowed AAD Tenant IDs For Linking.')
param allowedAadTenantIdsForLinking array = []

@description('Optional. Linked Access Check On Target Resource.')
param linkedAccessCheckOnTargetResource bool = false

@description('Optional. Prevent Data Exfiltration.')
param preventDataExfiltration bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable or Disable public network access to workspace.')
param publicNetworkAccess string = 'Enabled'

@description('Required. Login for administrator access to the workspace\'s SQL pools.')
param sqlAdministratorLogin string

@description('Optional. Password for administrator access to the workspace\'s SQL pools. If you don\'t provide a password, one will be automatically generated. You can change the password later.')
@secure()
param sqlAdministratorLoginPassword string = ''

@description('Optional. The account URL of the data lake storage account.')
param accountUrl string = 'https://${last(split(defaultDataLakeStorageAccountResourceId, '/'))!}.dfs.${environment().suffixes.storage}'

@description('Optional. Git integration settings.')
param workspaceRepositoryConfiguration object?

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azureADOnlyAuthentication: azureADOnlyAuthentication ? azureADOnlyAuthentication : null
    defaultDataLakeStorage: {
      resourceId: defaultDataLakeStorageAccountResourceId
      accountUrl: accountUrl
      filesystem: defaultDataLakeStorageFilesystem
      createManagedPrivateEndpoint: managedVirtualNetwork ? defaultDataLakeStorageCreateManagedPrivateEndpoint : null
    }
    managedResourceGroupName: !empty(managedResourceGroupName) ? managedResourceGroupName : null
    managedVirtualNetwork: managedVirtualNetwork ? 'default' : null
    managedVirtualNetworkSettings: managedVirtualNetwork
      ? {
          allowedAadTenantIdsForLinking: allowedAadTenantIdsForLinking
          linkedAccessCheckOnTargetResource: linkedAccessCheckOnTargetResource
          preventDataExfiltration: preventDataExfiltration
        }
      : null
    publicNetworkAccess: managedVirtualNetwork ? publicNetworkAccess : null
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: !empty(sqlAdministratorLoginPassword) ? sqlAdministratorLoginPassword : null
    workspaceRepositoryConfiguration: workspaceRepositoryConfiguration
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: 'demoaccdl'
}

resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(workspace.id)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '17d1049b-9a84-46fb-8f53-869881c3d3ab'
    )
    principalId: workspace.identity.principalId
  }
  scope: storageacc
}

@description('The resource ID of the deployed Synapse Workspace.')
output resourceID string = workspace.id

@description('The name of the deployed Synapse Workspace.')
output name string = workspace.name

@description('The resource group of the deployed Synapse Workspace.')
output resourceGroupName string = resourceGroup().name

@description('The workspace connectivity endpoints.')
output connectivityEndpoints object = workspace.properties.connectivityEndpoints

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = workspace.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = workspace.location
