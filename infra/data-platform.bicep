// This bicep template creates a platform part of the data management and analytics platform

// This template creates the following resources:
// - Resource Group
// - Data Lake Gen2 (on Azure Storage Account)
// - Blob Storage

targetScope = 'subscription'

param location string = 'westeurope'

param lakeResourceGroupName string = 'data-platform-lake-rg'

param samplesResourceGroupName string = 'data-platform-samples-rg'

param deployPurview bool = false

param tags object = {}

// Management

resource managementResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if(deployPurview) {
  name: 'data-platform-management-rg'
  location: location
  tags: tags
}

module purview 'modules/services/purview.bicep' = if(deployPurview) {
  name: '${deployment().name}-purview'
  scope: managementResourceGroup
  params: {
    location: location
    tags: tags
  }
}

// Data Lake

resource lakeResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: lakeResourceGroupName
  location: location
  tags: tags
}

module dataLake './modules/dataLake.bicep' = {
  name: '${deployment().name}-dataLake'
  scope: lakeResourceGroup
  params: {
    name: 'ourlake000${uniqueString(subscription().id)}'
    location: location
    tags: tags
    filesystems: [
      {
        name: 'prepared'
      }
      {
        name: 'curated'
      }
    ]
  }
}

// Samples

resource samplesResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: samplesResourceGroupName
  location: location
  tags: tags
}

module samples './modules/services/storage-account.bicep' = {
  name: '${deployment().name}-samples'
  scope: samplesResourceGroup
  params: {
    location: location
    tags: tags
    isHnsEnabled: false
    accessTier: 'Cool'
    skuName: 'Standard_LRS'
    blobContainers: [
      {
        name: 'samples'
      }
    ]
  }
}

output lakeResourceId string = dataLake.outputs.resourceId
output lakeAccountName string = dataLake.outputs.name
