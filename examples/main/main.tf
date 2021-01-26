variable azurerm_credential {
  type = object({})
}

terraform {
  backend "local" {
    path = "/root/terraform.tfstate"
  }
}

variable foo {
  type = string
}

locals {
  map_locations = {
    br   = "BrazilSouth"
    wus2 = "WestUS2"
  }

  resource_group_name = basename(path.cwd)
}

provider azurerm {
  subscription_id = var.azurerm_credential.subscription_id
  tenant_id       = var.azurerm_credential.tenant_id
  features {}
}

module foo {
  source = "../modules/foo"
  foo    = "foo"
}

module submodule {
  source    = "./submodule/"
  read_file = true
}

output foo {
  value = module.foo.return
}

output submodule {
  value = module.submodule.return
}

output example {
  value = path.cwd
}

output example2 {
  value = path.root
}
