md4pdf
======

For markdown files containing up to four level of heading, here are three small resources for smoother conversion to pdf using Pandoc calling XeLaTeX.

### Requirements
Windows 7 at least, with LaTeX, Pandoc and SumatraPDF installed.

### Vim modeline
eg my `Europe.md` notes file begins thus:
```markdown
---
[//]: # ( vim: set fdm=expr:)

Does the cartography workshop where Christopher Columbus lived in Lisbon still exist?
```
---
## titles.tex
A LaTeX pre-configuration file for Pandoc, included by way of explanation of the 4th-level markdown heading snag that I have resolved here by pushing headings up a LaTeX level, and tidying up the top one (now Chapter).

## md4pdf.bat
Windows Batch file for converting a markdown file to pdf, using the pre-formatting gathered in `titles.tex` and with the file's basename fed through as the replacement for the "Contents" header in the pdf's table of contents.

## md4pdf.ps1
PowerShell Script for recursively converting all as yet unconverted or recently changed markdown files in a directory, as per `md4pdf.bat`.

