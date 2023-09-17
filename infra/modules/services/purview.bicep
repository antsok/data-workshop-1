param location string = resourceGroup().location

param name string = '${uniqueString(subscription().id)}purview'

param tags object = {}

var managedResourceGroupName = '${resourceGroup().name}-${name}-${uniqueString(name, resourceGroup().id)}'
var trimmedMRGName = substring(managedResourceGroupName, 0, min(length(managedResourceGroupName), 90))


resource purview 'Microsoft.Purview/accounts@2021-12-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    managedResourceGroupName: trimmedMRGName
    managedResourcesPublicNetworkAccess: 'Enabled'
  }
  tags: tags
}

output resourceId string = purview.id
output name string = purview.name
