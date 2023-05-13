#! /bin/bash

rgname=$1
location=$2
shortLocation=$3

echo "Create resource group"
groupOutput=$(az group create --name $rgname --location $location)
echo "Resource group $rgname created"

echo "Deploy infra"
infraOutput=$(az deployment group create --resource-group $rgname --template-file ./infra/main.bicep --parameters location=$location shortLocation=$shortLocation)
echo "Infra deployed"

miPrincipalId=$(echo $infraOutput | jq -j '.properties.outputs.miPrincipalId.value')
sbId=$(echo $infraOutput | jq -j '.properties.outputs.sbId.value')

echo "Give access to service bus"
az role assignment create --assignee $miPrincipalId --role "Azure Service Bus Data Owner" --scope $sbId

echo "Deploy workflows"
#todo

echo "Workflows deployed"
echo "All done!"


