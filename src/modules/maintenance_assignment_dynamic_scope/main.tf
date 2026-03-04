resource "azurerm_maintenance_assignment_dynamic_scope" "maintenance_assignment_dynamic_scope" {
  for_each = {
    for assignment in local.maintenance_assignments : "${assignment.key}" => assignment
  }
  name = each.value.name
  maintenance_configuration_id = var.mod_maintenance_configuration[each.value.maintenance_configuration_key].id

  filter {
    resource_types = each.value.filter.resource_types
    resource_groups = each.value.filter.resource_groups
    locations = each.value.filter.locations
    tag_filter = each.value.filter.tag_filter
    
    dynamic "tags" {
      for_each = each.value.filter.tags != null ? each.value.filter.tags : []
      content {
        tag = tags.value.tag
        values = tags.value.values
      }
    }
  }
}
