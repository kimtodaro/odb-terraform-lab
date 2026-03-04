locals {
  associations = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for nic_key, nic in vm.nics : {
            count = vm.count
            key = "${vm_index}.${nic_key}"
            network_interface_id = var.mod_nic["${vm_index}.${nic_key}"].id
            network_security_group_id = var.mod_network_security_group[nic.network_security_group].id
          } if nic.network_security_group != null
        ]
      ]
    ]
  ])
}