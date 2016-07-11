#!/bin/bash
# vim: set tw=0

# Joseph Harriott http://momentary.eu/ Mon 11 Jul 2016
# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------------
# Call this from a wrapper: md4pdf.sh md-file-basename pandoc-toc-settings

# Populate a temporary tex file for the titling:
# (escaping any underscores in filename for passing to TeX)
bn=${1//_/\\_}
echo "\renewcommand\contentsname{$bn} \renewcommand{\thechapter}{} \usepackage{titlesec}
\titleformat{\chapter}{}{}{0em}{\bfseries\LARGE} \titlespacing{\chapter}{0pt}{30pt}{*2}
\usepackage{xcolor} \makeevenfoot{plain}{}{\textcolor{lightgray}{$bn} \quad p.\thepage\ }{}
\makeoddfoot{plain}{}{\textcolor{lightgray}{$bn} \quad p.\thepage\ }{}" > md4pdf.tex

# if there was a 1st argument given (try to) Pandoc with it:
echo "running pandoc on $1.md"
if [ $1 ]; then
	pandoc -Vdocumentclass:memoir -Vclassoption:article -Vclassoption:a4paper -H md4pdf.tex -Vmainfont:Arial \
	-Vsubparagraph:yes $2 -f markdown_strict $1.md -o $1.pdf --latex-engine=xelatex;
fi

# tidy up, anyway:
rm md4pdf.tex

