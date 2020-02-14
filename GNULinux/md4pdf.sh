#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Mon 07 Oct 2019
# Engine to convert markdown file to pdf nicely.
# -----------------------------------------------------
# Call this from a wrapper: md4pdf.sh md-file-basename pandoc-toc-settings

if [ $1 ]; then
    # get the generic include-in-header file:
    giih="$( dirname "${BASH_SOURCE[0]}" )/md4pdf-iih.tex"

    # generate the specific include-in-header file:
    iih=$1-md4pdf-iih.tex
    bn0=${1//_/\\_} # (escaping any underscores in filename for passing to TeX)
    bn1=${bn0//#/\\#} # (escaping any hashes in filename for passing to TeX)
    echo " \renewcommand\contentsname{$bn1} " > $iih # initiates the iih file
    echo " \cfoot{ {\textcolor{lightgray}{$bn1}} \quad p.\thepage\ of \pageref{LastPage}} " >> $iih

    echo "running pandoc on $1.md" # (try to) Pandoc
    pandoc --verbose -V subparagraph=yes -H $giih -H $iih -V mainfont="Noto Sans" \
        -V CJKmainfont='Noto Sans CJK SC Regular' $2 \
        -f markdown_strict $1.md -o $1.pdf --pdf-engine=xelatex > $1-md4pdf.log;

    sed -n '/\[makePDF] Contents of /{n;:a;N;/end{document}/!ba;p}' $1-md4pdf.log \
        > $1-md4pdf-raw.tex # for diagnosis (can xelatex directly)

    # Tidy up:
    rm $1-md4pdf.log $1-md4pdf-iih.tex $1-md4pdf-raw.tex
fi
