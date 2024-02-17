#!/bin/bash

# Joseph Harriott  Thu 25 Jan 2024

# $MD4PDF/GNULinux/m4ps.sh

# Recursively find all *.md files in the current directory,
#  convert those that haven't been done yet or have changed since last converted to pdf
#  (assuming original unextended markdown).
# Use LaTeX Chapter as the first level heading, and Subsubsection as the 5th
#  (and preferably last) level heading. Apply some neater formatting.
# --------------------------------------------------------------------------------------

# m4ps, m4ps1, mt  are defined in  $Bash/bashrc-wm

if [ $1 ]; then

    fd md4pdf.md -x rm  # just incase this script was stopped previously
    if [[ $(fd stderr.txt) ]]; then fd stderr.txt; exit; fi

    absm4p="$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh"  # $MD4PDF/GNULinux/md4pdf.sh

    if ( [ $1 ] && [ $1 = 0 ] ); then
        sure='y' # first argument was 0, so we're probably sure
    else
        read -p "About to recursively create a load of PDFs from markdowns ${tpf5b} - are you in the right parent directory?${tpfn} " sure
    fi
    [ ! $sure ] || [ $sure != "y" ] && exit

    if [ -d $machLg ]; then
        log=$machLg/m4ps.log
    else
        log=$HOME/m4ps.log
    fi
    [[ -f $log ]] && rm $log
    shopt -s globstar
    for mdfile in **/*.md; do
        mdf=${mdfile%.*}
        if [[ ! $mdf =~ " " ]]; then
            # record progress
                ls -l $mdf.md >> $log
                [ -f $mdf.pdf ] && ls -l $mdf.pdf >> $log
            if ( [ $1 ] && [ $1 != 0 ] ) || [ $mdf.pdf -ot $mdf.md ]; then
                bash $absm4p $mdf 1 $2  # the conversion (--from=markdown_strict)
                echo "Pandoc'd $mdf.md" >> $log
            fi
        else
            echo "skipped '$mdfile'"  # because space in name
        fi
    done
else
  echo 'm4ps.sh <redoFlag> [<ToCFlag>]'
  echo ' [ $1 != 0 ] redo all PDFs'
  echo ' [ $2 ] switch off ToC'
fi

