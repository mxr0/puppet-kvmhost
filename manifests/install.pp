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

# == Class: kvmhost::install
#
# This class is the global hook for installation
#
# === Examples
#
#  include 'kvmhost::install'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2014 Brainsware
#
class kvmhost::install {

  contain 'kvmhost::install::libvirt':
  contain 'kvmhost::install::cobbler':

  Class['kvmhost::install::libvirt'] ->
  Class['kvmhost::install::cobbler']
}
