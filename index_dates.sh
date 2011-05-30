#!/bin/bash

NAME="$1"

if [ ! -f "$NAME.log" ]; then
   echo "E: Missing file $NAME.log"
fi

if [ ! -f "$NAME.ind" ]; then
   echo "E: Missing file $NAME.ind"
fi

while read -r page day month; do
   echo "$page:$day:$month"
   bsmonth=$(sed -e 's@\\@\\\\@g' <<<$month)
   sed -i "s@textrm{$page}@textrm{\\\\makedate{$day}~$bsmonth}@g" $NAME.ind
done < <(sed -n 's@Date on page \([0-9]\+\):\([0-9]\+\):\(.*\)@\1 \2 \3@p' $NAME.log)


