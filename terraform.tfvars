rg_name = {
  rg01 = {
    name = "rg01"
    location = "East US"    
  }
 rg02 = {
    name = "rg02"
    location = "West US"    
  } 
}

vnets = {
  vnet01 = {
    name = "vnet01"
    address_space = ["10.0.0.0/16"]
    resource_group_name = "rg01"
    location = "East US"
  }

    vnet02 = {
        name = "vnet02"
        address_space = ["10.1.0.0/16"]
        resource_group_name = "rg01"
        location = "West US"
    }   
}

subnets = {
  subnet01 = {
    name = "frontend"
    a_p = ["10.0.1.0/24"]
    v_n = "vnet01"
    rg_n = "rg01"
  }

  subnet02 = {
    name = "backend"
    a_p = ["10.1.1.0/24"]
    v_n = "vnet02"
    rg_n = "rg01"
  }
  subnet03 = {
    name = "bastionhost"
    a_p = ["10.2.1.0/28"]
    v_n = "vnet01"
    rg_n = "rg01"
  }
}

nic = {
  nic01 = {
    name = "nic01"
    resource_group_name = "rg01"
    location = "East US"
    subnet_name = "subnet01"
    vn_name = "vnet01"
  }

  nic02 = {
    name = "nic02"
    resource_group_name = "rg01"
    location = "West US"
    subnet_name = "subnet02"
    vn_name = "vnet02"
    
  }
}

VM = {
  vm01 = {
    name = "vm01"
    resource_group_name = "rg01"
    location = "East US"
    subnet_name = "frontend"
    nic_name = "nic01"
    vn_name = "vnet01"  
    vm_size = "Standard_B1s"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234"
    }

    vm02 = {
      name = "vm02"
      resource_group_name = "rg01"
      location = "West US"
      subnet_name = "backend"
      nic_name = "nic02"
      vn_name = "vnet02"
      vm_size = "Standard_B1s"
      admin_username = "adminuser"
      admin_password = "P@ssw0rd1234"
    }
    
  }
