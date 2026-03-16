@description('The region where our virtual network will be deployed. Default is resource group location')
param location string = resourceGroup().location

@description('The names of resources')
param appServicePlanName string = 'appserviceplan-empmgmtapp-001'
param backendAppName string = 'app-emp-backend-001'
param frontendAppName string = 'app-emp-frontend-001'
//param sqlMiName string = 'sqlmi-emp-db-001'
param logAnalyticsWorkspaceName string = 'loganalytics-emp-001'
param appInsightsName string = 'appinsights-emp-001'
param vnetName string = 'vnet-emp-001'
// param sqlAdminLogin string
// @secure()
// param sqlAdminPassword string

var appServicePlanSku = { name: 'S1', tier: 'Standard', capacity:1 }
// var sqlMiSku = { name: 'GP_Gen5', tier: 'GeneralPurpose',family: 'Gen5', capacity: 4 }
var logAnalyticsSku = { name: 'PerGB2018' }

// Log Analytics Workspace and Application Insights (application-level telemetry)
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: { sku: logAnalyticsSku, retentionInDays: 30 }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: { Application_Type: 'web', WorkspaceResourceId: logAnalyticsWorkspace.id }
}

// Diagnostic Settings (Connects App Service Logs to Log Analytics)
resource backendAppLogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${backendAppName}-logs'
  scope: backendApp 
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      { category: 'AppServiceHTTPLogs', enabled: true }
      { category: 'AppServiceConsoleLogs', enabled: true }
      { category: 'AppServiceAppLogs', enabled: true }
    ]
    metrics: [
      { category: 'AllMetrics', enabled: true }
    ]
  }
}

// Diagnostic Settings (Connects Frontend App Service Logs to Log Analytics)
resource frontendAppLogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${frontendAppName}-logs'
  scope: frontendApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      { category: 'AppServiceHTTPLogs', enabled: true }
      { category: 'AppServiceConsoleLogs', enabled: true }
      { category: 'AppServiceAppLogs', enabled: true }
    ]
    metrics: [
      { category: 'AllMetrics', enabled: true }
    ]
  }
}

// Route Table
// resource sqlMiRouteTable 'Microsoft.Network/routeTables@2021-08-01' = {
//   name: '${sqlMiName}-rt'
//   location: location
//   properties: {
//     disableBgpRoutePropagation: false
//     routes: [
//       {
//         name: 'default-route'
//         properties: {
//           addressPrefix: '0.0.0.0/0'
//           nextHopType: 'Internet'
//         }
//       }
//     ]
//   }
// }

// Network security group
// resource sqlMiNsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
//   name: '${sqlMiName}-nsg'
//   location: location
//   properties: {
//     securityRules: [
//       {
//         name: 'allow_mi_inbound'
//         properties: {
//           priority: 1000
//           access: 'Allow'
//           direction: 'Inbound'
//           destinationPortRange: '1433'
//           protocol: 'Tcp'
//           sourcePortRange: '*'
//           sourceAddressPrefix: 'VirtualNetwork'
//           destinationAddressPrefix: '*'
//         }
//       }
//     ]
//   }
// }

// Virtual Networks - Subnets
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: 'vnet-emp-001'
}

resource sqlSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' existing = {
  parent: vnet
  name: 'SqlManagedInstanceSubnet'
}

resource backendSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: vnet
  name: 'AppServiceSubnet' 
  properties: { 
    addressPrefix: '10.0.1.0/24' 
    delegations: [{
          name: 'appservice-delegation'
          properties: { serviceName: 'Microsoft.Web/serverFarms' }
        }]
    } 
}

resource frontendSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: vnet
  name: 'FrontendServiceSubnet'
  properties: { 
    addressPrefix: '10.0.2.0/24' 
    delegations: [{
          name: 'frontend-delegation'
          properties: { serviceName: 'Microsoft.Web/serverFarms' }
        }]
    }
  dependsOn: [ backendSubnet ]
}

//resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
//  name: vnetName
//  location: location
//  properties: {
//    addressSpace: { addressPrefixes: [ '10.0.0.0/16' ] }
//  }
//}

//resource backendSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
//  parent: vnet
//  name: 'AppServiceSubnet' 
//  properties: { 
//    addressPrefix: '10.0.1.0/24' 
//    delegations: [{
//          name: 'appservice-delegation'
//          properties: { serviceName: 'Microsoft.Web/serverFarms' }
//        }]
//    } 
//}

//resource frontendSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
//  parent: vnet
//  name: 'FrontendServiceSubnet'
//  properties: { 
//    addressPrefix: '10.0.2.0/24' 
//    delegations: [{
//          name: 'frontend-delegation'
//          properties: { serviceName: 'Microsoft.Web/serverFarms' }
//        }]
//    }
//}

//resource sqlSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
//  parent: vnet
//  name: 'SqlManagedInstanceSubnet'
//  properties: {
//    addressPrefix: '10.0.3.0/26'
//    delegations: [
//      {
//        name: 'sqlmi-delegation'
//        properties: { serviceName: 'Microsoft.Sql/managedInstances' }
//      }
//    ]
//    // networkSecurityGroup: { id: sqlMiNsg.id }
//    // routeTable: { id: sqlMiRouteTable.id }
//    serviceEndpoints: [
//      {
//        service: 'Microsoft.Sql'
//      }
//    ]
//  }
//}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: appServicePlanSku
  properties: {}
}

// Backend App Service
resource backendApp 'Microsoft.Web/sites@2022-09-01' = {
  name: backendAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: backendSubnet.id
    vnetRouteAllEnabled: true
    siteConfig: {
      appSettings: [
        { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: appInsights.properties.ConnectionString }
        { name: 'ApplicationInsightsAgent_EXTENSION_VERSION', value: '~3' }
      ]
    }
  }
}

// Frontend App Service
resource frontendApp 'Microsoft.Web/sites@2022-09-01' = {
  name: frontendAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: frontendSubnet.id
    vnetRouteAllEnabled: true
    siteConfig: {
      appSettings: [
        { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: appInsights.properties.ConnectionString }
        { name: 'ApplicationInsightsAgent_EXTENSION_VERSION', value: '~3' }
      ]
    }
  }
}

// SQL Managed Instance
// resource sqlManagedInstance 'Microsoft.Sql/managedInstances@2022-05-01-preview' = {
//   name: sqlMiName
//   location: location
//   sku: {
//     name: sqlMiSku.name
//     tier: sqlMiSku.tier
//   }
//   properties: {
//     administratorLogin: sqlAdminLogin
//     administratorLoginPassword: sqlAdminPassword
//     subnetId: sqlSubnet.id
//     licenseType: 'BasePrice'
//     vCores: 4
//     zoneRedundant: false
//     storageSizeInGB: 32
//     proxyOverride: 'Redirect'
//     publicDataEndpointEnabled: false
//   }
// }

// Output
output backendAppUrl string = backendApp.properties.defaultHostName
output frontendAppUrl string = frontendApp.properties.defaultHostName
// output sqlMiHost string = sqlManagedInstance.properties.fullyQualifiedDomainName
