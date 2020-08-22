#!/bin/bash
# vim: set et sw=2 tw=0:

# Joseph Harriott - Mon 15 Jun 2020

# Engine to convert markdown file to pdf nicely.
# -----------------------------------------------------
# Call this from a wrapper: md4pdf.sh <md-file-basename> <flag for ToC>

if [ $1 ]; then

  # generate the specific include-in-header file
  # --------------------------------------------
  # this is for having the name of the document displayed
  #
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
  geometry="-V geometry:hmargin=1cm,vmargin='{1cm,2cm}'" # bottom margin must be 2cm for footer
  #
  mainfont=(
    "-V mainfont=Arimo" \
    "-V mainfont=DejaVuSerif" \
    "-V mainfont='Liberation Sans'" \
    "-V mainfont='Open Sans'" \
  )
  fontsize=(
    "-V fontsize=12pt" \
    '' \
    '' \
    '' \
  )
  # 12pt allows full-page readability in a smartphone
  #
  monofont="-V monofont='Ubuntu Mono'" # positioning gets messed up if the page isn't wide enough
  #
  CJKmainfont="-V CJKmainfont='Noto Sans CJK SC:style=Regular'"
  CJKoptions="-V CJKoptions=AutoFakeBold"
  #
  strict="$from $papersize $geometry ${fontsize[$m4pfont]} ${mainfont[$m4pfont]} $monofont $CJKmainfont $CJKoptions"

  # prepare the md file for conversion
  # ----------------------------------
  # ( assuming 1st line of original markdown file is a vim modeline )
  if [ $2 ]; then
    dToC="-d md4pdfToC"
    #  -d md4pdfToC  invokess  $MD4PDF/defaults-toc.yaml
    cp "$MD4PDF/separatorLine.md" md4pdf.md
    sed '1d' "$1.md" >> md4pdf.md
  else
    sed '1d' "$1.md" > md4pdf.md
  fi

  # (try to) Pandoc
  # ---------------
    echo "running pandoc on $1.md" # (try to) Pandoc
    # highlight headings that are too deep
    grep "^$headingtoodeep " md4pdf.md

    # vo=" > stdout.tex" # option previously used for debugging (see my issue #6628)
    # verbose="--verbose$vo" # for debugging
    se=$1-stderr.txt
    Command="(pandoc $strict -H $MD4PDF/iih/iih.tex -d md4pdf $dToC -o $1.pdf $verbose) 2>&1 | tee $se"
    #  -d md4pdf  invokess  $MD4PDF/defaults.yaml

    eval $Command
    [[ -f $se ]] && { [[ -s $se ]] || rm $se; } # removes it if it's empty

    [[ $verbose ]] && echo "verbose"
    # sed -n '/\[makePDF] Source:/{n;:a;N;/end{document}/!ba;p}' stdout.tex > md4pdf-raw.tex # for diagnosis (can xelatex directly)

    # Tidy up:
    rm md4pdf.md md4pdf-iih.tex  # comment this if intending to use the the contents of $Command after this script
    # rm stdout.tex              # option previously used (see my issue #6628)
fi

