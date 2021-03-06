#  Copyright 2014 Brainsware
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# == Class: kvmhost::install::libvirt
#
# This class is the global hook for installuration of libvirt
# We put it in an extra class so as to not cluster the calling one.
#
# === Parameters
#
# Inherits from kvmhost, so, the same as kvmhost.
#
# === Examples
#
#  include 'kvmhost::install::libvirt'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2014 Brainsware
#
class kvmhost::install::libvirt inherits kvmhost {

  class { '::libvirt':
    virtinst           => true,
    radvd              => true,
    unix_sock_group    => 'libvirtd',
    unix_sock_rw_perms => '0770',
    auth_unix_ro       => 'none',
    auth_unix_rw       => 'none',
  }

  $dhcp = {
    start      => '192.168.122.2',
    end        => '192.168.122.254',
    bootp_file => 'pxelinux.0',
  }
  # "private" IPv6 networks are on ::10
  $private_ipv6 = {
    'address' => "${kvmhost::ipv6}::10:1",
    'prefix'  => '112',
  }
  $pxe_ip = {
    'address' => '192.168.122.1',
    'prefix'  => '24',
    'dhcp'    => $dhcp,
  }
  libvirt::network { 'pxe':
    ensure       => 'enabled',
    autostart    => true,
    forward_mode => 'nat',
    bridge       => 'virbr0',
    ip           => [ $pxe_ip ],
    ipv6         => [ $private_ipv6 ],
  }

  libvirt::network { 'host-bridge':
    ensure       => 'enabled',
    autostart    => true,
    forward_mode => 'bridge',
    bridge       => 'virbr1',
  }

  libvirt_pool { 'default':
    ensure => 'absent',
  }
  libvirt_pool { 'vm_storage':
    ensure     => 'present',
    type       => 'logical',
    sourcename => 'vg0',
    target     => '/dev/vg0'
  }
}
