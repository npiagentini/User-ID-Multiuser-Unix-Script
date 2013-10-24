
# Copyright (c) 2011 Palo Alto Networks, Inc. <info@paloaltonetworks.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


#!/bin/bash
export user="testuser"
jumpserver="10.1.1.1"
apikey="LUFRPT14MW5xOEo1R09KVlBZNnpnemh0VHRBOWl6TGM9bXcwM3JHUGVhRlNiY0dCR0srNERUQT09"
firewall1="1.1.1.1"

case $user in
"testuser") portrange="22025";;
"user2") portrange="22200";;
"user3") portrange="22500";;
esac

portend=`expr $portrange + 200`

echo \<uid-message\>\<payload\>\<login\> > add.xml

echo "<entry name=\"$user\" ip=\"$jumpip\" blockstart=\"$portrange\" />" >> add.xml

echo \</login\>\</payload\>\<type\>update\</type\>\<version\>1.0\</version\>\</uid-message\> >>add.xml
echo $user
echo $portend
iptables -t nat -A POSTROUTING -m owner --uid-owner $user -p tcp -j SNAT --to-source $jumpserver:$portrange-$portend


curl --insecure --form file=@add.xml "https://<firewallip>/api/?type=user-id&action=set&key=<key>"
