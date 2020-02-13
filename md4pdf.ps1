# vim: set et tw=0:
# Joseph Harriott  http://momentary.eu/  Mon 07 Oct 2019
# Engine to convert markdown file to pdf nicely.
# ------------------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"),
  [string]$param1, [string]$param2 )

$mdf="$mdbn.md"
if (test-path "$mdf") {
  $mdf

  # Generate the specific include-in-header file
  # --------------------------------------------
  # prepare the filename for feeding to TeX
  $texbn=$mdbn.replace('\','/').replace('_','\_').replace('#','\#')
  $texbn

  # create contents header and file footer
  $iihLines="\renewcommand\contentsname{\normalsize $texbn}`r`n\cfoot{ {\textcolor{lightgray}{$texbn}} \quad p.\thepage\ of \pageref{LastPage}}"
  [IO.File]::WriteAllLines('md4pdf-iih.tex', $iihLines)

  # (try to) Pandoc
  # ---------------
  $Command = "pandoc -V subparagraph=yes -dTextNotes-iih-Win -dTextNotes -V mainfont=Arial -V CJKmainfont='Noto Sans CJK SC Regular' $param1 $param2 -f markdown_strict $mdf -o $mdbn.pdf --pdf-engine=xelatex"
  $Command
  iex $Command
  # ri md4pdf-iih.tex # tidy up, anyway
  # occasionally the temporary  tex2pdf.*  folders don't get cleared, due to Dropbox I suppose...
}else{
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
