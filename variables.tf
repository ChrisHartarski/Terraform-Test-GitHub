variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "Azure resource group location"
}

variable "mssql_server_name" {
  type        = string
  description = "Azure SQL server name"
}

variable "administrator_login" {
  type        = string
  description = "Azure SQL administrator login"
}

variable "administrator_pass" {
  type        = string
  description = "Azure SQL administrator password"
}

variable "mssql_firewall_rule_name" {
  type        = string
  description = "Azure SQL firewall rule name"
}

variable "mssql_start_ip" {
  type        = string
  description = "Azure SQL firewall start IP address"
}

variable "mssql_end_ip" {
  type        = string
  description = "Azure SQL firewall end IP address"
}

variable "mssql_db_name" {
  type        = string
  description = "Azure DB name"
}

variable "azure_service_plan_name" {
  type        = string
  description = "Azure Service Plan name"
}

variable "azure_web_app_name" {
  type        = string
  description = "Azure Linux Web App name"
}

variable "source_control_repo" {
  type        = string
  description = "GitHub repository"
}

variable "source_control_repo_branch" {
  type        = string
  description = "GitHub repository branch"
}