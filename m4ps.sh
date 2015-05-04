#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Mon 04 May 2015
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# ----------------------------------------------------------------------------------------------
# If an argument is given, all of the pdf's are re-done.

# set the (Pandoc) ToC switches:
if [ ! $2 ]; then tc="--toc --toc-depth=4"; fi

absmd4pdf="$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh"

mdfiles=$(find . -name '*.md')
for mdfile in $mdfiles; do
	mdf=${mdfile%.*}
	if [ $1 ] || [ $mdf.pdf -ot $mdf.md ]; then
 	   $absmd4pdf $mdf "$tc"
	fi
done

