#!/bin/bash

HTML="$1"
CSS="$(basename $HTML .html).css"

# Replace long lines with <hr />
sed -i 's@___\+@<hr />@' $HTML

# Wrap text in pure HTML
echo "body { padding: 0 300px 0 300px }" >> $CSS

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



# Remove months added (for an unknown reason)
#   -- ugly!
sed -i ':a ; $! { N ; ba } ; $s/\(<span\( \|\n\|\t\)\+class="fxlbc-t1-x-x-172">[^4]\+\)\(<span\( \|\n\|\t\)\+class="fxlbc-t1-x-x-248">\)/\3/g' $HTML


