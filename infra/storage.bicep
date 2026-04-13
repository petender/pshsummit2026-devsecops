// DEMO FILE — infra/storage.bicep
// -------------------------------------------------------
// This file contains THREE deliberate misconfigurations
// for the IaC Scanning demo (letter I).
// Template Analyzer will flag all three as Code Scanning alerts.
//
// After showing the alerts in GitHub Security → Code scanning,
// fix the three properties below and push — alerts auto-close.
//
// Fix:
//   publicNetworkAccess: 'Disabled'
//   allowBlobPublicAccess: false
//   minimumTlsVersion: 'TLS1_2'
// -------------------------------------------------------

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'demostorage${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    publicNetworkAccess: 'Enabled'    // ← misconfiguration: should be 'Disabled'
    allowBlobPublicAccess: true       // ← misconfiguration: should be false
    minimumTlsVersion: 'TLS1_0'      // ← misconfiguration: should be 'TLS1_2'
  }
}
