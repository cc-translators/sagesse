#!/bin/bash

HTML="$1"
CSS="$(basename $HTML .html).css"

# Replace long lines with <hr />
sed -i 's@___\+@<hr />@' $HTML


# Force page breaks in intro

## Before each day
echo ".pagebreak {page-break-before: always}" >> $CSS
sed -i 's@\(id="x1-[0-9]\+r[0-9]\+"\)>@\1 class="pagebreak">@' $HTML


# Fix small caps
for class in "fxlrc-t1-" "fxlrc-t1-x-x-120"; do
   while read c r; do
      sed -i "s@\"$class\">$c\([^<]*\)<@\"small-caps\">$r\1<@" $HTML
   done <<<"é É
è È
à À"
done


