variable "ARM_CLIENT_ID" {
  type        = string
  description = "Check in .env"
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Check in .env"
}


variable "ARM_TENANT_ID" {
  type        = string
  description = "Check in .env"
}


variable "SECRET_VALUE" {
  type        = string
  description = "Check in .env"
}


variable "GLOBAL_LOCATION" {
    type = string
    default = "North Europe" 
}



variable "GLOBAL_VNET_CIDR" {
  type = string
  default = "10.0.0.0/16"
}


variable "GLOBAL_DNS_SERVERS" {
    type = map(string)
    default = {
      "a" = "1.1.1.1",
      "b" = "8.8.8.8",
      "c" = "8.8.4.4"
    }
}


variable "GLOBAL_VNET_SUBNETS" {
    type = map
    default = {
        a = "10.0.1.0/24",
        b = "10.0.2.0/24",
        c = "10.0.3.0/24",
        x = "10.0.11.0/24",
        y = "10.0.12.0/24",
        z = "10.0.13.0/24",
    }
  
}


variable "GLOBAL_RESOURCENAME_PREFIX" {
  type = string
  default = "en1tstkk99_"
}


variable "vm1_host_user" {
  type = string
  default = "krasi"
}

variable "vm1_host_password" {
  type = string
  default = "Krasi123"
}