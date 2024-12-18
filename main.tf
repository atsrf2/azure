// resourse name = SQL & Database

resource "azurerm_resource_group" "sqlrg" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "sqlrg" {
  name                         = "demo-mssqlserver-1"
  resource_group_name          = azurerm_resource_group.sqlrg.name
  location                     = azurerm_resource_group.sqlrg.location
  version                      = "12.0"
  administrator_login          = "azuresqladmin"
  administrator_login_password = azurerm_key_vault_secret.kvsecret.value
  minimum_tls_version          = "1.2"

  depends_on = [ azurerm_resource_group.sqlrg]

}

resource "azurerm_mssql_database" "sqldb" {
  name         = "demo-db"
  server_id    = azurerm_mssql_server.sqlrg.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  depends_on = [ azurerm_mssql_server.sqlserver, azurerm_resource_group.rg]

}

//key voult file 

resource "azurerm_resource_group" "kv" {
  name     = "kv-resources"
  location = "West Europe"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "demokv"
  location                    = azurerm_resource_group.sqlrg.location
  resource_group_name         = azurerm_resource_group.sqlrg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
 
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

  
    secret_permissions = [
      "Get", "list" , "set"
    ]

  }
}
resource "azurerm_key_vault_secret" "kvsecret" {
  name         = "sql-password"
  value        = "Akt@2025##"
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [ azurerm_key_vault.kv ]
}