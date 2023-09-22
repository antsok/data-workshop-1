// This biep module creates Synapse Analytics workspace

param location string = resourceGroup().location

@description('''The name of the Synapse Analytics workspace. Must be unique across Azure.
Character limit: 1-50
Valid characters: Lowercase letters, hyphens, and numbers. Start and end with letter or number.
Can't contain -ondemand
''')
@minLength(1)
@maxLength(50)
param name string = '${uniqueString(resourceGroup().id)}syn'

@description('The name of datalake storage account to be used by Synapse.')
param datalakeStorageAccountName string

@description('The name of the filesystem (blob container) on a datalake to be used by Synapse.')
param datalakeFilesystem string

param tags object = {}

@description('Allow all IPs to access the workspace. Default is true.')
param allowAllIps bool = true

var managedResourceGroupName = '${resourceGroup().name}-${name}-${uniqueString(name, resourceGroup().id)}'
var trimmedMRGName = substring(managedResourceGroupName, 0, min(length(managedResourceGroupName), 90))


resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azureADOnlyAuthentication: true
    defaultDataLakeStorage: {
      accountUrl: 'https://${datalakeStorageAccountName}.dfs.${environment().suffixes.storage}' 
      filesystem: datalakeFilesystem
    }
    publicNetworkAccess: 'Enabled'
    trustedServiceBypassEnabled: true
    managedResourceGroupName: trimmedMRGName
  }
}

resource firewallRule 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = if(allowAllIps) {
  parent: workspace
  name: 'AllowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}    

output resourceId string = workspace.id
output workspaceName string = workspace.name
