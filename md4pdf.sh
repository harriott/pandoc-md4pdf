#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Sat 24 Sep 2016
# Engine to convert markdown file to pdf nicely.
# -----------------------------------------------------
# Call this from a wrapper: md4pdf.sh md-file-basename pandoc-toc-settings

if [ $1 ]; then
    # get the generic include-in-header file:
    giih="$( dirname "${BASH_SOURCE[0]}" )/md4pdf-iih.tex"

    # generate the specific include-in-header file:
    bn=${1//_/\\_} # (escaping any underscores in filename for passing to TeX)
    iih=$1-md4pdf-iih.tex
    echo " \renewcommand\contentsname{$bn} " > $iih
    echo " \cfoot{ {\textcolor{lightgray}{$bn}} \quad p.\thepage\ of \pageref{LastPage}} " >> $iih

    echo "running pandoc on $1.md" # (try to) Pandoc
    pandoc --verbose -V subparagraph=yes -H $giih -H $iih -V mainfont=Arial $2 \
        -f markdown_strict $1.md -o $1.pdf --latex-engine=xelatex > $1-md4pdf.log;

    sed -n '/\[makePDF] Contents of /{n;:a;N;/end{document}/!ba;p}' $1-md4pdf.log \
        > $1-md4pdf-raw.tex # for diagnosis (can xelatex directly)

    # Tidy up:
    rm $1-md4pdf.log $1-md4pdf-iih.tex $1-md4pdf-raw.tex
fi
