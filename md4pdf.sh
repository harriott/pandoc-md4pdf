#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Fri 20 Feb 2015
# Convert markdown file to pdf nicely.
# ----------------------------------------------------

# Populate a temporary tex file for the titling:
# (escaping any underscores in filename for passing to TeX)
bn=${1//_/\\_}
echo "\renewcommand\contentsname{$bn} \renewcommand{\thechapter}{} \usepackage{titlesec}
\titleformat{\chapter}{}{}{0em}{\bfseries\LARGE} \titlespacing{\chapter}{0pt}{30pt}{*2}
\usepackage{xcolor} \makeevenfoot{plain}{}{\textcolor{lightgray}{$bn} \quad p.\thepage\ }{}
\makeoddfoot{plain}{}{\textcolor{lightgray}{$bn} \quad p.\thepage\ }{}" > md4pdf.tex

# set the ToC Pandoc switches (the default case) if no 2nd argument was given:
if [ ! $2 ]; then tc="--toc --toc-depth=4"; fi

# if there was a 1st argument given (try to) Pandoc with it:
echo "running pandoc on $1.md"
if [ $1 ]; then
	pandoc -Vdocumentclass:memoir -Vclassoption:article -H md4pdf.tex -Vmainfont:Arial $tc -f \
	markdown_strict $1.md -o $1.pdf --latex-engine=xelatex;
fi

# tidy up, anyway:
rm md4pdf.tex

# if a pdf's been made, open it:
if [ -s $1.pdf ]; then
	nohup qpdfview $1.pdf &
	sleep 2
	rm nohup.out
fi

