# Tenant, Subscription and credentials (if needed)
variable "tenant_id" {
  type = string
  default = ""
}
variable "subscription_id" {
  type = string
  default = ""
}

/*  Used if using an service principal to authenticate (e.g. within a pipeline)
variable "client_id" {
  type = string
}
variable "client_secret" {
  type      = string
  sensitive = true
}
*/

variable "location" {
  type        = string
  description = "The primary location for the workload to be placed."
  default = "uksouth"
}

variable "environment" {
  type = string
  description = "The environment type, should be d (dev), t (test), p (prod)"
  default = "d"
}

variable "app" {
  type = string
  description = "The name of the application"
  default = "cmtdata"
}

// Network Targets

variable "vnet_rg" {
  type = string
  description = "The resource group containing the vnet to target for private endpoints"
  default = "rg"
}

variable "vnet_name" {
  type = string
  description = "The name of the vnet within the subscription to target for private endpoints"
  default = "vnet-test"
}

variable "subnet_name" {
  type = string
  description = "The name of the subnet, within the vnet to target for private endpoints"
  default = "sn-plink"
}

// DF VSTS config

variable account_name {
  type = string
  description = "The organisation name used within the DF devops configuration"
  default = "ihccasestudy"
}

variable project_name {
  type = string
  description = "The ado project name to utilise within the DF devops configuration"
  default = "ihccasestudy"
}

variable repository_name {
  type = string
  description = "The git repository to utilise for this DF integration"
  default = "repo"
}

variable branch_name {
  type = string
  description = "The git branch name to utilise for this DF integration"
  default = "dev"
}

variable root_folder {
  type = string
  description = "The root folder to utilise for the DF source"
  default = "/datafactory"
}

