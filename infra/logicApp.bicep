param location string
param commonName string
param shortLocation string
param connectionRuntimeUrl string

resource laStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'st${commonName}${shortLocation}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource laAppPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-${commonName}-${shortLocation}'
  location: location
  sku: {
    name: 'WS1'
    tier: 'WorkFlowStandard'
    size: 'WS1'
    family: 'WS'
    capacity: 1
  }
}

resource la 'Microsoft.Web/sites@2022-09-01' = {
  name: 'la-${commonName}-${shortLocation}'
  location: location
  kind: 'functionapp,workflowapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: laAppPlan.id
  }
}

resource laConfig 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: la
  name: 'appsettings'
  kind: 'string'
  properties: {
    APP_KIND: 'workflowApp'
    AzureFunctionsJobHost__extensionBundle__id: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
    AzureFunctionsJobHost__extensionBundle__version: '[1.*, 2.0.0)'
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${laStorage.name};AccountKey=${laStorage.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'node'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${laStorage.name};AccountKey=${laStorage.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    WEBSITE_CONTENTSHARE: laStorage.name
    WEBSITE_NODE_DEFAULT_VERSION: '~16'
    ServiceBusConnectionRuntimeUrl: connectionRuntimeUrl
    ResourceGroupName: resourceGroup().name
    SubscriptionId: subscription().subscriptionId
  }
}

output principalId string = la.identity.principalId
