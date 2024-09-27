#!/bin/bash
# vim: set sw=2:

# Joseph Harriott

# Convert a single markdown file to pdf nicely.
# ---------------------------------------------
# bash $MD4PDF/GNULinux/m4p.sh
# m4p  is defined in   $AjB/bashrc-wm

if [ $1 ]; then
  if [ -s $1 ]; then
    mde=${1##*.}
    if [ $mde = gfm ]; then mdt=0
    elif [ $mde = md ]; then mdt=1
    else echo " $1  not a markdown file"; exit
    fi
    mdbn=${1%.*}
    # f=$1
  elif [ -s $1.gfm ]; then
    mdbn=$1; mdt=0
    if [ -s $1.md ]; then
      echo " specify either  $1.gfm  or  $1.md"; exit
    fi
  elif [ -s $1.md ]; then
    mdbn=$1; mdt=1
  else
    echo " $1  not leading to a markdown file"; exit
  fi
  bash $MD4PDF/GNULinux/md4pdf.sh $mdbn $mdt $2
else
  echo 'm4p.sh <md> [<flag_for_ToC>]'
  echo ' [ $2 ] switch off ToC'
fi

