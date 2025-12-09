resource "azurerm_resource_group" "tftraining-gp" {
  name     = "my-training-rg"
  location = "France Central"
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

# Create a Public IP
resource "azurerm_public_ip" "tftraining-ip" {
  name                = "my-training-public-ip"
  location            = azurerm_resource_group.tftraining-gp.location
  resource_group_name = azurerm_resource_group.tftraining-gp.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "my-training-env"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "tftraining-nsg" {
  name                = "my-training-nsg"
  location            = azurerm_resource_group.tftraining-gp.location
  resource_group_name = azurerm_resource_group.tftraining-gp.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.web_server_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.ssh_server_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
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
    public_ip_address_id          = azurerm_public_ip.tftraining-ip.id
  }

  tags = {
    environment = "my-training-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "tftraining-assoc" {
  network_interface_id      = azurerm_network_interface.tftraining-vnic.id
  network_security_group_id = azurerm_network_security_group.tftraining-nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "tftraining-vm" {
  name                            = "my-training-vm"
  location                        = azurerm_resource_group.tftraining-gp.location
  resource_group_name             = azurerm_resource_group.tftraining-gp.name
  network_interface_ids           = [azurerm_network_interface.tftraining-vnic.id]
  size                            = var.instance_template
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    ...
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

resource "azurerm_storage_account" "training-sa" {
  name                     = "storageaccounthajji3"
  resource_group_name      = azurerm_resource_group.tftraining-gp.name
  location                 = azurerm_resource_group.tftraining-gp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "training-container" {
  name                  = "training-container"
  storage_account_name  = azurerm_storage_account.training-sa.name
  container_access_type = "private"
}

