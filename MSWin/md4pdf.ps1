# vim: set fdl=2:

# Joseph Harriott   Wed 07 Apr 2021

# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

# param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"), [switch]$ToC )
param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"), [switch]$ToC, [switch]$debugCommand )

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
    $dToC = "-d md4pdfToC"
      # md4pdfToC  is set in  $onGH\MSWin10\symlinks.ps1  to point at  $MD4PDF\defaults-toc.yaml
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

  # build the  md4pdf.md  file for conversion
  # -----------------------------------------
  # if wanting to use Pandoc's highly sensitive version of Markdown, uncomment the next two lines of code
    # prepare a yaml metadata block, and possibly a contents-separating line
    # $BeforeContent = get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", $sl
    # and switch off strict
    # $strict = ""
  $mdContent = get-content $mdf  # gets the original markdown into an array
  # write the  markdown  file that will be used for conversion, without the original  vim modeline
  $BeforeContent, $mdContent[1..$mdContent.count] | Set-Content md4pdf.md
  #  - this file is subsequently pointed at in the  md4pdf  yaml
  if ($mdContent -match '^######') {Write-Host "attempted sixth-level heading" -foreground 'DarkCyan'}  # minor warning

  # (try to) Pandoc
  # ---------------
  # $vo = "--verbose > $1-stdout.tex" # option previously used for debugging (see my issue #6628)
  # $verbose = "--verbose$vo" # for  Pandoc  debugging
  $Command = "pandoc $strict -H $agnostic\iih\iih.tex -d md4pdf $dToC -o $mdbn.pdf $verbose"
    # the yaml  md4pdf  is set in  $onGH\MSWin10\symlinks.ps1  to point at  $MD4PDF\defaults.yaml
  if ($debugCommand) {$Command} else {iex $Command}
  $execSuccess=$?
  # $execSuccess=$false # uncomment for  Pandoc  debugging

  # tidy up
  # -------
  if( $execSuccess ) {
    ri md4pdfLog.tex -erroraction 'silentlycontinue'
  } else {
    mi md4pdfLog.tex "$mdbn-md4pdfLog.tex" -force -erroraction 'silentlycontinue'
  }
  if (!$debugCommand) {
    ri md4pdf-iih.tex -erroraction 'silentlycontinue'
    ri md4pdf.md
  } # keeping these if debugging  $Command

}else{
  # write failure message:
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
