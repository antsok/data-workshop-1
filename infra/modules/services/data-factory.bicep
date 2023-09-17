@description('''Name of the data factory resource. Must be unique across Azure.
Valid characters: Alphanumerics and hyphens. Start and end with alphanumeric.
''')
@minLength(3)
@maxLength(63)
param name string = '${uniqueString(resourceGroup().id)}adf'

@description('Location for storage account resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Tags for the resource. Optional.')
param tags object = {}

@allowed(['FactoryGitHubConfiguration','FactoryVSTSConfiguration'])
param repositoryType string = 'FactoryGitHubConfiguration'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
  }
}

output resourceId string = dataFactory.id
output name string = dataFactory.name
