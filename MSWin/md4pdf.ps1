# vim: set fdl=2:

# Joseph Harriott - Sat 17 Feb 2024
# $MD4PDF\MSWin\md4pdf.ps1

# Engine to convert markdown file to pdf nicely.
# ----------------------------------------------
# Call this from a wrapper:  md4pdf.ps1 <md-file-basename> [-gfm] [-ToC] [-debugCommand]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"), [switch]$gfm, [switch]$ToC, [switch]$debugCommand )

if ($gfm) {
  $from = "-f gfm"
  $mf="$mdbn.gfm"
} else {
  $from = "-f markdown_strict"
  $mf="$mdbn.md"
  }
if (test-path "$mf") {

  # Generate the specific include-in-header file
  # --------------------------------------------
  # prepare the filename for feeding safely into TeX
  $iih="$mdbn-md4pdf-iih.tex"
  if ($mdbn.length -le 77) { $shortbn=$mdbn }
  else { $shortbn=$mdbn.substring($mdbn.length-77,77) }
  $showbn=$shortbn.replace('\','/').replace('_','\_').replace('#','\#')
  # create contents header and file footer, and store it to a file which will be called from the generic defaults yaml
  $iihLines="\renewcommand\contentsname{\normalsize $showbn}`r`n\cfoot{ {\textcolor{lightgray}{$showbn}} \quad p.\thepage\ of \pageref{LastPage}}"
  [IO.File]::WriteAllLines($iih, $iihLines)

  # prepare some variables
  # ----------------------
  $agnostic = Split-Path $PSScriptRoot -parent
  if ($ToC) {
    $dToC = "-d md4pdfToC"
      # md4pdfToC  is set in  $MSWin10\mb\symlinks.ps1  to point at  $MD4PDF\defaults-toc.yaml
    $sl="$agnostic\separatorLine.md"
    $BeforeContent = get-content $sl
    }

  # first, assume using strict markdown, prepare Pandoc variables
  # -------------------------------------------------------------
  $papersize = "-V papersize:A4"
  $hmargins = "-V geometry:hmargin=1cm"
  $vmargins = "-V geometry:vmargin='{1cm,2cm}'"
  $fontsize = "-V fontsize=12pt" # for full-page readability in a smartphone
  $mainfont = "-V mainfont=Arial"
  # $monofont = "-V monofont='Cascadia Code'"
  # $monofont = "-V monofont=Consolas"  # $ITsCP\Pandoc\Consolas_hyphen_snag.md
  $monofont = "-V monofont='Lucida Console'"
  # $monofont = "-V monofont='Source Code Pro'"
  $CJKmainfont = "-V CJKmainfont='Noto Sans CJK SC Regular'"
  $CJKoptions = "-V CJKoptions=AutoFakeBold"
  $strict = "$from $papersize $hmargins $vmargins $fontsize $mainfont $monofont $CJKmainfont $CJKoptions"

  # build the file for conversion
  # -----------------------------
  $md4md="$mdbn-md4pdf.md"
  # if using Pandoc's highly sensitive version of Markdown, uncomment the next three lines of code
    # prepare a yaml metadata block, and possibly a contents-separating line
    # $BeforeContent = get-content "$agnostic\metadata-vim.yaml", "$PSScriptRoot\metadata.yaml", "$agnostic\metadata.yaml", $sl
    # $strict = ""
  $mdContent = get-content $mf  # gets the original markdown into an array
  # write the  markdown  file that will be used for conversion, without the first line
  $BeforeContent, $mdContent[1..$mdContent.count] | Set-Content $md4md
  if ($mdContent -match '^######') {
    $sixth = 1
    write-host "attempted sixth-level heading" -foreground 'DarkCyan'  # minor warning
  }

  # (try to) Pandoc
  # ---------------
  if ($debugCommand) { $verbose = "--verbose 2> $mf-stderr.txt" }
  $Command = "pandoc $md4md $strict -H $agnostic\iih\iih.tex -H $iih -d md4pdf $dToC -o $mdbn.pdf $verbose"
    # the yaml  md4pdf  is set in  $MSWin10\mb\symlinks.ps1  to point at  $MD4PDF\defaults.yaml
  iex $Command
  if ($debugCommand) {
    $Command.replace('d md4pdf','d $MD4PDF\defaults.yaml')
    } else {
    # tidy up
    ri $iih -erroraction 'silentlycontinue'
    ri $md4md
  } # keeping these if debugging  $Command

}else{
  # the proposed markdown file wasn't found
  Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
  Write-Host "$mf" -foregroundcolor red -backgroundcolor yellow -nonewline;
  Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}

# if something broke,  sl $TeNo; fd md4pdf

