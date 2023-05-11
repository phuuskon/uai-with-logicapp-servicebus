param location string = 'westeurope'
param shortLocation string = 'we'
param commonName string = 'phlatest'

// module mi 'managedIdentity.bicep' = {
//   name: 'managedIdentity'
//   params: {
//     location: location
//     shortLocation: shortLocation
//     commonName: commonName
//   }
// }

module sb 'serviceBus.bicep' = {
  name: 'serviceBus'
  params: {
    commonName: commonName
    location: location
    shortLocation: shortLocation
  }
}

module apicon 'apicon-serviceBus.bicep' = {
  name: 'apiconSb'
  params: {
    commonName: commonName
    location: location
    shortLocation: shortLocation
  }
}

module la 'logicApp.bicep' = {
  name: 'logicApp'
  params: {
    commonName: commonName
    location: location
    shortLocation: shortLocation
    connectionRuntimeUrl: apicon.outputs.connectionRuntimeUrl
  }
}

module apiconAccessPolicy 'apicon-serviceBus-accessPolicies.bicep' = {
  name: 'apiconSbAccessPolicy'
  params: {
    commonName: commonName
    identityPrincipalId: la.outputs.principalId
    location: location
    shortLocation: shortLocation
  }
}
