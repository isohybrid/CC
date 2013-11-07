#!/usr/bin/env bash
DIR=/home/suma/Pictures/

now=`date +%s`
bef=`date +%s -d "2013-11-01"`
aft=`date +%s -d "-60 day"`
one=`expr $now-$bef|bc`
two=`expr $now-$aft|bc`
end=`expr $now-$two-$one|bc`

for file in `ls $DIR|grep messages`
do
  cur=`echo $file | sed 's/messages\_//g' | sed -e 's/\..*//g' | sed 's/\_/\-/g'`
  rel=`date +%s -d "$cur"`
  echo $rel
  if [ $rel -lt $end ]
    then
      rm $DIR$file
  fi
done
