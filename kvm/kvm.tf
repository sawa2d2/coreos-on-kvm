terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}




resource "libvirt_domain" "fcos" {
  count = 3
  #for_each = to_set(var.number)

  name   = "fcos_${count.index + 1}"
  memory = 8000 # [MiB]
  vcpu   = 2 

  disk {
    volume_id = libvirt_volume.fcos[count.index].id
  }

  # TODO:
  # Enable shared memory
  #
  #memorybacking {
  #  access   = "shared"
  #  allocation = 8192
  #}
}

resource "libvirt_volume" "fcos" {
  count  = 3  
  name   = "fcos_${count.index + 1}.qcow2"
  format = "qcow2"
  size   = 107374182400  # [byte] = 100[GiB] (100 * 1024^3)
}
