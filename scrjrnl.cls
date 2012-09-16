%%
%% This is file `scrjrnl.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% scrjrnl.dtx  (with options: `package')
%% 
%% This is a generated file.
%% 
%% Copyright (C) 2011-2012 by Raphaël Pinson <raphink@gmail.com>
%% --------------------------------------------------------------------------
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{scrjrnl}
    [2012/09/16 0.1 A class to write diaries or journals]
\ProvidesClass{scrjrnl}
\DeclareOption{scrartcl}{\def\jrnl@class{scrartcl}}
\DeclareOption{scrreprt}{\def\jrnl@class{scrreprt}}
\DeclareOption{scrbook}{\def\jrnl@class{scrbook}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\jrnl@class}}
\ExecuteOptions{scrbook}
\newif\if@jrnl@chapterpages
\DeclareOption{chapterpages}{\@jrnl@chapterpagestrue}
\newif\if@jrnl@fancytabs
\DeclareOption{fancytabs}{\@jrnl@fancytabstrue}
\ProcessOptions\relax
\LoadClass{\jrnl@class}
\RequirePackage{titlesec}
\AfterPackage!{babel}{\RequirePackage{moredatetime}}
\newcommand\jrnlformatdate\formatdateny
\newlength{\jrnldaysepskip}
\setlength{\jrnldaysepskip}{-\baselineskip}
\newlength{\jrnldayafterskip}
\setlength{\jrnldayafterskip}{\baselineskip}
\if@jrnl@fancytabs
  \RequirePackage{fancytabs}
\fi
\newcommand{\jrnl@monthname}[1]{\monthname[#1]}
\newcommand{\jrnl@curmonth}{\jrnl@monthname{\thejrnlmonth}}
\newcounter{jrnlstartchapter}
\newcounter{jrnlday}
\newcounter{jrnlmonth}
\newcounter{jrnlyear}
\newcommand{\HTMLchapHook}[1]{}
\newcommand{\HTMLsecHook}[2]{}
\newcounter{jrnlmonthstartday}
\define@key{jrnlmonth}{month}{\setcounter{jrnlmonth}{#1}\addtocounter{jrnlmonth}{-1}}
\define@key{jrnlmonth}{startday}{\setcounter{jrnlmonthstartday}{#1}\addtocounter{jrnlmonthstartday}{-1}}

\newcommand{\jrnlmonth}[1][]{%
  % Use \thejrnlstatday if first month of journal
  \setcounter{jrnlmonthstartday}{\thejrnlstartday}%
  \setcounter{jrnlstartday}{0}%
  \setkeys{jrnlmonth}{#1}%
  \stepcounter{jrnlmonth}%
  \HTMLchapHook{\jrnl@curmonth}%
  \if@jrnl@chapterpages
    \chapter{\jrnl@curmonth}%
    \cleardoublepage%
  \else
    \refstepcounter{chapter}%
    \@maybeautodot\thechapter
    \addchaptertocentry{\thechapter}{\jrnl@curmonth}%
  \fi
  \setcounter{jrnlday}{\thejrnlmonthstartday}%
}
\newcommand{\pagedate}{%
  \jrnlformatdate{\thejrnlday}{\thejrnlmonth}{\thejrnlyear}%
}
\define@key{jrnlday}{day}{\setcounter{jrnlday}{#1}\addtocounter{jrnlday}{-1}}
\define@key{jrnlday}{ante}{\def\jrnlday@ante{#1}}
\define@key{jrnlday}{post}{\def\jrnlday@post{#1}}

\newcommand{\jrnlday}[2][]{%
  \def\jrnlday@ante{}%
  \def\jrnlday@post{}%
  \setkeys{jrnlday}{#1}%
  \stepcounter{jrnlday}%
  \newpage\section{#2}%
  % TODO: provide index macros to be used with jrnlpagedate\thepage
  \expandafter\xdef\csname jrnlpagedate\thepage\endcsname{%
    \noexpand\jrnlformatdate{\thejrnlday}{\thejrnlmonth}{\thejrnlyear}%
}%
  \HTMLsecHook{\jrnlday@ante\jrnlformatdate{\thejrnlday}{\thejrnlmonth}{\thejrnlyear}\jrnlday@post}{#2}%
}
\newcommand\dayheadfont{}
\newcommand\monthheadfont{}
\newcommand\jrnl@titlestrut{\vrule height 25pt width0pt\relax}
\newcommand{\jrnl@secstyle}{\filcenter\dayheadfont\huge}
\newcommand{\jrnl@seclbl}{\raggedright\normalfont\scshape\Large\jrnlday@ante\pagedate\jrnlday@post\\}
\newcommand{\jrnl@chapstyle}{\filcenter\monthheadfont\Huge\textsc}
\newcounter{jrnlstartmonth}
\newcounter{jrnlstartday}
\define@key{jrnl}{startmonth}{\setcounter{jrnlstartmonth}{#1}\addtocounter{jrnlstartmonth}{-1}}
\define@key{jrnl}{startday}{\setcounter{jrnlstartday}{#1}\addtocounter{jrnlstartday}{-1}}

\newenvironment{journal}[1][]%
{%
\setcounter{jrnlstartmonth}{0}%
\setcounter{jrnlstartday}{0}%
\setkeys{jrnl}{#1}%
\setcounter{jrnlstartchapter}{\thechapter}
\addtocounter{jrnlmonth}{\thejrnlstartmonth}

\titleformat{\chapter}[block]
  {\vfill}
  {}{0pt}
  {\jrnl@chapstyle}
  [\vfill\vfill]

\if@jrnl@fancytabs
  % Tune section headings and use tabs
  % I'd like that to go inside the devotional environment
  \fancytabsHeight{1.2in}
  % WITHOUT BLEED
  % 6*1.2 + 2*0.6 + 5*0.12 = 9
  %\fancytabsTop{0.6in}
  %\fancytabsGap{0.12in}
  % WITH BLEED
  % 6*1.2 + 2*0.725 + 5*0.12 = 9.25
  \fancytabsTop{0.725in}
  \fancytabsGap{0.12in}

  % WITHOUT BLEED
  % \fancytabsWidth{0.40in}
  % WITH BLEED
  % Add 0.125 for the bleed
  \fancytabsWidth{0.525in}
  % Put text more inside
  % (0.4/2)/0.525 = 0.38
  \fancytabsTextVPos{0.5}
  \fancytabsTextHPos{0.38}

  % Set floor for tabs based on starting chapter
  \fancytabsFloor{\thejrnlstartchapter}

  % Set tabs text style
  % The original version uses uppercase
  %\fancytabsStyle{\Large\MakeUppercase}
  \fancytabsStyle{\normalfont\LARGE\scshape}

  \newcommand{\jrnl@fancytab}{%
    \ifthenelse{\isodd{\thepage}}%
      {\fancytab{\jrnl@curmonth}{\thejrnlmonth}}%
      {}%
  }
\else
  \newcommand{\jrnl@fancytab}{}%
\fi

\titleformat{\section}[display]
  {\jrnl@secstyle} % format
  {\jrnl@seclbl} % label
  {\jrnldaysepskip} %sep
  {\jrnl@fancytab%
   \jrnl@titlestrut\filcenter} %before
  [\vspace{\jrnldayafterskip}] %after

\titlespacing{\section}{0pt}{*}{-3pt}

} % end of \begin{devotional}
{} % end of \end{devotional}
\endinput
%%
%% End of file `scrjrnl.cls'.
