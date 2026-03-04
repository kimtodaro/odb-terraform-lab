variable "maintenance_configuration" {
    type = map(object({
        name = optional(string)
        location = optional(string)
        resource_group = string
        scope = optional(string, "InGuestPatch") // InGuestPatch, OSImage, Extension, SQLDB, SQLManagedInstance
        visibility = optional(string, "Custom")
        in_guest_user_patch_mode = optional(string, "User") // User or Platform (required when scope is InGuestPatch)
        properties = optional(object({
            reboot_setting = optional(string, "IfRequired") // IfRequired, Never, Always
            windows_classifications_to_include = optional(list(string), ["Critical", "Security", "UpdateRollup"])
            linux_classifications_to_include = optional(list(string), ["Critical", "Security"])
            windows_kb_numbers_to_exclude = optional(list(string), [])
            windows_kb_numbers_to_include = optional(list(string), [])
            linux_package_names_mask_to_exclude = optional(list(string), [])
            linux_package_names_mask_to_include = optional(list(string), [])
        }), {})
        install_patches = optional(object({
            reboot = optional(string, "IfRequired") // IfRequired, Never, Always
            windows = optional(object({
                classifications_to_include = optional(list(string), ["Critical", "Security", "UpdateRollup"])
                kb_numbers_to_exclude = optional(list(string), [])
                kb_numbers_to_include = optional(list(string), [])
            }))
            linux = optional(object({
                classifications_to_include = optional(list(string), ["Critical", "Security"])
                package_names_mask_to_exclude = optional(list(string), [])
                package_names_mask_to_include = optional(list(string), [])
            }))
        }))
        window = optional(object({
            start_date_time = string // ISO 8601 format e.g., "2024-01-22 02:00"
            duration = optional(string, "02:00") // ISO 8601 duration format e.g., "02:00"
            time_zone = optional(string) // Defaults to global timezone if not specified
            recur_every = optional(string, "1Week") // e.g., "1Day", "1Week", "1Month Second Tuesday", "Month First Monday"
            expiration_date_time = optional(string) // ISO 8601 format
        }))
        tags = optional(map(string), {})
    }))
    default = {}
}

variable "dynamic_scope_assignments" {
    type = map(object({
        name = optional(string)
        maintenance_configuration = string
        resource_types = optional(list(string)) // Defaults to ["microsoft.compute/virtualmachines"]
        resource_groups = optional(list(string)) // List of resource group names to filter
        locations = optional(list(string)) // Defaults to global location
        tag_filter = optional(string, "All") // Filter operator: "All" (AND) or "Any" (OR)
        tag_filters = optional(list(object({
            tag = string
            values = list(string)
        })))
    }))
    default = {}
}
