#!/bin/sh

#cat wr.fb te.fb def.fb rb.fb qb.fb | awk -f fantfball.awk | sort -k12 -nr
#cat te.fb  | awk -f fantfball.awk | sort -k12 -nr
#cat def.fb  | awk -f fantfball.awk | sort -k12 -nr
cat wr.fb  | awk -f fantfball.awk | sort -k12 -nr

