module "maintenance_configuration" {
  source = "./modules/maintenance_configuration"
  var_maintenance_configuration = var.maintenance_configuration
  mod_resource_group = module.resource_group.resource_group
  location = var.location
  var_timezone = var.timezone
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

module "maintenance_assignment_dynamic_scope" {
  source = "./modules/maintenance_assignment_dynamic_scope"
  var_dynamic_scope_assignments = var.dynamic_scope_assignments
  mod_maintenance_configuration = module.maintenance_configuration.maintenance_configuration
  location = var.location
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
}
