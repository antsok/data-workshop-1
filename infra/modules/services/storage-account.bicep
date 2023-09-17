@description('''Storage account name. Must be globally unique.
Character limit: 3-24
Valid characters: Lowercase letters and numbers
''')
@minLength(3)
@maxLength(24)
param storageAccountName string = '${uniqueString(resourceGroup().id)}sta'

@description('Location for storage account resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Storage account SKU. Defaults to Standard_ZRS.')
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: kind
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
