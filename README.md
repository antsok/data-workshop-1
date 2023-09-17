# data-worshop-1

## Data Management Landing Zone

`az stack sub create --name data-platform --delete-all --template-file infra/data-platform.bicep --location westeurope --description "Data Platform core" --deny-settings-mode None`

## Data Product Landing Zone
`az stack sub create --name data-workspace --delete-all --template-file infra/data-workspace.bicep --location westeurope --description "Data Application Workspace" --deny-settings-mode None`