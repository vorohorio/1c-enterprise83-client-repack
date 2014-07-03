#!/bin/bash

cat libs.txt | while read line
do
  echo -ne "$line "
done
