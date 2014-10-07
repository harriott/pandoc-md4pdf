@echo off
rem vim: set tw=0:
rem Joseph Harriott - http://momentary.eu/
rem Convert markdown file to pdf nicely.
rem Put this in your path (eg C:\Users\jo\AppData\Local\Pandoc),
rem and call it from the markdown file's directory thus: md4pdf basename.
rem ---------------------------------------------------------------------

rem populate a temporary tex file for the titling (converting underscores for TeX):
set bn=%1
set pn=%bn%.pdf
echo \renewcommand\contentsname{%bn:_=\_%} \renewcommand{\thechapter}{} \usepackage{titlesec} \titleformat{\chapter}{}{}{0em}{\bfseries\LARGE} \titlespacing{\chapter}{0pt}{30pt}{*2}> md4pdf.tex

rem if there was a filename, Pandoc it:
if not -%1-==-- start /wait pandoc -Vdocumentclass:memoir -Vclassoption:article -H md4pdf.tex -Vmainfont:Arial --toc --toc-depth=4 -f markdown_strict %1.md -o %pn% --latex-engine=xelatex

del md4pdf.tex & rem tidy up

rem if a pdf's been made, open it nicely:
if exist %pn% start SumatraPDF -view "continuous facing" -page 1 -reuse-instance %1.pdf
