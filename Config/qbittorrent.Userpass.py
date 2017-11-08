#!/usr/bin/env python
#
# qBittorrent password generator
#
#   qbittorrent.password.py <password> 
#
#

import hashlib
import sys

password = sys.argv[1]

s = hashlib.md5()
s.update(password)

print s.hexdigest()
