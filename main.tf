provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "group" {
  name     = "group-resources"
  location = "West Europe"
}

resource "azurerm_availability_set" "group" {
  name                = "group"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
}


resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_public_ip" "ipaddress1" {
  name                = "onePublicIp"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "ipaddress2" {
  name                = "onePublicI2"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "interfaceone1" {
  name                = "interfaceOne1"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ipaddress1.id
  }
}

resource "azurerm_network_interface" "interfaceone2" {
  name                = "interfaceOne2"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ipaddress2.id
  }
}


resource "azurerm_linux_virtual_machine" "linux1" {
  name                = "Linux1-machine"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  size                = "Standard_F2"
  admin_username      = "azureUser"
  admin_ssh_key {
   username = "azureUser"
   public_key = file("id_rsa.pub")
}
  availability_set_id = azurerm_availability_set.group.id
  network_interface_ids = [
    azurerm_network_interface.interfaceone1.id
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


resource "azurerm_linux_virtual_machine" "linux2" {
  name                = "Linux2-machine"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  size                = "Standard_F2"
  admin_username      = "azureUser"
  admin_ssh_key {
   username = "azureUser"
   public_key = file("id_rsa.pub")
}
  availability_set_id = azurerm_availability_set.group.id
  network_interface_ids = [
    azurerm_network_interface.interfaceone2.id
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
