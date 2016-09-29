#!/bin/bash
# vim: set et tw=0:

# Joseph Harriott http://momentary.eu/  Wed 28 Sep 2016
# Recursively find all *.md files in the current directory, convert those that haven't been done yet or have changed since last converted to pdf. Use LaTeX Chapter as the first level heading, and Subsubsection as the 4th (and preferably last) level heading. Apply some neater formatting.
# --------------------------------------------------------------------------------------------------
# If a non-zero first argument is given, all of the pdf's are re-done.
# If a second argument is given, ToC is switched off.

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
			if($pdft -gt $mdt){"$pdf > $pdft"} # and print the pdf's name & time
			else{$gp=$true;"$pdf > $pdft - to redo"} # or signal it's to be redone
			}
		}
	else{$gp=$true;"$pdf -- not yet made"} # no pdf, so signal it's to be done
	if($gp){
		# Prepare the Titling:
		$Ln=$fn.replace("_","\_") # escape underscores for LaTeX
		echo "\renewcommand\contentsname{$Ln} \renewcommand{\thechapter}{} \usepackage{titlesec} \titleformat{\chapter}{}{}{0em}{\bfseries\LARGE} \titlespacing{\chapter}{0pt}{30pt}{*2} \usepackage{xcolor} \makeevenfoot{plain}{}{\textcolor{lightgray}{$Ln} \quad p.\thepage\ }{} \makeoddfoot{plain}{}{\textcolor{lightgray}{$Ln} \quad p.\thepage\ }{}" |
		out-file md4pdf.tex -encoding UTF8
		"- running pandoc"
		&pandoc -Vdocumentclass:memoir -Vclassoption:article -H md4pdf.tex -V mainfont:Arial --toc --toc-depth=4 -f markdown_strict $md -o $pdf --latex-engine=xelatex
		rm md4pdf.tex # tidy up
		}
	}

