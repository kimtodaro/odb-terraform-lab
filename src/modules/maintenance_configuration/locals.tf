locals {
  maintenance_configuration = flatten([
    for config_key, config in var.var_maintenance_configuration : {
        key = "${config_key}"
        location = config.location != null ? config.location : var.location
        name = config.name != null ? config.name : "${var.var_name_prefixes["maintenance_configuration"]}${config_key}${var.var_name_suffixes["maintenance_configuration"]}"
        resource_group_name = var.mod_resource_group[config.resource_group].name
        scope = config.scope
        visibility = config.visibility
        in_guest_user_patch_mode = config.in_guest_user_patch_mode
        properties = config.properties
        install_patches = config.install_patches
        window = config.window != null ? {
          start_date_time = config.window.start_date_time
          duration = config.window.duration
          time_zone = config.window.time_zone != null ? config.window.time_zone : var.var_timezone
          recur_every = config.window.recur_every
          expiration_date_time = config.window.expiration_date_time
        } : null
        tags = merge(var.var_default_tags, config.tags)
    }
  ])
}
