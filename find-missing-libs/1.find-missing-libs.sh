#!/bin/bash
# lsof -n | grep 17061 | grep so$| grep /opt/1C/

newdir=/opt/1C/v8.3/8.3.5-1033

cat all-libs.txt | while read line
do
#  fname=`basename $line`
  #echo $file
#  if [ -f "$newdir/$file" ]; then
#    e=1
#  else
#    echo $file
#  fi
  fname=${line##*/}
  ext=${fname##*.}
  name=${fname%.*}
  #echo $name

  fname="$newdir/$name.$ext"
  #echo $fname
  if [ -f "$fname" ]; then
    e=1
  else
    echo $name
    mv "/opt/1C/v8.3/server/$name.$ext" "$newdir/"
    mv "/opt/1C/v8.3/server/${name}_root.res" "$newdir/"
    mv "/opt/1C/v8.3/server/${name}_ru.res" "$newdir/"
  fi

done
