md4pdf
======

For `markdown` files containing up to five level of heading, here are three small resources for smoother conversion to pdf using `Pandoc` calling `XeLaTeX`.

The first line of the markdown file is assumed to be a `vim` modeline, and is stripped out before the conversion.

### Requirements
`Windows 10`: `LaTeX`, `Pandoc` and a `pdf` viewer that doesn't lock the `pdf` file, such as `SumatraPDF`.

The `bash` version assumes that an environment variable `$MD4PDF` has been set to the the path of this file's directory.

