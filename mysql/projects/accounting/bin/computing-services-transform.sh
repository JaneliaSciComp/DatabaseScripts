#!/bin/sh
awk '
  BEGIN {
  FS=","
  OFS=","
  }
/,/ {
  print $1,$3,$4,$5,$6,$7 }' $1
