# vim: set et tw=0:
# Joseph Harriott  http://momentary.eu/  Sat 24 Sep 2016
# Engine to convert markdown file to pdf nicely.
# ------------------------------------------------------
# Call this from a wrapper: md4pdf.ps1 md-file-basename [pandoc-toc-settings]

param( [string]$mdbn=$(throw "$PSCommandPath requires markdown basename"), [string]$toc )

$mdf="$mdbn.md"
if (test-path "$mdf") {
    $giih="$PSScriptRoot\md4pdf-iih.tex" # the generic include-in-header file

    # generate the specific include-in-header file:
    $iih="$mdbn-md4pdf-iih.tex"
    $texbn=$mdbn.replace('_','\\_') # escaping any underscores in filename for passing to TeX
    " \renewcommand\contentsname{$texbn} " > $iih
    " \cfoot{ {\textcolor{lightgray}{$texbn}} \quad p.\thepage\ of \pageref{LastPage}} " >> $iih

    "running pandoc on $mdf" # (try to) Pandoc
    "pandoc --verbose -V subparagraph=yes -H $giih -H $iih -V mainfont=Arial $toc -f markdown_strict $mdf -o $mdbn.pdf --latex-engine=xelatex"
    #pandoc --verbose -V subparagraph=yes -H $giih -H $iih -V mainfont=Arial $toc -f markdown_strict $mdf -o $mdbn.pdf --latex-engine=xelatex > $mdbn-md4pdf.log;

}else{
    Write-Host "$PSCommandPath : file " -foregroundcolor red -backgroundcolor white -nonewline;
    Write-Host "$mdf" -foregroundcolor red -backgroundcolor yellow -nonewline;
    Write-Host " ain't there" -foregroundcolor red -backgroundcolor white }
