// This bicep template creates a platform part of the data management and analytics platform

// This template creates the following resources:
// - Resource Group
// - Data Lake ( Azure Storage Account Gen2)
// - Blob Storage ( Azure Storage Account)

targetScope = 'subscription'

param location string = 'westeurope'

param lakeResourceGroupName string = 'data-platform-lake-rg'

param samplesResourceGroupName string = 'data-platform-samples-rg'

// Data Lake

resource lakeResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: lakeResourceGroupName
  location: location
}

module dataLake './modules/services/storage-account.bicep' = {
  name: '${deployment().name}-dataLake'
  scope: lakeResourceGroup
  params: {
    location: location
    isHnsEnabled: true
    accessTier: 'Hot'
    skuName: 'Standard_LRS'
  }
}

// Samples

resource samplesResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: samplesResourceGroupName
  location: location
}

module samples './modules/services/storage-account.bicep' = {
  name: '${deployment().name}-samples'
  scope: samplesResourceGroup
  params: {
    location: location
    isHnsEnabled: false
    accessTier: 'Cool'
    skuName: 'Standard_LRS'
  }
}
