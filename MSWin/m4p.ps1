# vim: set fdl=1:

# Joseph Harriott  Wed 07 Apr 2021

# Convert a single markdown file to pdf nicely.
# ---------------------------------------------

param( [string]$md=$(throw "$PSCommandPath requires an md file"), [switch]$noToC, [switch]$debugCommand )

$mdfbn=$md -replace '\.md$','' # get md file basename
$mdf=$mdfbn + ".md"
if (test-path "$mdf") {
    # if (!$noToC) { $ToC=1 } # if we want Table of Contents
    if ($noToC) { [bool]$ToC=0 } else { [bool]$ToC=1 }
    if ($debugCommand) { $CD = '-c' }
    "running pandoc on $mdf"
    $Command = "$PSScriptRoot\md4pdf.ps1 $mdfbn -ToC:$"+$ToC+" -debugCommand:$"+$debugCommand
    PowerShell -NoProfile $command
}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}

ri -recurse tex2pdf.????* # remove trailing work folders
