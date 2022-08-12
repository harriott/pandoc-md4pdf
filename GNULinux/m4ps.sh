#!/bin/bash

# Joseph Harriott  Fri 12 Aug 2022

# Recursively find all *.md files in the current directory,
# convert those that haven't been done yet or have changed since last converted to pdf.
# Use LaTeX Chapter as the first level heading, and Subsubsection as the 5th
# (and preferably last) level heading. Apply some neater formatting.
# -------------------------------------------------------------------------------------

# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.

# m4ps0, m4ps1, mt  are defined in  $Bash/bashrc-wm

# just incase this script was stopped previously
[ -s md4pdf.md ] && rm md4pdf.md

absm4p="$( dirname "${BASH_SOURCE[0]}" )/m4p.sh"  # $MD4PDF/GNULinux/md4pdf.sh

if ( [ $1 ] && [ $1 = 0 ] ); then
    sure='y' # first argument was 0, so we're sure
else
    read -p "About to recursively create a load of PDFs from markdowns ${tpf5b} - are you in the right parent directory?${tpfn} " sure
fi
[ ! $sure ] || [ $sure != "y" ] && exit

MI=$ulL/Arch/$host
echo $MI
if [ -d $MI ]; then
    log=$MI/m4ps.log
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
            bash $absm4p $mdf $2  # the conversion
            echo "Pandoc'd $mdf.md" >> $log
        fi
    else
        echo "skipped '$mdfile'"  # because space in name
    fi
done

