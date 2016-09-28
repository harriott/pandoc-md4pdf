#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Wed 28 Sep 2016
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# --------------------------------------------------------------------------------------------------
# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.

if [ $1 ]; then
# do stuff
fi
