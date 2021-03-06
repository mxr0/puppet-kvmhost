#!/bin/bash

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

# replace resolvconf, with a file.
apt-get purge --force-yes -f resolvconf
rm -f /etc/resolv.conf
wget -P/etc http://192.168.122.1/cblr/ks_mirror/config/resolv.conf

apt-get update
apt-get install -yy -f linux-generic-lts-saucy-eol-upgrade

# remove old kernel:
dpkg -l | awk '/raring/{print $2}' | xargs apt-get purge -y

while ! /opt/bw/bin/puppet agent -t --waitforcert 30 --debug ; do
	# run puppet as often as necessary before the host is setup
	sleep 1
done
# When we're done, we can reboot, and everything's perfect.
reboot
