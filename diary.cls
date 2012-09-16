\NeedsTeXFormat{LaTeX2e}[2012/09/13]
\ProvidesClass{diary}
\DeclareOption{scrartcl}{\def\diary@class{scrartcl}}
\DeclareOption{scrreprt}{\def\diary@class{scrreprt}}
\DeclareOption{scrbook}{\def\diary@class{scrbook}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\diary@class}}
\ExecuteOptions{scrbook}
\newif\if@diary@chapterpages
\DeclareOption{chapterpages}{\@diary@chapterpagestrue}
\newif\if@diary@fancytabs
\DeclareOption{fancytabs}{\@diary@fancytabstrue}
\ProcessOptions\relax
\LoadClass{\diary@class}

% Tune headings
\RequirePackage{titlesec}

% How to format dates
\AfterPackage!{babel}{\RequirePackage{moredatetime}}
\newcommand\diaryformatdate\formatdateny

% Set default lengths
\newlength{\diarydaysepskip}
\setlength{\diarydaysepskip}{-\baselineskip}
\newlength{\diarydayafterskip}
\setlength{\diarydayafterskip}{\baselineskip}

% fancytabs
\if@diary@fancytabs
  \RequirePackage{fancytabs}
\fi

% Need to wrap to make \noexpand work
\newcommand{\diary@monthname}[1]{\monthname[#1]}
\newcommand{\diary@curmonth}{\diary@monthname{\thediarymonth}}

\newcounter{diarystartchapter}
\newcounter{diaryday}
\newcounter{diarymonth}
\newcounter{diaryyear}

% Title display in HTML
\newcommand{\HTMLchapHook}[1]{}
\newcommand{\HTMLsecHook}[2]{}


% Define useful aliases
\newcounter{diarymonthstartday}
\define@key{diarymonth}{month}{\setcounter{diarymonth}{#1}\addtocounter{diarymonth}{-1}}
\define@key{diarymonth}{startday}{\setcounter{diarymonthstartday}{#1}\addtocounter{diarymonthstartday}{-1}}

\newcommand{\diarymonth}[1][]{%
  % Use \thediarystatday if first month of diary
  \setcounter{diarymonthstartday}{\thediarystartday}%
  \setcounter{diarystartday}{0}%
  \setkeys{diarymonth}{#1}%
  \stepcounter{diarymonth}%
  \HTMLchapHook{\diary@curmonth}%
  \if@diary@chapterpages
    \chapter{\diary@curmonth}%
    \cleardoublepage%
  \else
    \refstepcounter{chapter}%
    \@maybeautodot\thechapter
    \addchaptertocentry{\thechapter}{\diary@curmonth}%
  \fi
  \setcounter{diaryday}{\thediarymonthstartday}%
}

% Page date
\newcommand{\pagedate}{%
  \diaryformatdate{\thediaryday}{\thediarymonth}{\thediaryyear}%
}

% Index day counter
\define@key{diaryday}{day}{\setcounter{diaryday}{#1}\addtocounter{diaryday}{-1}}
\define@key{diaryday}{ante}{\def\diaryday@ante{#1}}
\define@key{diaryday}{post}{\def\diaryday@post{#1}}

\newcommand{\diaryday}[2][]{%
  \def\diaryday@ante{}%
  \def\diaryday@post{}%
  \setkeys{diaryday}{#1}%
  \stepcounter{diaryday}%
  \newpage\section{#2}%
  \expandafter\xdef\csname diarypagedate\thepage\endcsname{%
    \noexpand\diaryformatdate{\thediaryday}{\thediarymonth}{\thediaryyear}%
}%
  \HTMLsecHook{\diaryday@ante\diaryformatdate{\thediaryday}{\thediarymonth}{\thediaryyear}\diaryday@post}{#2}%
}

% Fonts
\newcommand\dayheadfont{}
\newcommand\monthheadfont{}

% Chapter/section style
\newcommand\diary@titlestrut{\vrule height 25pt width0pt\relax}
\newcommand{\diary@secstyle}{\filcenter\dayheadfont\huge}
\newcommand{\diary@seclbl}{\raggedright\normalfont\scshape\Large\diaryday@ante\pagedate\diaryday@post\\}
\newcommand{\diary@chapstyle}{\filcenter\monthheadfont\Huge\textsc}

\newcounter{diarystartmonth}
\newcounter{diarystartday}
\define@key{diary}{startmonth}{\setcounter{diarystartmonth}{#1}\addtocounter{diarystartmonth}{-1}}
\define@key{diary}{startday}{\setcounter{diarystartday}{#1}\addtocounter{diarystartday}{-1}}

\newenvironment{diary}[1][]%
{%
\setcounter{diarystartmonth}{0}%
\setcounter{diarystartday}{0}%
\setkeys{diary}{#1}%
\setcounter{diarystartchapter}{\thechapter}
\addtocounter{chapter}{\thediarystartmonth}
\addtocounter{diarymonth}{\thediarystartmonth}


% Set chapter pages
\titleformat{\chapter}[block]
  {\vfill}
  {}{0pt}
  {\diary@chapstyle}
  [\vfill\vfill]


% Fancytabs
\if@diary@fancytabs
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
  \fancytabsFloor{\thediarystartchapter}
  
  % Set tabs text style
  % The original version uses uppercase
  %\fancytabsStyle{\Large\MakeUppercase}
  \fancytabsStyle{\normalfont\LARGE\scshape}

  \newcommand{\diary@fancytab}{%
    \ifthenelse{\isodd{\thepage}}%
      {\fancytab{\diary@curmonth}{\arabic{chapter}}}%
      {}%
  }
\else
  \newcommand{\diary@fancytab}{}% 
\fi

\titleformat{\section}[display]
  {\diary@secstyle} % format
  {\diary@seclbl} % label
  {\diarydaysepskip} %sep
  {\diary@fancytab%
   \diary@titlestrut\filcenter} %before
  [\vspace{\diarydayafterskip}] %after

\titlespacing{\section}{0pt}{*}{-3pt}

} % end of \begin{devotional}
{} % end of \end{devotional}
