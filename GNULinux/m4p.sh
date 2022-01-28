#!/bin/bash

# Joseph Harriott

# Convert a single markdown file to pdf nicely.
# ---------------------------------------------
# m4p  is defined in   $Bash/bashrc-wm

if [ $1 ]; then
  mdf=${1%.md}
  if [ -s $mdf.md ]; then

    # if no 2nd argument, turn on ToC settings
    if [ ! $2 ]; then toc=1; fi

    mpCall="bash $MD4PDF/GNULinux/md4pdf.sh $mdf $toc"
    $mpCall

  else
    echo "- $mdf.md ain't there"
  fi
else
  echo "- need a markdown filename"
fi

