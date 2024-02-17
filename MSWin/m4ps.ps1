# vim: set fdl=5:

# Joseph Harriott  Thu 15 Jul 2021
# $MD4PDF\MSWin\m4ps.ps1

# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.

# eg  m4ps -r -n  would redo all pdf's, and switch off ToC

param( [switch]$redo, [switch]$sure, [switch]$noToC )
if ($noToC) { [bool]$ToC=0 } else { [bool]$ToC=1 } # Table of Contents

if ($sure) {$reply = 'y'} else {
  Write-Host 'About to recursively create a load of PDFs from markdowns ' -NoNewline
  [System.Console]::ForegroundColor = 'Yellow'
  $reply = Read-Host '- are you in the right parent directory? '
  [System.Console]::ResetColor()
  }
if ($reply -eq 'y') {
  gci -r -i *.md| # get all the markdown files recursively
    foreach{
      $fn=$_.basename
      $md=$_.fullname
      $mdt=$_.LastWriteTime
      "$md -> $mdt" # print the markdown file's fullname with LastWriteTime
      $gp=$false # set a "go pdf" boolean
      $pdf=$_.directoryname+"\"+$fn+".pdf"
      if ($redo) {$gp=$true;Write-Host "$pdf -- to (re)do" -foreground Gray}
      else{
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
      }
      if($gp){
        Write-Host "- running pandoc" -foreground Gray
          $mdp = $md -replace '\.md$','' # md file's basepathname
        $Command = "$PSScriptRoot\md4pdf.ps1 $mdp -ToC:$"+$ToC
        PowerShell -NoProfile $command
      }
    }
  }

ri tex2pdf.???* # remove trailing work folders (sometimes without success, due to Dropbox, I suppose)

# highlight any conversion failures
[System.Console]::ForegroundColor = 'Cyan'
gci -r "*-md4pdfLog.tex" | %{echo $_.fullname}
[System.Console]::ResetColor()

