resource "azurerm_resource_group" "tftraining-gp" {
  name     = "my-training-rg"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "tftraining-vnet" {
  name                = "my-training-vnet"
  location            = azurerm_resource_group.tftraining-gp.location
  resource_group_name = azurerm_resource_group.tftraining-gp.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "my-training-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "tftraining-subnet" {
  name                 = "my-training-subnet"
  resource_group_name  = azurerm_resource_group.tftraining-gp.name
  virtual_network_name = azurerm_virtual_network.tftraining-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create a Network Security Group and rule
resource "azurerm_network_security_group" "tftraining-nsg" {
  name                = "my-training-nsg"
  location            = azurerm_resource_group.tftraining.location
  resource_group_name = azurerm_resource_group.tftraining-gp.name

  tags = {
    environment = "my-training-env"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "tftraining-vnic" {
  name                = "my-training-nic"
  location            = azurerm_resource_group.tftraining-gp.location
  resource_group_name = azurerm_resource_group.tftraining-gp.name

  ip_configuration {
    name                          = "my-training-nic-ip"
    subnet_id                     = azurerm_subnet.tftraining-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tftraining.id
  }

  tags = {
    environment = "my-training-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "tftraining-assoc" {
  network_interface_id      = azurerm_network_interface.tftraining-vnic.id
  network_security_group_id = azurerm_network_security_group.tftraining-sg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "tftraining-vm" {
  name                            = "my-training-vm"
  location                        = azurerm_resource_group.tftraining-gp.location
  resource_group_name             = azurerm_resource_group.tftraining-gp.name
  network_interface_ids           = [azurerm_network_interface.tftraining-vnic.id]
  size                            = ""
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"  #Le sku (Stock Keeping Unit) désigne la variante spécifique de l'image
    version   = "latest"
  }

  
  os_disk {
    name                 = "my-training-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
	
  tags = {
    environment = "my-training-env"
  }
}

