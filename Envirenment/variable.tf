variable "rgs" {
  description = "A map of resource groups to create"
  type        = map(object({
    name     = string
    location = string
  }))
  
}

variable "storage_accounts" {}
variable "vnet_s" {}
variable "subnet_s" {}
variable "nic_2" {
  
}