variable "rg_name" {
  
type = map(object({
  name = string
  location= string
}))
}


variable "vnets" {
  type = map(object({
    name = string
    address_space = list(string)
    resource_group_name = string
    location = string
  }))   
  
}

variable "subnets" {
  type = map(object({
    name = string
    a_p = list(string)
    v_n = string
    rg_n = string
  }))   
  
}

variable "nic" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    subnet_name = string
  }))   
  
}
variable "VM" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    subnet_name = string
    vn_name = string
    vm_size = string
    nic_name = string
    admin_username = string
    admin_password = string
  }))   
  
}

