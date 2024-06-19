\newcommand{\version}{v1.0}
\newcommand{\name}{thesis_uc3m}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{\name}[\version\space Template for Final Degree Project at UC3M]

% Needed to deal with tables
\RequirePackage{tabularx}
% Needed to make fixed length table
\RequirePackage{array}
% Needed to handle list environment
\RequirePackage{enumitem}
% Needed to handle text alignment
\RequirePackage{ragged2e}
% Needed to configure page layout
\RequirePackage{geometry}
% Needed to make header & footer efficiently
\RequirePackage{fancyhdr}
% Needed to manage colors
\RequirePackage{xcolor}
% Needed to use \ifxetex-\else-\fi statement
\RequirePackage{ifxetex}
% Needed to use \if-\then-\else statement
\RequirePackage{xifthen}
% Needed to strip chars from telephone number
\RequirePackage{xstring}
% Needed to use a toolbox of programming tools
\RequirePackage{etoolbox}
% Needed to change line spacing in specific environment
\RequirePackage{setspace}
% Needed to manage fonts
\RequirePackage[quiet]{fontspec}
% To support LaTeX quoting style
\defaultfontfeatures{Ligatures=TeX}
% Needed for advanced quotes
\RequirePackage[strict=true]{csquotes}
% Needed to manage math fonts
\RequirePackage{unicode-math}
% Needed to use icons from font-awesome
\RequirePackage{fontawesome5}
% Needed for proper times font
\RequirePackage{times}
% Needed for getting the current date
\RequirePackage{datetime2}
% Needed to deal a paragraphs
\RequirePackage{parskip}
% Needed to deal with images
\RequirePackage{graphicx}
% Needed to deal hyperlink
\RequirePackage[hidelinks,unicode,pdfpagelabels=false]{hyperref}
% Needed to manage code
\RequirePackage{listings}
% TODO customize

% TODO change it
\hypersetup{%
pdftitle={},
pdfauthor={Andrés Navarro Pedregal},
pdfsubject={},
pdfkeywords={}
pdfborderstyle={/S/U/W 1} % underline style
plainpages=false
pdfpagelayout=singlepage
bookmarksopen=false
bookmarksnumbered=true
breaklinks=true
linktocpage=true
colorlinks=true
linkcolor=blue % TODO change color
urlcolor=blue
filecolor=red
}

% **************************************************
% Layout
% **************************************************

% Configure page margins with geometry
\geometry{left=3.0cm, top=2.5cm, right=3.0cm, bottom=2.5cm, footskip=.5cm}

%% Header & Footer
% Set offset to each header and footer
\fancyhfoffset{0em}
% Remove head rule
\renewcommand{\headrulewidth}{0pt}
% Clear all header & footer fields
\fancyhf{}
% Enable if you want to make header or footer using fancyhdr
\pagestyle{fancy}

% **************************************************
% Text Format
% **************************************************
\setstretch{1.2} % value for line spacing
\clubpenalty=10000 % prevent single lines at the beginning of a paragraph
\widowpenalty=10000 % prevent single lines at the end of a paragraph

% **************************************************
% Graphics
% **************************************************

% Define path to figures
\graphicspath{{figures/}}
