param location string
param commonName string
param shortLocation string

resource sb 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: 'sb-${commonName}-${shortLocation}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource topic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
  parent: sb
  name: 'test-topics'
}

resource sub 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-11-01' = {
  parent: topic
  name: 'test-sub'
}

output id string = sb.id
