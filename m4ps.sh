#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Wed 29 Jun 2016
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# ----------------------------------------------------------------------------------------------
# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.

# set the (Pandoc) ToC switches:
if [ ! $2 ]; then tc="--toc --toc-depth=5"; fi

absmd4pdf="$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh"

mdfiles=$(find . -name '*.md')
for mdfile in $mdfiles; do
	mdf=${mdfile%.*}
	if ( [ $1 ] && [ $1 != 0 ] ) || [ $mdf.pdf -ot $mdf.md ]; then
 	   bash $absmd4pdf $mdf "$tc"
	fi
done

