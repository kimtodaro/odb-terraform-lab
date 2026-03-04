variable "var_maintenance_configuration" {
    type = any
}

variable "mod_resource_group" {
    type = map
}

variable "var_name_prefixes" {
    type = map
}

variable "var_name_suffixes" {
    type = map
}

variable "location" {
    type = string
}

variable "var_timezone" {
    type = string
}

variable "var_default_tags" {
    type = map
    description = "Default tags"
}
