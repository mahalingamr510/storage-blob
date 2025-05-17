terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "45a63a52-75a2-4412-b571-d9acdddbd403"
    tenant_id       = "5fd920e9-ff97-40f0-a8de-09b2f2610e35"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "my-rg"
  location = "East US"
}

resource "random_id" "random_id" {
  byte_length = 4
}

resource "azurerm_storage_account" "storage" {
  name                     = "mystorageacct${random_id.random_id.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type = "LRS" 
}

resource "azurerm_storage_container" "container" {
  name                  = "myblobcontainer-1"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" 
}

resource "azurerm_storage_blob" "textblob" {
    name = "sample.txt"
    type = "Block"
    source = "${path.module}/sample.txt"
    storage_account_name = azurerm_storage_account.storage.name
    storage_container_name = azurerm_storage_container.container.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "container_name" {
  value = azurerm_storage_container.container.name
}
