@echo off
rem vim: set tw=0:
rem Joseph Harriott - http://momentary.eu/ 26/11/14
rem Convert markdown file to pdf nicely.
rem Put this script in your path (eg C:\Users\jo\AppData\Local\Pandoc),
rem and call it from the markdown file's directory thus: md4pdf basename.
rem ---------------------------------------------------------------------

setlocal & rem all variables now local

rem populate a temporary tex file for the titling:
set bn=%1
set bln=%bn:_=\_% & rem escaped underscores in filename for passing to TeX
set pn=%bn%.pdf
echo \renewcommand\contentsname{%bln%} \renewcommand{\thechapter}{} \usepackage{titlesec} \titleformat{\chapter}{}{}{0em}{\bfseries\LARGE} \titlespacing{\chapter}{0pt}{30pt}{*2} \usepackage{xcolor} \makeevenfoot{plain}{}{\textcolor{lightgray}{%bln%} \quad p.\thepage\ }{} \makeoddfoot{plain}{}{\textcolor{lightgray}{%bln%} \quad p.\thepage\ }{}> md4pdf.tex

rem set the ToC Pandoc switches (the default case) if no 2nd argument was given:
if -%2-==-- set tc=--toc --toc-depth=4

rem if there was a 1st argument given (try to) Pandoc with it:
echo running pandoc on %1.md
if not -%1-==-- start/b/w pandoc -Vdocumentclass:memoir -Vclassoption:article -H md4pdf.tex -Vmainfont:Arial %tc% -f markdown_strict %1.md -o %pn% --latex-engine=xelatex

del md4pdf.tex & rem tidy up, anyway.

rem if a pdf's been made, open it nicely:
if exist %pn% start SumatraPDF -view "continuous facing" -page 1 -reuse-instance %pn%
