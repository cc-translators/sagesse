\NeedsTeXFormat{LaTeX2e}[2012/09/13]
\ProvidesClass{diary}
\DeclareOption{scrartcl}{\def\diary@class{scrartcl}}
\DeclareOption{scrreprt}{\def\diary@class{scrreprt}}
\DeclareOption{scrbook}{\def\diary@class{scrbook}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\diary@class}}
\ExecuteOptions{scrbook}
\newif\if@diary@chapterpages
\DeclareOption{chapterpages}{\@diary@chapterpagestrue}
\ProcessOptions\relax
\LoadClass{\diary@class}


% How to format dates
% TODO: Make it an option
\usepackage[french]{babel}
\usepackage{moredatetime}
\let\diaryformatdate\formatdateny

% TODO: make fancytabs an option
\usepackage{fancytabs}

% Need to wrap to make \noexpand work
\newcommand{\diary@monthname}[1]{\monthname[#1]}
\newcommand{\diary@curmonth}{\diary@monthname{\thediarymonth}}

\newcounter{diarystartchapter}
\newcounter{diarymonth}

% Define useful aliases
\newcommand{\diarymonth}{%
%  \ifx\@dv@nochecksec\@empty
%    \addtocounter{pageoverflow}{2}%
%    \ifthenelse{\arabic{pageoverflow}<\thepage}{%
%      \GenericError{}{Section longer than one page before page \thepage!}{}{}%
%    }{}%
%  \fi
%  \setcounter{pageoverflow}{\thepage}%
%  \addtocounter{pageoverflow}{1}%
  \stepcounter{diarymonth}%
  \HTMLchapHook{\diary@curmonth}%
  \if@diary@chapterpages
  \chapter{\diary@curmonth}%
    \cleardoublepage%
  \else
    \renewcommand\chaphead{\diary@curmonth}%
    \refstepcounter{chapter}%
    \@maybeautodot\thechapter
    \addchaptertocentry{\thechapter}{\diary@curmonth}%
  \fi
}

% Index day counter

\newcommand{\diaryday}[2][\normalfont]{\newpage\section{#2}%
\expandafter\xdef\csname diarypagedate\thepage\endcsname{%
  \noexpand\diaryformatdate{\thesection}{\thediarymonth}{0}% expand \thesection and \thediarymonth, transform to date later
}%
\HTMLsecHook{\diaryformatdate{\thesection}{\thediarymonth}{0}}{#2}%
%\ifx\@diary@nochecksec\@empty
%  \addtocounter{pageoverflow}{1}%
%  \ifthenelse{\arabic{pageoverflow}=\thepage}{}{%
%    \GenericError{}{Section longer than one page before page \thepage!}{}{}%
%  }%
%\fi
#1%
}

\newcommand\titlestrut{\vrule height 25pt width0pt\relax}
\newcommand{\secstyle}{\filcenter\dayheadfont\huge}
\newcommand{\seclbl}{\raggedright\normalfont\scshape\Large\pagedate\\}

\newenvironment{diary}%
{%
% Counter to test that pages do not overflow
%\newcounter{pageoverflow}%
%\setcounter{pageoverflow}{\thepage}%
%\addtocounter{pageoverflow}{-1}%
% Reset chapter counter for tabs
%\setcounter{chapter}{0}
\pagestyle{empty}
\renewcommand*{\partpagestyle}{empty}
\renewcommand*{\chapterpagestyle}{empty}
% Record the starting chapter of the devotional
\setcounter{diarystartchapter}{\arabic{chapter}}



% Set chapter pages
\titleformat{\chapter}[block]
  {\vfill\monthheadfont}
  {}{10pt}
  {\filcenter}
  [\vfill\vfill]


% Fancytabs
% TODO: make it an option
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

\renewcommand\thesection{\arabic{section}}
% Make a different style to use in CSS

\titleformat{\section}[display]
  {\secstyle} % format
  {\seclbl} % label
  {-15pt} %sep
  {
  \ifthenelse{\isodd{\thepage}}%
    {\fancytab{\chaphead}{\arabic{chapter}}}%
    {}%
  \titlestrut\filcenter} %before
\titlespacing{\section}{0pt}{*}{-3pt}

} % end of \begin{devotional}
{} % end of \end{devotional}
