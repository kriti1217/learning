rgs = { 
        rg1 = {
            name     = "rg1"
            location = "East US"
        }
        
    }

storage_accounts = {
        stg1 = {
            name                     = "stg1"
            resource_group_name      = "rg1"
            location                 = "East US"
            account_tier             = "Standard"
            account_replication_type = "LRS"
        }
}

vnet_s = {
        vnet1 = {
            name                = "vnet1"
            resource_group_name = "rg1"
            location            = "East US"
            address_space       = ["10.0.0.0/16"]
        }
}

subnet_s = {
        subnet1 = {
            name                 = "frontend"
            resource_group_name  = "rg1"
            virtual_network_name = "vnet1"
            address_prefixes     = ["10.0.1.0/24"]
        }

        subnet2 = {
            name                 = "backend"
            resource_group_name  = "rg1"
            virtual_network_name = "vnet1"
            address_prefixes     = ["10.0.2.0/24"]
        }

        subnet3 = {
            name                 = "appgw"
            resource_group_name  = "rg1"
            virtual_network_name = "vnet1"
            address_prefixes     = ["10.0.3.0/24"]
        }

        subnet4 = {
            name                 = "azureBastion"
            resource_group_name  = "rg1"
            virtual_network_name = "vnet1"
            address_prefixes     = ["10.0.4.0/24"]
        }
}

nic_2 = {
        nic1 = {
            name                = "nic1"
            location            = "East US"
            resource_group_name = "rg1"
            ip_configuration = {
                name                          = "ipconfig1"
                subnet_name                   = "frontend"
                virtual_network_name          = "vnet1"
                private_ip_address_allocation = "Dynamic"
                public_ip_name                = "publicip1"
            }
        }

        nic2 = {
            name                = "nic2"
            location            = "East US"
            resource_group_name = "rg1"
            ip_configuration = {
                name                          = "ipconfig2"
                subnet_name                   = "backend"
                virtual_network_name          = "vnet1"
                private_ip_address_allocation = "Dynamic"
                public_ip_name                = "publicip2"
            }
        }
}