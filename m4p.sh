#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Mon 04 May 2015
# Convert a single markdown file to pdf nicely.
# ----------------------------------------------------

# set the (Pandoc) ToC switches (the default case) if no 2nd argument was given:
if [ ! $2 ]; then tc="--toc --toc-depth=4"; fi

"$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh" $1 "$tc"

# if a pdf's been made, open it:
if [ -s $1.pdf ]; then
	nohup qpdfview $1.pdf &
	sleep 2
	rm nohup.out
fi

