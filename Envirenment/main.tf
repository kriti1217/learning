module "resources_group" {
    source = "../Child_module/RG"
    resource_groups = var.rgs
}


module "storage" {
    depends_on = [module.resources_group] # Ensure that the resource group module is created before the storage account module
    source = "../Child_module/storage" #
    stg = var.storage_accounts   # dependency on the resource group module
        
}

module "vnet123" {
    depends_on = [module.resources_group] # Ensure that the resource group module is created before the vnet module
    source = "../Child_module/vnet" #
    vnets = var.vnet_s # dependency on the resource group module
        
}

module "subnet" {
    depends_on = [module.vnet123] # Ensure that the vnet module is created before the subnet module
    source = "../Child_module/subnet" #
    subnets = var.subnet_s
  
}

module "nic" {
    depends_on = [module.subnet] # Ensure that the subnet module is created before the nic module
    source = "../Child_module/nic" #
    nic_1 = var.nic_2 # dependency on the subnet module
}








