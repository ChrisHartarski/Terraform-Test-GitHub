terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "58ff46fa-63e4-4d9e-9a55-78b409cc2517"
}

resource "azurerm_resource_group" "taskboard_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_mssql_server" "taskboard_db_server" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.taskboard_rg.name
  location                     = azurerm_resource_group.taskboard_rg.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_pass
}

resource "azurerm_mssql_firewall_rule" "taskboard_db_server_firewall_rule" {
  name             = var.mssql_firewall_rule_name
  server_id        = azurerm_mssql_server.taskboard_db_server.id
  start_ip_address = var.mssql_start_ip
  end_ip_address   = var.mssql_end_ip
}

resource "azurerm_mssql_database" "taskboard_db" {
  name         = var.mssql_db_name
  server_id    = azurerm_mssql_server.taskboard_db_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  max_size_gb  = 2
  sku_name     = "Basic"
}

resource "azurerm_service_plan" "taskboard_sp" {
  name                = var.azure_service_plan_name
  resource_group_name = azurerm_resource_group.taskboard_rg.name
  location            = azurerm_resource_group.taskboard_rg.location
  os_type             = "Linux"
  sku_name            = "F1"
  depends_on          = [azurerm_mssql_database.taskboard_db]
}

resource "azurerm_linux_web_app" "taskboard_app" {
  name                = var.azure_web_app_name
  resource_group_name = azurerm_resource_group.taskboard_rg.name
  location            = azurerm_service_plan.taskboard_sp.location
  service_plan_id     = azurerm_service_plan.taskboard_sp.id
  depends_on          = [azurerm_service_plan.taskboard_sp]

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.taskboard_db_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.taskboard_db.name};User ID=${var.administrator_login};Password=${var.administrator_pass};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "taskboard_source_control" {
  app_id   = azurerm_linux_web_app.taskboard_app.id
  repo_url = var.source_control_repo
  branch   = var.source_control_repo_branch
}