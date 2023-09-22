@description('''Storage account name. Must be globally unique.
Character limit: 3-24
Valid characters: Lowercase letters and numbers
''')
@minLength(3)
@maxLength(24)
param name string = '${uniqueString(resourceGroup().id)}sta'

@description('Location for storage account resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Tags for the resource. Optional.')
param tags object = {}

@description('''List of filesystems to create in the storage account. Optional.
Format : [ { name: 'container1' }, { name: 'container2' } ]
''')
param filesystems array = []


module storageAccount 'services/storage-account.bicep' = {
  name: '${deployment().name}-svc-sta'
  params:{
    location: location
    tags: tags
    name: name
    accessTier: 'Hot'
    isHnsEnabled: true
    blobContainers: filesystems
  }
}

output name string = storageAccount.outputs.name
output resourceId string = storageAccount.outputs.resourceId
