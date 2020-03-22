#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Mon 07 Oct 2019
# Engine to convert markdown file to pdf nicely.
# -----------------------------------------------------
# Call this from a wrapper: md4pdf.sh <md-file-basename> <flag for ToC>

if [ $1 ]; then

  # generate the specific include-in-header file
  # --------------------------------------------
  # get the cropped path name
  fullmdpathname="$PWD/$1"
  lenfmdpn=${#fullmdpathname}
  croppedmdpn=${fullmdpathname: -$(($lenfmdpn<77? $lenfmdpn : 77))}
  cmdpn0=${croppedmdpn//_/\\_} # (escaping any underscores in filename for passing to TeX)
  cmdpn1=${cmdpn0//#/\\#} # (escaping any hashes in filename for passing to TeX)
  # store LaTeX code
  echo " \renewcommand\contentsname{\normalsize $cmdpn1} " > md4pdf-iih.tex
  echo " \cfoot{ {\textcolor{lightgray}{$cmdpn1}} \quad p.\thepage\ of \pageref{LastPage}} " >> md4pdf-iih.tex

  # first, assume using strict markdown, prepare Pandoc variables
  # -------------------------------------------------------------
  from="-f markdown_strict"
  papersize="-V papersize:A4"
  hmargins="-V geometry:hmargin=1cm"
  vmargins="-V geometry:vmargin='{1cm,2cm}'"
  fontsize="-V fontsize=12pt" # for full-page readability in a smartphone
  # mainfont="-V mainfont='Open Sans'"
  # mainfont="-V mainfont='Liberation Sans'"
  mainfont="-V mainfont=Arimo"
  CJKmainfont="-V CJKmainfont='Noto Sans CJK SC:style=Regular'"
  CJKoptions="-V CJKoptions=AutoFakeBold"
  strict="$from $papersize $hmargins $vmargins $fontsize $mainfont $CJKmainfont $CJKoptions"

  # prepare the md file for conversion
  # ----------------------------------
  # ( assuming 1st line of original markdown file is a vim modeline )
  if [ $2 ]; then
    dToC="-d md4pdfToC"
    cp "$MD4PDF/separatorLine.md" md4pdf.md
    sed '1d' "$1.md" >> md4pdf.md
  else
    sed '1d' "$1.md" > md4pdf.md
  fi
  # highlight sixth level headings
  grep "^###### " md4pdf.md

  # (try to) Pandoc
  # ---------------
    echo "running pandoc on $1.md" # (try to) Pandoc
    debugLog="--verbose > md4pdfLog.tex" # option for debugging
    # Command="pandoc $strict -d md4pdfGNULinux -d md4pdf $dToC -o $1.pdf $debugLog"
    Command="(pandoc $strict -d md4pdfGNULinux -d md4pdf $dToC -o $1.pdf $debugLog) 2>&1 | tee $1-WARNING.txt"
    eval $Command
    # eval $Command | tee $1-WARNING.txt

    sed -n '/\[makePDF] Source:/{n;:a;N;/end{document}/!ba;p}' md4pdfLog.tex > md4pdf-raw.tex # for diagnosis (can xelatex directly)

    # Tidy up:
    # rm md4pdf.md md4pdf-iih.tex
    # rm md4pdfLog.tex
    # rm md4pdf-raw.tex
fi
