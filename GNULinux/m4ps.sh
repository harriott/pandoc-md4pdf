#!/bin/bash

# Joseph Harriott  Mon 05 Apr 2021
# Recursively find all *.md files in the current directory,
# convert those that haven't been done yet or have changed since last converted to pdf.
# Use LaTeX Chapter as the first level heading, and Subsubsection as the 5th
# (and preferably last) level heading. Apply some neater formatting.
# -------------------------------------------------------------------------------------
# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.

# just incase this script was stopped previously
[ -s md4pdf.md ] && rm md4pdf.md

absm4p="$( dirname "${BASH_SOURCE[0]}" )/m4p.sh"

# echo "PDF's marked as older by BASH -ot" > BASH-older.txt
# echo "due to Dropbox seemingly resetting the modified date of md's on download" >> BASH-older.txt

if ( [ $1 ] && [ $1 = 0 ] ); then
    sure='y' # first argument was 0, so we're sure
else
    read -p "About to recursively create a load of PDFs from markdowns ${tpf5b} - are you in the right parent directory?${tpfn} " sure
fi

if [ $sure ]; then
    if [ $sure = "y" ]; then
        mdfiles=$(find . -name '*.md')
        for mdfile in $mdfiles; do
            mdf=${mdfile%.*}
            # ls -l $mdf.pdf $mdf.md
            if ( [ $1 ] && [ $1 != 0 ] ) || [ $mdf.pdf -ot $mdf.md ]; then
                # [ $mdf.pdf -ot $mdf.md ] && ls -l $mdf.pdf $mdf.md >> BASH-older.txt
                bash $absm4p $mdf $2
            fi
        done
    fi
fi

