using './sql.bicep'

param sqlServerName = 'demoflsqldwh'
param databaseName = 'demodb'
param serviceConnection = {
  name : 'serviceprincipal'
  appid : 'b9cd5157-bfdc-43bb-a55f-7298a59d1e0e'
}
param dmzGreenIpAddresses = []

