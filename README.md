# data-worshop-1

## Data Management Landing Zone

az stack sub create --name data-platform --delete-all --template-file infra/data-platform.bicep --location westeurope --description "Data Platform core" --deny-settings-mode None