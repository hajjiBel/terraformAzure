module "rg" {
  source   = "../modules/rg"
  name     = "my-training-rgrsi"
  location = "francecentral"
}

module "network" {
  source              = "../modules/network"
  resource_group_name = module.rg.name
  location            = module.rg.location

  vnet_name       = "my-training-vnet"
  address_space   = ["10.0.0.0/16"]

  subnet_name     = "my-training-subnet"
  subnet_prefixes = ["10.0.2.0/24"]

  public_ip_name = "my-training-public-ip"
  nic_name       = "my-training-nic"
}

module "security" {
  source              = "../modules/nsg"
  name                = "my-training-nsg"
  location            = module.rg.location
  resource_group_name = module.rg.name
  nic_id              = module.network.nic_id

  http_port = 80
  ssh_port  = 22
}

module "vm" {
  source              = "../modules/vm"
  resource_group_name = module.rg.name
  location            = module.rg.location
  nic_id              = module.network.nic_id

  vm_name        = "my-training-vm"
  vm_size        = "Standard_B1ms"
  computer_name  = "myvm"
  admin_username = "azureuser"
  admin_password = "Password1234!"
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = module.rg.name
  location            = module.rg.location

  account_name   = "storagersi"
  container_name = "containerrsi"
}
