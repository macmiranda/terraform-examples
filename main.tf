data "vsphere_datacenter" "dc" {
  name = "EU"
}

data "vsphere_datastore" "datastore" {
  name          = "rainbow.datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Snk"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM intern"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_from_ovf" {
#   name          = "template_from_ovf"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  memory   = 8192
#   guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
#   scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  ovf_deploy {
    // Url to remote ovf/ova file
    remote_ovf_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/32.20200923.3.0/x86_64/fedora-coreos-32.20200923.3.0-vmware.x86_64.ova"
    ovf_network_map = {
      "VM Network" = data.vsphere_network.network.id
    }
  }

#   network_interface {
#     network_id   = "${data.vsphere_network.network.id}"
#     adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
#   }

#   disk {
#     name             = "disk0"
#     size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
#     eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
#     thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
#   }

#   clone {
#     template_uuid = "${data.vsphere_virtual_machine.template_from_ovf.id}"
#   }

  vapp {
    properties = {
      "guestinfo.ignition.config.data.encoding" = "base64"
      "guestinfo.ignition.config.data" = "data"
    }
  }
}