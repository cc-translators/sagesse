#!/bin/bash

HTML="$1"
CSS="$(basename $HTML .html).css"

# Replace long lines with <hr />
sed -i 's@___\+@<hr />@' $HTML

# Center title page
echo ".titlepage {text-align:center;}" >> $CSS

# Force page breaks in intro
echo ".pagebreak {page-break-before: always}" >> $CSS
## Before thanks
sed -i 's@\(<!--l. 2--><p class="indent\)" >$@\1 pagebreak" >@' $HTML

# Fix missing italic
echo ".fxlri-t-1 {font-style:italic;}" >> $CSS

## Before each day
sed -i 's@\(id="x1-[0-9]\+r[0-9]\+"\)>@\1 class="pagebreak">@' $HTML


# Fix small caps
for class in "fxlrc-t1-" "fxlrc-t1-x-x-120"; do
   while read c r; do
      sed -i "s@\(\"$class\">\)$c\([^<]*\)<@\1<span class=\"small-caps\">$r\2</span><@" $HTML
   done <<<"é É
è È
ê Ê
ﬁ FI
à À"
done


# Improve lettrines
echo ".fxlr-t-1x-x-318 {color:gray}" >> $CSS

