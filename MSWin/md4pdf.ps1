# vim: set et tw=0:
# Joseph Harriott   Thu 13 Feb 2020
# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"),
  [string]$param1, [string]$param2 )

$mdf="$mdbn.md"
if (test-path "$mdf") {

  # Generate the specific include-in-header file
  # --------------------------------------------
  # prepare the filename for feeding safely to TeX
  $texbn=$mdbn.replace('\','/').replace('_','\_').replace('#','\#')
  # create contents header and file footer, and store it to a file
  $iihLines="\renewcommand\contentsname{\normalsize $texbn}`r`n\cfoot{ {\textcolor{lightgray}{$texbn}} \quad p.\thepage\ of \pageref{LastPage}}"
  [IO.File]::WriteAllLines('md4pdf-iih.tex', $iihLines)

  # prepare the md file for conversion
  # ----------------------------------
  # start without  vim modeline
  get-content $mdf | select -Skip 1 | set-content md4pdfBare
  # re-add  vim modeline  within a yaml metadata block
  $agnostic = Split-Path $PSScriptRoot -parent
  get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", md4pdfBare | Set-Content md4pdf.md
  # cleanup
  ri md4pdfBare

  # (try to) Pandoc
  # ---------------
  $debugLog="--verbose > md4pdfLog.tex" # option for debugging
  # $Command = "pandoc -f markdown+yaml_metadata_block -dmd4pdfMSWin -dmd4pdf -V CJKmainfont='Noto Sans CJK SC Regular' $param1 $param2 md4pdf.md -o $mdbn.pdf --pdf-engine=xelatex $debugLog"
  $Command = "pandoc -dmd4pdfMSWin -dmd4pdf -V CJKmainfont='Noto Sans CJK SC Regular' $param1 $param2 md4pdf.md -o $mdbn.pdf --pdf-engine=xelatex $debugLog"
  $Command
  iex $Command
  ri md4pdf-iih.tex # tidy up, anyway
  # occasionally the temporary  tex2pdf.*  folders don't get cleared, due to Dropbox I suppose...

}else{
  # write failure message:
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
