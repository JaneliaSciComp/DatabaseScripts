#!/bin/sh
awk '
  BEGIN {
  FS=","
  OFS=","
  }
/,/ {
  print $1,$2,$4,$3,$6,$7 }' $1
