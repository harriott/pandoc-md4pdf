#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Mon 04 May 2015
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# ----------------------------------------------------------------------------------------------

# set the (Pandoc) ToC switches:
if [ ! $2 ]; then tc="--toc --toc-depth=4"; fi

absmd4pdf="$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh"
updatepdfs () {
    $absmd4pdf $1 "$tc"
}

mdfiles=$(find . -name '*.md')
for mdfile in $mdfiles; do
	mdf=${mdfile%.*}
    echo $absmd4pdf $mdf "$tc"
done

