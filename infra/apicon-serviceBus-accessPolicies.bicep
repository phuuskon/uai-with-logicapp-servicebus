param location string
param commonName string
param shortLocation string
param identityPrincipalId string

resource servicebusConnectorAccessPolicy 'Microsoft.Web/connections/accessPolicies@2016-06-01' = {
  name: 'apicon-${commonName}-${shortLocation}/mi-${commonName}-${shortLocation}-${identityPrincipalId}'
  location: location
  properties: {
    principal: {
      type: 'ActiveDirectory'
      identity: {
        tenantId: subscription().tenantId
        objectId: identityPrincipalId
      }
    }
  }
}
