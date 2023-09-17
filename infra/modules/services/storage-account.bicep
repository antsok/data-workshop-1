@description('''Storage account name. Must be globally unique.
Character limit: 3-24
Valid characters: Lowercase letters and numbers
''')
@minLength(3)
@maxLength(24)
param name string = '${uniqueString(resourceGroup().id)}sta'

@description('Location for storage account resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Storage account SKU. Defaults to Standard_LRS.')
@allowed(['Standard_LRS','Standard_ZRS'])
param skuName string = 'Standard_LRS'

@description('Storage account kind. Defaults to StorageV2.')
@allowed(['StorageV2'])
param kind string = 'StorageV2'

@description('Storage account access tier. Defaults to Hot.')
@allowed(['Hot','Cool'])
param accessTier string = 'Hot'

@description('Enable Hierarchical Namespace (DataLakeV2). Defaults to fase.')
param isHnsEnabled bool = false

@description('Tags for the resource. Optional.')
param tags object = {}

@description('''List of blob containers to create in the storage account. Optional.
Format : [ { name: 'container1' }, { name: 'container2' } ]
''')
param blobContainers array = []


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  kind: kind
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    accessTier: accessTier
    isHnsEnabled: isHnsEnabled
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = if(length(blobContainers) > 0) {
  name: 'default'
  parent: storageAccount
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = [for container in blobContainers: {
  name: container.name
  parent: blobService
}]

output name string = storageAccount.name
output resourceId string = storageAccount.id
output endpointBlob string = storageAccount.properties.primaryEndpoints.blob
output endpointFile string = storageAccount.properties.primaryEndpoints.file
output endpointDfs string = storageAccount.properties.primaryEndpoints.dfs
