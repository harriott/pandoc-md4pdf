# vim: set et fdl=2:
# Joseph Harriott   Thu 13 Feb 2020
# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"), [string]$ToC )

$mdf="$mdbn.md"
if (test-path "$mdf") {

  # Generate the specific include-in-header file
  # --------------------------------------------
  # prepare the filename for feeding safely into TeX
  $texbn=$mdbn.replace('D:\Dropbox\JH\Now\TextNotes\','').replace('\','/').replace('_','\_').replace('#','\#')
  # create contents header and file footer, and store it to a file
  $iihLines="\renewcommand\contentsname{\normalsize $texbn}`r`n\cfoot{ {\textcolor{lightgray}{$texbn}} \quad p.\thepage\ of \pageref{LastPage}}"
  [IO.File]::WriteAllLines('md4pdf-iih.tex', $iihLines)

  # prepare some variables
  # ----------------------
  $agnostic = Split-Path $PSScriptRoot -parent
  if ($ToC) {
    $dToC="-d md4pdfToC"
    $sl="$agnostic\separatorLine.md"
    }

  # prepare the md file for conversion
  # ----------------------------------
  $mdContent = get-content $mdf
  # prepare a yaml metadata block, and possibly a contents-separating line
  $BeforeContent = get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", $sl
  # write the  pandoc markdown  file that will be used for conversion, without the original  vim modeline
  $BeforeContent, $mdContent[1..$mdContent.count] | Set-Content md4pdf.md
  # minor warning
  if ($mdContent -match '^######') {Write-Host "attempted sixth-level heading" -foreground 'DarkCyan'}

  # (try to) Pandoc
  # ---------------
  $debugLog="--verbose > md4pdfLog.tex" # option for debugging
  $Command = "pandoc -d md4pdfMSWin -d md4pdf $dToC -o $mdbn.pdf $debugLog"
  iex $Command

  # tidy up
  # -------
  if( $? ) {
    mi md4pdfLog.tex "$mdbn-md4pdfLog.tex" -force
  } else {
    ri md4pdfLog.tex
  }
  ri md4pdf-iih.tex -erroraction 'silentlycontinue'
  ri md4pdf.md

}else{
  # write failure message:
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
