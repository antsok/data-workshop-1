// This bicep template creates a workspace (a landing zone) for a data product team, which will be connected to the data platform.

// This template creates the following resources:
// - Resource Group
// - Azure Key Vault
// - Azure Data Factory
// - Azure Databricks
// - Azure Synapse Analytics

targetScope = 'subscription'

param location string = 'westeurope'

param resourceGroupName string = 'data-platform-workspace1-rg'

param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module keyVault 'br/public:security/keyvault:1.0.2' = {
  name: '${deployment().name}-keyvault'
  scope: resourceGroup
  params: {
    location: location
    name: '${uniqueString(resourceGroup.id)}kv'
    enableSoftDelete: false
  }
}

module logAnalytics 'br/public:storage/log-analytics-workspace:1.0.3' = {
  scope: resourceGroup
  name: '${deployment().name}-la'
  params: {
    name: '${uniqueString(resourceGroup.id)}la'
    location: location
    tags: tags
  }
}
// Data Lake
module dataLake 'modules/dataLake.bicep' = {
  name: '${deployment().name}-dataLake'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    filesystems: [
      {
        name: 'staging'
      }
      {
        name: 'raw'
      }
      {
        name: 'synapse'
      }
    ]
  }
}

// Azure Data Factory
module dataFactory 'modules/dataFactory.bicep' = {
  scope: resourceGroup
  name: '${deployment().name}-adf'
  params: {
    location: location
    tags: tags
  }
}

// Azure Databricks
module databricks 'modules/services/data-bricks.bicep' = {
  scope: resourceGroup
  name: '${deployment().name}-adb'
  params: {
    location: location
    tags: tags
  }
}

// Azure Synapse Analytics
module synapse 'modules/services/synapse.bicep' = {
  scope: resourceGroup
  name: '${deployment().name}-synapse'
  params: {
    location: location
    tags: tags
    datalakeStorageAccountName: dataLake.outputs.name
    datalakeFilesystem: 'synapse'
  }
}

output databricksUrl string = databricks.outputs.url
