#!/bin/bash

REFSDIR="/Users/kennedy/Desktop/dsk/papers/refs/" 
echo "" > all.tmp
while read p; do
  echo "$p"
  cat $REFSDIR$p >> all.tmp
  echo "" >> all.tmp
done <refs.txt
mv all.tmp all.bib
