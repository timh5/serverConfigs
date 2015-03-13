#!/bin/bash
grep "^header.*Location.*maint" ~vyew/httpdocs/maint.php  &&  echo "MAINT: YES" || echo "MAINT: NO"
