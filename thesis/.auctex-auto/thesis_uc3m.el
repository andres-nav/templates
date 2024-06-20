(TeX-add-style-hook
 "thesis_uc3m"
 (lambda ()
   (setq TeX-command-extra-options
         "-output-directory=/tmp/latexbuild")
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontspec" "quiet") ("csquotes" "strict=true") ("hyperref" "hidelinks" "unicode" "pdfpagelabels=false")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "tabularx"
    "array"
    "enumitem"
    "ragged2e"
    "geometry"
    "fancyhdr"
    "xcolor"
    "ifxetex"
    "xifthen"
    "xstring"
    "etoolbox"
    "setspace"
    "fontspec"
    "csquotes"
    "unicode-math"
    "fontawesome5"
    "times"
    "datetime2"
    "parskip"
    "graphicx"
    "hyperref"
    "listings")
   (TeX-add-symbols
    "version"
    "name"))
 :latex)

