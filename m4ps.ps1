#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Wed 28 Sep 2016
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# --------------------------------------------------------------------------------------------------
# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.
param( [string]$redo, [string]$ToCoff )
if (!$ToCoff) {$ToC="--toc --toc-depth=5"}

gci -r -i *.md| # get all the markdown files recursively
foreach{
    $fn=$_.basename
    $md=$_.fullname
    $mdt=$_.LastWriteTime
    "$md -> $mdt" # print the markdown file's fullname with LastWriteTime
    $gp=$false # set a "go pdf" boolean
    $pdf=$_.directoryname+"\"+$fn+".pdf"
    if (test-path "$pdf"){
        gi "$pdf"|
        foreach{
            $pdft=$_.LastWriteTime;
            # print a newer pdf's name & time:
            if($pdft -gt $mdt){Write-Host "$pdf > $pdft" -foreground Gray}
            # or signal an old pdf is to be redone:
            else{$gp=$true;Write-Host "$pdf > $pdft - to redo" -foreground Gray}
            }
        }
    # no pdf, so signal it's to be done:
    else{$gp=$true;Write-Host "$pdf -- not yet made" -foreground Gray}
    if($gp){
        Write-Host "- running pandoc" -foreground Gray
        # PowerShell -NoProfile "$PSScriptRoot\md4pdf.ps1 $fn $toc"
        }
    }

