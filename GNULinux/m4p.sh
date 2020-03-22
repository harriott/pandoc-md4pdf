#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott  Sat 21 Mar 2020
# Convert a single markdown file to pdf nicely.
# ---------------------------------------------

if [ $1 ]; then
  mdf=${1%.md}
  if [ -s $mdf.md ]; then

    # turn on ToC settings if a 2nd argument was not given
    if [ ! $2 ]; then toc=1; fi

    mpCall="bash $MD4PDF/GNULinux/md4pdf.sh $mdf $toc"
    $mpCall

  else
    echo "- $mdf.md ain't there"
  fi
else
  echo "- need a markdown filename"
fi

