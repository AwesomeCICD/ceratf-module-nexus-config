terraform {
  required_version = ">= 1.0"
  required_providers {
    nexus = {
      source  = "datadrivers/nexus"
      version = ">=1.21.2"
    }
  }
}