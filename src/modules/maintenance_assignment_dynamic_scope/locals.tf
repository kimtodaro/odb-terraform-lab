locals {
  maintenance_assignments = flatten([
    for assignment_key, assignment in var.var_dynamic_scope_assignments : {
      key = assignment_key
      name = assignment.name != null ? assignment.name : "${var.var_name_prefixes["maintenance_assignment"]}${assignment_key}${var.var_name_suffixes["maintenance_assignment"]}"
      maintenance_configuration_key = assignment.maintenance_configuration
      filter = {
        resource_types = assignment.resource_types != null ? assignment.resource_types : ["microsoft.compute/virtualmachines"]
        resource_groups = assignment.resource_groups
        locations = assignment.locations != null ? assignment.locations : [var.location]
        tag_filter = assignment.tag_filter
        tags = assignment.tag_filters != null ? [
          # Sort tag_filters by tag name to ensure consistent ordering
          for tag_name in sort([for tf in assignment.tag_filters : tf.tag]) : {
            tag = tag_name
            values = [for tf in assignment.tag_filters : tf.values if tf.tag == tag_name][0]
          }
        ] : null
      }
    }
  ])
}
