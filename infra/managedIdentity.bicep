param location string
param commonName string
param shortLocation string

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'mi-${commonName}-${shortLocation}'
  location: location
}

output name string = mi.name
