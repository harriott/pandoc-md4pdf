# vim: set et tw=0:
# Joseph Harriott   Thu 13 Feb 2020
# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"), [string]$ToC )

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
  if ($ToC) {
    $dToC="-dmd4pdfToC"
    $sl="$agnostic\separatorLine.md"
    }
  get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", $sl, md4pdfBare | Set-Content md4pdf.md
  # cleanup
  ri md4pdfBare

  # (try to) Pandoc
  # ---------------
  $debugLog="--verbose > md4pdfLog.tex" # option for debugging
  $Command = "pandoc -dmd4pdfMSWin -dmd4pdf $dToC md4pdf.md -o $mdbn.pdf --pdf-engine=xelatex $debugLog"
  $Command
  iex $Command
  # ri md4pdf-iih.tex # tidy up, anyway (comment out if debugging)

}else{
  # write failure message:
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
