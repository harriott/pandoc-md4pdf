#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Fri 12 Jun 2015
# Convert a single markdown file to pdf nicely.
# ----------------------------------------------------

# set the (Pandoc) ToC switches (the default case) if no 2nd argument was given:
if [ ! $2 ]; then tc="--toc --toc-depth=4"; fi

bash "$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh" $1 "$tc"

# if we can identify a pdf viewer, and a pdf's been made, open it:
if [ -f /etc/os-release ] && [ -s $1.pdf ]; then
	. /etc/os-release
	if [ "$NAME" = "Arch Linux" ]; then
		pdfvwr=qpdfview
	elif [ "$NAME" = "openSUSE" ]; then
		pdfvwr=okular
   	fi
	nohup $pdfvwr $1.pdf &
	sleep 2
	rm nohup.out
fi

