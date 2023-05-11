param location string
param commonName string
param shortLocation string

resource apiconSb 'Microsoft.Web/connections@2016-06-01' = {
  name: 'apicon-${commonName}-${shortLocation}'
  location: location
  kind: 'V2'
  properties: {
    displayName: 'apicon-sb'
    api: {
      name: 'servicebus'
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/servicebus'
      type: 'Microsoft.Web/locations/managedApis'
    }
    parameterValueSet: {
      name: 'managedIdentityAuth'
      values: {
        namespaceEndpoint: {
          value: 'sb://sb-${commonName}-${shortLocation}.servicebus.windows.net/'
        }
      }
    }
  }
}

output connectionRuntimeUrl string = reference(apiconSb.id, apiconSb.apiVersion, 'full').properties.connectionRuntimeUrl
