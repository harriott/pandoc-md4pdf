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
  if ($mdbn.length -le 77) { $shortbn=$mdbn }
  else { $shortbn=$mdbn.substring($mdbn.length-77,77) }
  $showbn=$shortbn.replace('\','/').replace('_','\_').replace('#','\#')
  # create contents header and file footer, and store it to a file which will be called from the generic defaults yaml
  $iihLines="\renewcommand\contentsname{\normalsize $showbn}`r`n\cfoot{ {\textcolor{lightgray}{$showbn}} \quad p.\thepage\ of \pageref{LastPage}}"
  [IO.File]::WriteAllLines('md4pdf-iih.tex', $iihLines)

  # prepare some variables
  # ----------------------
  $agnostic = Split-Path $PSScriptRoot -parent
  if ($ToC) {
    $dToC="-d md4pdfToC"
    $sl="$agnostic\separatorLine.md"
    $BeforeContent = get-content $sl
    }

  # first, assume using strict markdown, prepare Pandoc variables
  # -------------------------------------------------------------
  $from = "-f markdown_strict"
  $papersize = "-V papersize:A4"
  $hmargins = "-V geometry:hmargin=1cm"
  $vmargins = "-V geometry:vmargin='{1cm,2cm}'"
  $fontsize = "-V fontsize=12pt" # for full-page readability in a smartphone
  $mainfont = "-V mainfont=Arial"
  $CJKmainfont = "-V CJKmainfont='Noto Sans CJK SC Regular'"
  $CJKoptions = "-V CJKoptions=AutoFakeBold"
  $strict = "$from $papersize $hmargins $vmargins $fontsize $mainfont $CJKmainfont $CJKoptions"

  # prepare the md file for conversion
  # ----------------------------------
  # if wanting to use Pandoc's highly sensitive version of Markdown, uncomment the next two lines of code
    # prepare a yaml metadata block, and possibly a contents-separating line
    # $BeforeContent = get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", $sl
    # and switch off strict
    # $strict = ""
  # get the original markdown into an array
  $mdContent = get-content $mdf
  # write the  markdown  file that will be used for conversion, without the original  vim modeline
  $BeforeContent, $mdContent[1..$mdContent.count] | Set-Content md4pdf.md
  # minor warning
  if ($mdContent -match '^######') {Write-Host "attempted sixth-level heading" -foreground 'DarkCyan'}

  # (try to) Pandoc
  # ---------------
  $debugLog="--verbose > md4pdfLog.tex" # option for debugging
  $Command = "pandoc $strict -d md4pdfMSWin -d md4pdf $dToC -o $mdbn.pdf $debugLog"
  iex $Command
  $execSuccess=$?
  # $execSuccess=$false # uncomment for debugging

  # tidy up
  # -------
  if( $execSuccess ) {
    ri md4pdfLog.tex -erroraction 'silentlycontinue'
  } else {
    mi md4pdfLog.tex "$mdbn-md4pdfLog.tex" -force -erroraction 'silentlycontinue'
  }
  ri md4pdf-iih.tex -erroraction 'silentlycontinue'
  ri md4pdf.md

}else{
  # write failure message:
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
