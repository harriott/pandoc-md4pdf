# vim: set fdl=2:

# Joseph Harriott  Sat 17 Feb 2024
# $MD4PDF\MSWin\m4p.ps1

# Pandoc  a single  Markdown  file to  pdf  nicely.
# -------------------------------------------------

param( [string]$mf=$(throw "$PSCommandPath  requires a  gfm  or  md  file"), [switch]$gfm, [switch]$noToC, [switch]$debugCommand )

if ($gfm) {
  $gfmF = '-gfm'
  $gfmFbn=$mf -replace '\.gfm$','' # get  gfm  file basename
  $mf=$gfmFbn + ".gfm"
} else {
  $gfmF = ''
  $gfmFbn=$mf -replace '\.md$','' # get  md  file basename
  $mf=$gfmFbn + ".md"
}

if (test-path "$mf") {
  if ($noToC) { $ToCF = '' } else { $ToCF = '-ToC' }
  if ($debugCommand) { $debugCommandF = '-debugCommand' } else { $debugCommandF = '' }
  "running pandoc on $mf"
  $Command = "$PSScriptRoot\md4pdf.ps1 $gfmFbn $gfmF $ToCF $debugCommandF"
  PowerShell -NoProfile $command
}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}

ri -recurse tex2pdf.????* # remove trailing work folders

