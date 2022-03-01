#!/bin/bash
# vim: set sw=2:

# Joseph Harriott - Wed 10 Nov 2021

# Engine to convert markdown file to pdf nicely.
# -----------------------------------------------------
# Call this from a wrapper: md4pdf.sh <md-file-basename> <flag_for_ToC>

if [ $1 ]; then

  # generate the specific include-in-header file
  # --------------------------------------------
  # this is for having the name of the document displayed
  #
  iih=$1-md4pdf-iih.tex
  # get the cropped path name
  fullmdpathname="$PWD/$1"
  lenfmdpn=${#fullmdpathname}
  croppedmdpn=${fullmdpathname: -$(($lenfmdpn<77? $lenfmdpn : 77))}
  cmdpn0=${croppedmdpn//_/\\_} # (escaping any underscores in filename for passing to TeX)
  cmdpn1=${cmdpn0//#/\\#} # (escaping any hashes in filename for passing to TeX)
  # store LaTeX code
  echo " \renewcommand\contentsname{\normalsize $cmdpn1} " > $iih
  echo " \cfoot{ {\textcolor{lightgray}{$cmdpn1}} \quad p.\thepage\ of \pageref{LastPage}} " >> $iih

  # first, assume using strict markdown, prepare Pandoc variables
  # -------------------------------------------------------------
  from="-f markdown_strict"
  papersize="-V papersize:A4"
  geometry="-V geometry:hmargin=1cm,vmargin='{1cm,2cm}'" # bottom margin must be 2cm for footer
  #
  mainfont=(
    "-V mainfont=Arimo" \
    "-V mainfont='Arimo Regular Nerd Font Complete'" \
    "-V mainfont=DejaVuSerif" \
    "-V mainfont='Liberation Sans'" \
    "-V mainfont='Open Sans'" \
    "-V mainfont='Ubuntu Nerd Font Complete'" \
  )
  fontsize=(
    "-V fontsize=12pt" \
    '' \
    '' \
    '' \
  )
  m4pfont=1
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
  md4pdf=$1-md4pdf.md
  if [ $2 ]; then
    dToC="-d md4pdfToC"  #  ~/.pandoc/defaults/md4pdfToC.yaml  =  $MD4PDF/defaults-toc.yaml
    cp "$MD4PDF/separatorLine.md" $md4pdf
    sed -n '2,$p' "$1.md" >> $md4pdf
  else
    sed -n '2,$p' "$1.md" > $md4pdf
  fi

  # (try to) Pandoc
  # ---------------
    echo "running Pandoc on $1.md" # (try to) Pandoc
    # highlight headings that are too deep
    grep "^$headingtoodeep " $md4pdf

    se=$1-stderr.txt
    # verbose=--verbose
    Command="(pandoc $md4pdf $strict -H $MD4PDF/iih/iih.tex -H $iih -d md4pdf $dToC -o $1.pdf $verbose) 2> $se"
    #  ~/.pandoc/defaults/md4pdf.yaml  =  $MD4PDF/defaults.yaml  which calls the template

    # echo $Command
    eval $Command
    [[ -f $se ]] && { [[ -s $se ]] || rm $se; } # removes it if it's empty

    # sed -n '/\[makePDF] Source:/{n;:a;N;/end{document}/!ba;p}' stdout.tex > md4pdf-raw.tex # for diagnosis (can xelatex directly)

    # Tidy up:
    rm $md4pdf $iih  # comment this if intending to use the the contents of $Command after this script
fi

