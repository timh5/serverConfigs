#!/bin/bash
egrep '^\$status ?= ?"open"' ~vyew/httpdocs/webutils/systemalertv4.php && "BANNER: YES" || echo "BANNER: NO"
egrep '^\$ttl ?=' ~vyew/httpdocs/webutils/systemalertv4.php | head -n1


