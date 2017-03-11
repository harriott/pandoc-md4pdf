# vim: set et tw=0:
# Joseph Harriott  http://momentary.eu/  Tue 04 Oct 2016
# Engine to convert markdown file to pdf nicely.
# ------------------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires an md file basename"),
    [string]$toc, [string]$tocd )

$mdf="$mdbn.md"
if (test-path "$mdf") {
    $giih="$PSScriptRoot\md4pdf-iih.tex" # the generic include-in-header file

    # Generate the specific include-in-header file
    # --------------------------------------------
    # prepare the filename for feeding to TeX
    $texbn=$mdbn.replace('\','/').replace('_','\_').replace('#','\#')

    $iihLines="\renewcommand\contentsname{\normalsize $texbn}`r`n\cfoot{ {\textcolor{lightgray}{$texbn}} \quad p.\thepage\ of \pageref{LastPage}}"
    $iihf=$(gci "$mdf").fullname -replace '\.md$','-md4pdf-iih.tex'
    [IO.File]::WriteAllLines($iihf, $iihLines)

    # (try to) Pandoc
    # ---------------
    pandoc -V subparagraph=yes -H $giih -H $iihf -V mainfont=Arial $toc $tocd -f markdown_strict "$mdf" -o "$mdbn.pdf" --latex-engine=xelatex
    ri $iihf # tidy up, anyway
    # occasionally the temporary  tex2pdf.*  folders don't get cleared, due to Dropbox I suppose...
}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white
}
