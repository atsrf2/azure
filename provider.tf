terraform {
  required_providers {
    azurerm ={
        source = "hasicorp/azurerm"
        version = "3.51.0"
    }
  }
}

provider "azurerm" {

    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    features {
        
    }
    
}
  