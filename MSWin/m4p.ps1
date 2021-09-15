# vim: set fdl=1:

# Joseph Harriott  Thu 12 Aug 2021

# Convert a single markdown file to pdf nicely.
# ---------------------------------------------

param( [string]$md=$(throw "$PSCommandPath requires an md file"), [switch]$noToC, [switch]$debugCommand )

$mdfbn=$md -replace '\.md$','' # get md file basename
$mdf=$mdfbn + ".md"
if (test-path "$mdf") {
    if ($noToC) { [bool]$ToC=0 } else { [bool]$ToC=1 } # Table of Contents
    "running pandoc on $mdf"
    $Command = "$PSScriptRoot\md4pdf.ps1 $mdfbn -ToC:$"+$ToC+" -debugCommand:$"+$debugCommand
    PowerShell -NoProfile $command
}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}

ri -recurse tex2pdf.????* # remove trailing work folders
