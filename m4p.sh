#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Thu 22 Sep 2016
# Convert a single markdown file to pdf nicely.
# ----------------------------------------------------

if [ $1 ]; then
    mdf=${1%.md}
    if [ -s $mdf.md ]; then

        # set the Pandoc ToC switches (the default case) if no 2nd argument was given:
        if [ ! $2 ]; then tc="--toc --toc-depth=5"; fi

        bash "$( dirname "${BASH_SOURCE[0]}" )/md4pdf.sh" $mdf "$tc"

    else
        echo "- $mdf.md ain't there"
    fi
else
    echo "- need a markdown filename"
fi

