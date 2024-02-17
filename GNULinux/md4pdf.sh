#!/bin/bash
# vim: set sw=2:

# Joseph Harriott - Sat 07 Jan 2023

# engine to convert markdown file to pdf nicely
# ---------------------------------------------
# $MD4PDF/GNULinux/md4pdf.sh

if [[ $1 && $2 ]]; then

  mdf=$1.md; [ $2 = 0 ] && mdf=$1.gfm
  [ -f $mdf ] || exit
  # [ -f $1.gfm ] || [ -f $1.md ] || exit

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
  source $MD4PDF/GNULinux/md4pdf-cmdpn1.sh
  # store LaTeX code
  echo " \renewcommand\contentsname{\normalsize $cmdpn1} " > $iih
  echo " \cfoot{ {\textcolor{lightgray}{$cmdpn1}} \quad p.\thepage\ of \pageref{LastPage}} " >> $iih

  # first prepare Pandoc variables
  # ------------------------------
  # filter="-F pandoc-latex-fontsize"
  from="-f markdown_strict+backtick_code_blocks"
  [ $2 = 0 ] && from="-f gfm"
  papersize="-V papersize:A4"
  geometry="-V geometry:hmargin=1cm,vmargin='{1cm,2cm}'" # bottom margin must be 2cm for footer
  #
  # main font
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
      "-V fontsize=12pt" \
      '' \
      '' \
      '' \
      "-V fontsize=12pt" \
    )  # undefined defaults to 10pt
       # 12pt allows full-page readability in a smartphone
    m4pfont=1  # 1 selects 2nd array item
    #
  # mono font
  # positioning gets messed up if the page isn't wide enough
  # monofont="-V monofont='Ubuntu Mono'"
  monofont="-V monofont='Source Code Pro' -V monofontoptions:'Scale=0.9'"
  #
  CJKmainfont="-V CJKmainfont='Noto Sans CJK SC:style=Regular'"
  CJKoptions="-V CJKoptions=AutoFakeBold"
  #
  fpgfmmCC="$filter $from $papersize $geometry ${fontsize[$m4pfont]} ${mainfont[$m4pfont]} $monofont $CJKmainfont $CJKoptions"

  # prepare the md file for conversion
  # ----------------------------------
  md4pdf=$1-md4pdf.md; [ $2 = 0 ] && md4pdf=$1-md4pdf.gfm
  if [ $3 ]; then
    sed -n '2,$p' "$mdf" > $md4pdf
  else
    dToC="-d md4pdfToC"  #  ~/.pandoc/defaults/md4pdfToC.yaml  =  $MD4PDF/defaults-toc.yaml
    cp "$MD4PDF/separatorLine.md" $md4pdf
    sed -n '2,$p' "$mdf" >> $md4pdf
  fi

  # (try to) Pandoc
  # ---------------
    echo "running Pandoc on $mdf" # (try to) Pandoc
    # highlight headings that are too deep
    grep "^$headingtoodeep " $md4pdf

    se=$1-stderr.txt
    # verbose=--verbose  # for debugging
    Command="(pandoc $md4pdf $fpgfmmCC -H $MD4PDF/iih/iih.tex -H $iih -d md4pdf $dToC -o $1.pdf $verbose) 2> $se"
    #  ~/.pandoc/defaults/md4pdf.yaml  =  $MD4PDF/defaults.yaml  which calls the template

    # echo $Command
    eval $Command
    # [[ -f $se ]] && { [[ -s $se ]] || rm $se; } # removes it if it's empty
    if [ -f $se ]; then
      if [ -s $se ]; then
        echo $se  # there was a Pandoc error, check also for verbose output
        Tcf='\[makePDF] Source:'  # TeX code would follow this line
        if [[ -n $(grep "$Tcf" $se) ]]; then
          tex=$1-md4pdf-raw.tex
          sed -n "/$Tcf"'/{n;:a;N;/end{document}/!ba;p}' $se > $tex
          echo $tex  # raw TeX output was created
          # fd -tf -e tex '\-md4pdf-raw.tex' -X rm
          # fd -tf -e txt '\-stderr.txt' -X rm
        fi
      else
        rm $se  # empty, so remove it
      fi
    fi

    # Tidy up:
    rm $md4pdf $iih  # comment this if intending to use the the contents of  $Command  after this script
else
  echo 'md4pdf.sh <md-file-basename> <flag_for_markdown> <flag_for_ToC>'
  echo ' [ $2 = 0 ] GitHub-Flavored Markdown (otherwise original unextended markdown)'
  echo ' [ $3 ] switch off ToC'
fi

