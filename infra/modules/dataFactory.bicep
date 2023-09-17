param location string = resourceGroup().location

param name string = '${uniqueString(resourceGroup().id)}adf'

param tags object = {}

module adf 'services/data-factory.bicep' = {
  name: '${deployment().name}-svc-adf'
  params: {
    location: location
    name: name
    tags: tags
  }
}

output name string = adf.outputs.name
