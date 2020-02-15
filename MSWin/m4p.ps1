# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Mon 15 Oct 2018
# Convert a single markdown file to pdf nicely.
# -----------------------------------------------------
#
# Eg:  m4p -m mdbasename -n -v fontsize:10pt

param( [string]$md=$(throw "$PSCommandPath requires an md file"), [switch]$noToC)

$mdfbn=$md -replace '\.md$','' # get md file basename
$mdf=$mdfbn + ".md"
if (test-path "$mdf") {
    if (!$noToC) { $ToC=1 } # if we want Table of Contents

    "running pandoc on $mdf"
    $Command = "$PSScriptRoot\md4pdf.ps1 $mdfbn $ToC"
    PowerShell -NoProfile $command
}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}

ri -recurse tex2pdf.????* # remove trailing work folders
