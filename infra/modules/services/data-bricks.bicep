// This modules creates Azure Databricks workspace

param location string = resourceGroup().location

@description('''The name of the Azure Databricks workspace.
Character limit: 3-64
Valid characters: Alphanumerics, underscores, and hyphens
''')
@minLength(3)
@maxLength(64)
param name string = '${uniqueString(resourceGroup().id)}adb'

@description('The SKU of the Azure Databricks workspace. Default value is standard.')
@allowed(['standard','premium'])
param sku string = 'standard'

param tags object = {}

var managedResourceGroupName = '${resourceGroup().name}-${name}-${uniqueString(name, resourceGroup().id)}'
var trimmedMRGName = substring(managedResourceGroupName, 0, min(length(managedResourceGroupName), 90))

resource workspace 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', trimmedMRGName)
  }
}

output resourceId string = workspace.id
output name string = workspace.name
output url string = workspace.properties.workspaceUrl
