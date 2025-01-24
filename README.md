vim: se fdl=4:

    $MD4PDF/README.md

md4pdf
======

For `markdown` files containing up to five level of heading, here are three small resources for smoother conversion to pdf using `Pandoc` calling `XeLaTeX`. Setup is a little tricky, but the result is something I use almost very day to convert my personal markdown notes to PDF so I can easily read them anywhere (but mostly on my Android devices).

### requirements
- `LaTeX`, `Pandoc` and my adapted [pandoc-templates](https://github.com/harriott/pandoc-templates)

#### configuration
- `Linux`: environment variable `$MD4PDF` set to the the path of this file's directory
- `Windows 10`: a `pdf` viewer that doesn't lock the `pdf` file, such as `SumatraPDF`

- heading styles are decided by whichever file is symlinked to `latex/m4p/headings.sty` - in my case, decided in the `Pandoc` sections of these shell configuration files:
    - [$AjB/bashrc-wm](https://github.com/harriott/OS-ArchBuilds/blob/master/jo/Bash/bashrc-wm)
    - [$MSWin10/PSProfile.ps1](https://github.com/harriott/OS-MSWin10/blob/master/PSProfile.ps1)
- your Pandoc's `defaults` directory needs these:
    - `md4pdfToC.yaml` - symlinked from `$MD4PDF/defaults-toc.yaml`
    - `md4pdf.yaml` - symlinked from `$MD4PDF/defaults.yaml`

### fonts
`Arimo Regular Nerd Font Complete` can handle "•"

#### language snags
- Burmese
- `-V CJKmainfont='Noto Sans CJK SC:style=Regular'` doesn't cope with "长城"

### list limits
- first level
    - second level
        - third level
            - fourth and last level, more than this throws "LaTeX Error: Too deeply nested."

