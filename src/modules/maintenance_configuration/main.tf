resource "azurerm_maintenance_configuration" "maintenance_configuration" {
  for_each = {
    for config in local.maintenance_configuration : "${config.key}" => config
  }
  name = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  scope = each.value.scope
  visibility = each.value.visibility
  in_guest_user_patch_mode = each.value.in_guest_user_patch_mode

  dynamic "window" {
    for_each = each.value.window != null ? [each.value.window] : []
    content {
      start_date_time = window.value.start_date_time
      duration = window.value.duration
      time_zone = window.value.time_zone
      recur_every = window.value.recur_every
      expiration_date_time = window.value.expiration_date_time
    }
  }

  dynamic "install_patches" {
    for_each = each.value.install_patches != null ? [each.value.install_patches] : []
    content {
      reboot = install_patches.value.reboot
      
      dynamic "windows" {
        for_each = install_patches.value.windows != null ? [install_patches.value.windows] : []
        content {
          classifications_to_include = windows.value.classifications_to_include
          kb_numbers_to_exclude = windows.value.kb_numbers_to_exclude
          kb_numbers_to_include = windows.value.kb_numbers_to_include
        }
      }

      dynamic "linux" {
        for_each = install_patches.value.linux != null ? [install_patches.value.linux] : []
        content {
          classifications_to_include = linux.value.classifications_to_include
          package_names_mask_to_exclude = linux.value.package_names_mask_to_exclude
          package_names_mask_to_include = linux.value.package_names_mask_to_include
        }
      }
    }
  }

  tags = each.value.tags
}
