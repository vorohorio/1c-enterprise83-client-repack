#!/bin/bash
# ./create-libs-list.sh| sort| uniq >libs.txt

cat all-libs.txt | while read line
do
  fname=${line##*/}
  ext=${fname##*.}
  name=${fname%.*}
  echo $name
done
