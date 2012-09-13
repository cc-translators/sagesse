\NeedsTeXFormat{LaTeX2e}[2012/09/13]
\ProvidesClass{diary}
\DeclareOption{scrartcl}{\def\diary@class{scrartcl}}
\DeclareOption{scrreprt}{\def\diary@class{scrreprt}}
\DeclareOption{scrbook}{\def\diary@class{scrbook}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\diary@class}}
\ExecuteOptions{scrbook}
\ProcessOptions\relax
\LoadClass{\diary@class}

