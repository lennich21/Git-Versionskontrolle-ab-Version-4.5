\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{HKA}[2014/08/16 Example LaTeX class]
\LoadClass[a4paper,12pt,fleqn,twoside, numbers=noendperiod]{scrbook}



%------------------------------------------------------------------------
% PACKAGES
%------------------------------------------------------------------------
\RequirePackage[left=3cm, right=3cm, top=3.5cm, bottom=4cm]{geometry}
\RequirePackage{ifthen}
\RequirePackage{ifxetex}
\RequirePackage{etoolbox}

% Provides math enviroments, math symbols and more things useful for math.
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{amscd}

% Enhances amsmath and provides further mathematical tools.
\RequirePackage{mathtools}



%------------------------------------------------------------------------
% COLOR DEFINITIONS
%------------------------------------------------------------------------
\RequirePackage[dvipsnames,svgnames]{xcolor}
\RequirePackage{ragged2e} % for marginnote
\RequirePackage{ccicons} % for titlepage
\definecolor{hka}{RGB}{215,35,5}
\definecolor{shadecolor}{gray}{0.95}
\definecolor{BlueHKA}{rgb}{0.16, 0.41, 0.69}
\definecolor{HKAgray}{RGB}{125,154,170}
\definecolor{HKApurple}{RGB}{76,0,153}
\definecolor{HKAgreen}{RGB}{0,153,76}
\definecolor{KeywordBlue}{RGB}{0,0,204}
\colorlet{mdtBlue}{BlueHKA!50!black}
\colorlet{heading}{black}
\colorlet{cite}{hka}
\colorlet{url}{hka}
\colorlet{ref}{black}
\colorlet{caption}{black}
\colorlet{margincaption}{caption}



%------------------------------------------------------------------------
% MORE PACKAGES
%------------------------------------------------------------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{iflang}
\RequirePackage{csquotes}
\RequirePackage{float}
\RequirePackage[pdfencoding=auto,pdfborderstyle={/S/U/W 1},linkbordercolor=ref,colorlinks,linkcolor=ref,citecolor=cite,urlcolor=url]{hyperref} % Clickable references.
\RequirePackage[all]{hypcap} % Anchors links to the beginning of their respective floats. Load after hyperref.
\RequirePackage[autolang=hyphen, backend=biber, urldate=long, maxbibnames=99, style=numeric, sorting=none]{biblatex}
\RequirePackage[format=plain, labelfont={bf}, labelsep=colon]{caption}



%------------------------------------------------------------------------
% HEADER AND FOOTER
%------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\nouppercase{\leftmark}}
\fancyhead[RO]{\nouppercase{\rightmark}}
\fancyfoot[LE,RO]{\thepage}



%------------------------------------------------------------------------
% LANGUAGE
%------------------------------------------------------------------------
\DeclareRobustCommand{\spacedallcaps}[1]{\textls[160]{\textsc{\MakeTextUppercase{#1}}}}%
\DeclareRobustCommand{\spacedlowsmallcaps}[1]{\textls[80]{\textsc{\MakeTextLowercase{#1}}}}%
\newcommand{\deen}[2]{\IfLanguageName{ngerman}{#1}{#2}}
\newcommand{\setdefaultlanguage}[1]{
    \ifthenelse{\equal{#1}{german}}{
        \usepackage[english,german,ngerman]{babel}  	
        \RequirePackage[noabbrev,capitalize,nameinlink,german]{cleveref} % Names references automatically. Load after hyperref.
    }{
        \usepackage[ngerman,german,english]{babel}
        \RequirePackage[noabbrev,capitalize,nameinlink,english]{cleveref} % Names references automatically. Load after hyperref.
    }
}



%------------------------------------------------------------------------
% DOCUMENT OPTIONS AND LOGO
%------------------------------------------------------------------------
\newcommand{\logo}{\deen{Unbekanntes Logo}{Unknown logo}\vspace{8cm}}
\newcommand{\mmt}{\deen{Fakultät für Maschinenbau und Mechatronik}{Faculty of Mechanical Engineering and Mechatronics}}
\newcommand{\eit}{\deen{Fakultät Elektrotechnik und Informationstechnik}{Faculty of Electrical Engineering and Information Technology}}
\newcommand{\faculty}{\deen{Fehlende Fakultät}{Missing faculty}}

\DeclareOption{EIT}{
	\renewcommand{\logo}{\includegraphics[height=60px]{\deen{logos/HKA_EIT_Wortmarke_CMYK.pdf}{logos/HKA_EIT_Wortmarke_CMYK.pdf}}
	
	\vspace{-60px}\hfill \includegraphics[height=120px]{logos/HKA_EIT_Bildmarke_CMYK.pdf}}
	
	\renewcommand{\faculty}{\eit}
}

\DeclareOption{MMT}{\renewcommand{\logo}{%
	\includegraphics[height=60px]{\deen{logos/HKA_MMT_Wortmarke_CMYK.pdf}{logos/HKA_MMT_Wortmarke_CMYK_engl.pdf}} 
	
	\vspace{-60px}\hfill \includegraphics[height=120px]{logos/HKA_MMT_Bildmarke_CMYK.pdf}}
	
	\renewcommand{\faculty}{\mmt}
}

\DeclareOption{IEEM}{\renewcommand{\logo}{\includegraphics[height=60px]{\deen{logos/HKA_IEEM_Wortmarke_CMYK.pdf}{logos/HKA_IEEM_Wortmarke_CMYK_engl.pdf}}
	
	\vspace{-60px}\hfill \includegraphics[height=120px]{logos/HKA_IEEM_Bildmarke_CMYK.pdf}}

	\renewcommand{\faculty}{\mmt}
}

\ProcessOptions\relax

\RequirePackage{plex-serif}
\RequirePackage{plex-sans}
\RequirePackage{plex-mono}
\RequirePackage{fourier}

% Content only shows chapters and section, but not subsections, etc.
\setcounter{tocdepth}{1}




%------------------------------------------------------------------------
% ALGORITHMS
%------------------------------------------------------------------------

\RequirePackage{xspace}
\RequirePackage{framed}
\RequirePackage{newfloat}
\RequirePackage[noEnd=false]{algpseudocodex}

\newcommand*{\To}{\textbf{to}\xspace}
\newcommand*{\Init}{\State\textbf{init}\xspace}
\newcommand{\listofalgorithmsname}{\deen{Algorithmenverzeichnis}{List of Algorithms}}

\DeclareFloatingEnvironment[
  fileext=loa,
  listname={\listofalgorithmsname},
  name=\deen{Algorithmus}{Algorithm},
  placement=htp,
]{algorithm}



%------------------------------------------------------------------------
% CODE LISTINGS
%------------------------------------------------------------------------
\RequirePackage{listings}
\renewcommand{\lstlistlistingname}{\deen{Programmcodeverzeichnis}{List of Program Codes}}

% set defaults
\lstset{
    language=C++,
    tabsize=4,
    captionpos=b,
    frame=tb,
    keywords={alignas, alignof, and, and_eq, asm, atomic_cance, atomic_commit, atomic_noexcept, auto, bitand, bitor, bool, break, case, catch, char, char8_t, char16_t, char32_t, class, compl, concept, const, consteval, constexpr, constinit, const_cast, continue, co_await, co_return, co_yield, decltype, default, delete, do, double, dynamic_cast, else, enum, explicit, export, extern, false, float, for, friend, goto, if, inline, int, long, mutable, namespace, new, noexcept, not, not_eq, nullptr, operator, or, or_eq, private, protected, public, reflexpr, register, reinterpret_cast,requires, return,short, signed,sizeof, static,static_assert, static_cast,struct, switch,synchronized, template,this, thread_local, throw, true, try, typedef, typeid, typename, union, unsigned, using, virtual, void, volatile, wchar_t, while, xor, xor_eq},
    identifierstyle=\color{black}\ttfamily,
    keywordstyle=\color{KeywordBlue}\ttfamily,
    basicstyle=\footnotesize\ttfamily,
    commentstyle=\color{HKAgray}\ttfamily,
    stringstyle=\color{HKAgreen}\ttfamily,
    numbers=left,
    numberstyle=\color{gray!80}\scriptsize,
    stepnumber=1,
    numbersep=8pt,
    showstringspaces=false,
    breaklines=true,
    belowcaptionskip=.75\baselineskip,
    comment=[l]{//},
    morecomment=[s]{/*}{*/},
    morestring=[b]',
    morestring=[b]",
    literate=*{0}{{\textcolor{hka}{0}}}{1} {1}{{\textcolor{hka}{1}}}{1} {2}{{\textcolor{hka}{2}}}{1} {3}{{\textcolor{hka}{3}}}{1} {4}{{\textcolor{hka}{4}}}{1} {5}{{\textcolor{hka}{5}}}{1} {6}{{\textcolor{hka}{6}}}{1} {7}{{\textcolor{hka}{7}}}{1} {8}{{\textcolor{hka}{8}}}{1} {9}{{\textcolor{hka}{9}}}{1}
}



%------------------------------------------------------------------------
% SPECIAL CHAPTERS
%------------------------------------------------------------------------

\makeatletter

\newcommand{\abstract}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Zusammenfassung}}{\chapter{Abstract}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\zusammenfassung}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Abstract}}{\chapter{Zusammenfassung}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\furtherpublications}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Weitere Publikationen}}{\chapter{Further Publications}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\publications}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Publikationen}}{\chapter{Publications}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\acknowledge}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Danksagung}}{\chapter{Acknowledgments}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\symbollist}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Symbolverzeichnis}}{\chapter{List of Symbols}}
    #1
    \cleardoublepage
\endgroup}

\newcommand{\abbrevations}[1]{\begingroup
    \cleardoublepage
    \deen{\chapter{Abkürzungsverzeichnis}}{\chapter{List of Abbrevations}}
    #1
    \cleardoublepage
\endgroup}
\makeatother


		
%------------------------------------------------------------------------
% TITLEPAGE
%------------------------------------------------------------------------
\newcommand{\projectbachelor}{\deen{Entwicklungsprojekt (Bachelor)}{Development Project (Bachelor)}}
\newcommand{\projectmaster}{\deen{Entwicklungsprojekt (Master)}{Development Project (Master)}}
\newcommand{\firstprojectmaster}{\deen{Forschungs- und Entwicklungsprojekt 1 (Master)}{Development and Research Project 1 (Master)}}
\newcommand{\secondprojectmaster}{\deen{Forschungs- und Entwicklungsprojekt 2 (Master)}{Development and Research Project 2 (Master)}}
\newcommand{\bachelorthesis}{\deen{Bachelorthesis}{Bachelor Thesis}}
\newcommand{\masterthesis}{\deen{Masterthesis}{Master Thesis}}
\newcommand{\dissertation}{Dissertation}


\makeatletter	
\newcommand\thesistype[1]{\renewcommand\@thesistype{#1}}
\newcommand\@thesistype{\deen{Unbekannter Typ}{Unknown type}}

\newcommand\timeframe[1]{\renewcommand\@timeframe{#1}}
\newcommand\@timeframe{\deen{Fehlender Bearbeitungszeitraum}{Missing time frame}}

\newcommand\studentnumber[1]{\renewcommand\@studentnumber{#1}}
\newcommand\@studentnumber{\deen{Fehlende Matrikelnummer}{Missing student number}}

\newcommand\institute[1]{\renewcommand\@institute{#1}}
\newcommand\@institute{\deen{Institut für Energieeffiziente Mobilität}{Institute of Energy Efficient Mobility}}


\newcommand\authors[6]{
	\renewcommand\@firstauthor{#1}
	\renewcommand\@secondauthor{#2}
	\renewcommand\@thirdauthor{#3}
	\renewcommand\@fourthauthor{#4}
	\renewcommand\@fifthauthor{#5}
	\renewcommand\@sixthauthor{#6}
}
\newcommand\@firstauthor{}
\newcommand\@secondauthor{}
\newcommand\@thirdauthor{}
\newcommand\@fourthauthor{}
\newcommand\@fifthauthor{}
\newcommand\@sixthauthor{}

\newcommand\studentnumbers[6]{
	\renewcommand\@firstnumber{#1}
	\renewcommand\@secondnumber{#2}
	\renewcommand\@thirdnumber{#3}
	\renewcommand\@fourthnumber{#4}
	\renewcommand\@fifthnumber{#5}
	\renewcommand\@sixthnumber{#6}
}
\newcommand\@firstnumber{}
\newcommand\@secondnumber{}
\newcommand\@thirdnumber{}
\newcommand\@fourthnumber{}
\newcommand\@fifthnumber{}
\newcommand\@sixthnumber{}

\newcommand\@listauthors{
	\ifdefempty{\@firstauthor}{}{\@firstauthor}%
	\ifdefempty{\@secondauthor}{}{,\\\@secondauthor}%	
	\ifdefempty{\@thirdauthor}{}{,\\\@thirdauthor}%	
	\ifdefempty{\@fourthauthor}{}{,\\\@fourthauthor}%	
	\ifdefempty{\@fifthauthor}{}{,\\\@fifthauthor}%	
	\ifdefempty{\@sixthauthor}{}{,\\\@sixthauthor}%
	\\			
}

\newcommand\@listauthorshorizontally{
	\ifdefempty{\@firstauthor}{}{\@firstauthor}%
	\ifdefempty{\@secondauthor}{}{, \@secondauthor}%	
	\ifdefempty{\@thirdauthor}{}{, \@thirdauthor}%	
	\ifdefempty{\@fourthauthor}{}{, \@fourthauthor}%	
	\ifdefempty{\@fifthauthor}{}{, \@fifthauthor}%	
	\ifdefempty{\@sixthauthor}{}{, \@sixthauthor}%
}

\newcommand\@listauthorsandnumbers{
	\ifdefempty{\@firstauthor}{}{\hspace{1cm} \@firstauthor, \deen{Matrikelnummer}{student number} \@firstnumber}%
	\ifdefempty{\@secondauthor}{}{,\\ \vspace{\baselineskip} \hspace{1cm} \@secondauthor, \deen{Matrikelnummer}{student number} \@secondnumber}%	
	\ifdefempty{\@thirdauthor}{}{,\\ \vspace{\baselineskip} \hspace{1cm} \@thirdauthor, \deen{Matrikelnummer}{student number} \@thirdnumber}%	
	\ifdefempty{\@fourthauthor}{}{,\\ \vspace{\baselineskip} \hspace{1cm} \@fourthauthor, \deen{Matrikelnummer}{student number} \@fourthnumber}%	
	\ifdefempty{\@fifthauthor}{}{,\\ \vspace{\baselineskip} \hspace{1cm} \@fifthauthor, \deen{Matrikelnummer}{student number} \@fifthnumber}%	
	\ifdefempty{\@sixthauthor}{}{,\\ \vspace{\baselineskip} \hspace{1cm} \@sixthauthor, \deen{Matrikelnummer}{student number} \@sixthnumber}%
	\\			
}


\newcommand\dean[1]{\renewcommand\@dean{#1}}
\newcommand\@dean{}

\newcommand\firstexaminer[3]{
	\renewcommand\@firstexaminer{#1}
	\renewcommand\@firstinstitute{#2}
	\renewcommand\@firstuniversity{#3}
}
\newcommand\@firstexaminer{}
\newcommand\@firstinstitute{}
\newcommand\@firstuniversity{}

\newcommand\secondexaminer[3]{
	\renewcommand\@secondexaminer{#1}
	\renewcommand\@secondinstitute{#2}
	\renewcommand\@seconduniversity{#3}
}
\newcommand\@secondexaminer{}
\newcommand\@secondinstitute{}
\newcommand\@seconduniversity{}

\newcommand\thirdexaminer[3]{
	\renewcommand\@thirdexaminer{#1}
	\renewcommand\@thirdinstitute{#2}
	\renewcommand\@thirduniversity{#3}
}
\newcommand\@thirdexaminer{}
\newcommand\@thirdinstitute{}
\newcommand\@thirduniversity{}

\newcommand\attributions[1]{\renewcommand\@attributions{#1}}
\newcommand\@attributions{}

\newcommand\license[1]{\renewcommand\@license{#1}}
\newcommand\@license{\ccby}

\newcommand\submissiondate[1]{\renewcommand\@submissiondate{#1}}
\newcommand\@submissiondate{\deen{Fehlendes Abgabedatum}{Missing submission date}}

\newcommand\place[1]{\renewcommand\@place{#1}}
\newcommand\@place{\deen{Fehlender Herkunftsort}{Missing place}}		

\newcommand\academicdegreeshort[1]{\renewcommand\@academicdegreeshort{#1}}
\newcommand\@academicdegreeshort{\deen{Fehlender Titel (kurz)}{Missing short title}}

\newcommand\academicdegreefull[1]{\renewcommand\@academicdegreefull{#1}}
\newcommand\@academicdegreefull{\deen{Fehlender Titel (lang)}{Missing long title}}			


% DECLARATION OF INDIPENDENCE
\newcommand\independencedeclaration[1]{\renewcommand\@independencedeclaration{#1}}
\newcommand\@independencedeclaration{{\begingroup%
    \pagebreak%
    \thispagestyle{empty}%

    \begin{center}
	\Large\deen{\textbf{Erklärung}}{\textbf{Declaration of Independence}}
    \end{center}

    \noindent%
    \deen{Hiermit versichere ich, dass ich die vorliegende Arbeit mit dem Titel}{I hereby declare that this thesis titled:}
    \begin{center}
      \textbf{\@title}
    \end{center}
    \deen{selbstständig angefertigt, alle benutzten Hilfsmittel vollständig und genau angegeben und alles einzeln kenntlich gemacht zu haben, was aus Arbeiten anderer unverändert oder mit Abänderungen entnommen wurde.}{
	was written independently, that I have listed all resources completely and accurately, and that I have indicated everything that has been adopted unchanged or modified from the work of others.}

    \begin{flushleft}
      \deen{Karlsruhe, den}{Karlsruhe, } \@submissiondate

      \vspace{2cm} 
      \@listauthorsandnumbers
    \end{flushleft}

    \vspace{2cm}
    \endgroup}
}


% CC LICENSE URLS
\newcommand{\ccurl}{%
    \expandafter\ifx\@license\cczero\deen{\url{https://creativecommons.org/publicdomain/zero/1.0/deed.de}}{\url{https://creativecommons.org/publicdomain/zero/1.0/}}\else%
    \expandafter\ifx\@license\ccbysa\deen{\url{https://creativecommons.org/licenses/by-sa/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by-sa/4.0/}}\else%
    \expandafter\ifx\@license\ccbynd\deen{\url{https://creativecommons.org/licenses/by-nd/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by-nd/4.0/}}\else%
    \expandafter\ifx\@license\ccbync\deen{\url{https://creativecommons.org/licenses/by-nc/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by-nc/4.0/}}\else%
    \expandafter\ifx\@license\ccbyncsa\deen{\url{https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by-nc-sa/4.0/}}\else%
    \expandafter\ifx\@license\ccbyncnd\deen{\url{https://creativecommons.org/licenses/by-nc-nd/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by-nc-nd/4.0/}}\else%
    \expandafter\ifx\@license\ccby\deen{\url{https://creativecommons.org/licenses/by/4.0/deed.de}}{\url{https://creativecommons.org/licenses/by/4.0/}}\else%
    \colorbox{red}{Error: Invalid license!}\fi\fi\fi\fi\fi\fi\fi
}


% CC LICENSE STATEMENT
\newcommand\@ccLicense{
	{\begingroup%
            \footnotesize%
            \@attributions%
            \par\vspace*{\fill}%
            \noindent \textcopyright\ \the\year\ \@listauthorshorizontally
            \begin{tabbing}%
                \hspace*{6em} \= \kill
                \deen{Fassung}{Issued}: \> \today\\
                \\
                \parbox{6em}{\normalsize\expandafter\ifx\@license\ccCopy~\else\@license\fi}
                \> \expandafter\ifx\@license\ccCopy~\else\parbox[t]{0.85\textwidth}{\raggedright
                    \deen{Dieses Werk ist unter einer Creative Commons Lizenz vom Typ}{This work is licensed under a Creative Commons}
                    \expandafter\ifx\@license\cczero\deen{Kein Urheberrechtsschutz}{Public Domain}\else%
                    \expandafter\ifx\@license\ccbysa\deen{Namensnennung - Weitergabe unter gleichen Bedingungen}{Attribution-ShareAlike}\else%
                    \expandafter\ifx\@license\ccbynd\deen{Namensnennung - Keine Bearbeitung}{Attribution-NoDerivatives}\else%
                    \expandafter\ifx\@license\ccbync\deen{Namensnennung - Nicht kommerziell}{Attribution-NonCommercial}\else%
                    \expandafter\ifx\@license\ccbyncsa\deen{Namensnennung - Nicht-kommerziell - Weitergabe unter gleichen Bedingungen}{Attribution-NonCommercial-ShareAlike}\else%
                    \expandafter\ifx\@license\ccbyncnd\deen{Namensnennung - Nicht-kommerziell - Keine Bearbeitung}{Attribution-NonCommercial-NoDerivatives}\else%
                    \expandafter\ifx\@license\ccby\deen{Namensnennung}{Attribution}\else\colorbox{red}{Error: Invalid license!}
                    \fi\fi\fi\fi\fi\fi\fi
                    \deen{ zugänglich}{ License}.\\[.5em]
                    \deen{Um eine Kopie dieser Lizenz einzusehen, konsultieren Sie}{To view a copy of this license, visit} \ccurl
                    \deen{ oder wenden Sie sich brieflich an}{ or send a letter to} Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.}\fi\\
            \end{tabbing}
        \endgroup}
}



% NON DISCLOSURE STATEMENT
\newcommand\nonDisclosure[2]{
	\renewcommand\@nonDisclosure{
		{\begingroup%
			\par\vspace*{\fill}%
			\noindent
			\begin{center}
				\Large\deen{\textbf{Sperrvermerk}}{\textbf{Non-Disclosure Agreement}}
			\end{center}	
			\deen{Diese Arbeit enthält vertrauliche Informationen. Veröffentlichungen insbesondere vor dem #1 bedürfen der schriftlichen Genehmigung der #2.}
				{This work contains confidential information. Publication, in particular before the #1, requires the written permission of the #2.} 
        	\endgroup}
	}
}

\newcommand\@nonDisclosure{}



% EXAMINERS
\newcommand\deanexists{
	\ifdefempty{\@dean}{ }{\textbf{\deen{Dekan(in):}{Acting Dean:}}}
}

\newcommand\thirdrefexists{
	\ifdefempty{\@thirdexaminer}{ }{\textbf{\deen{Dritte(r) Gutachter(in):}{Third Examiner:}}}
}

\newcommand\@examiners{
	{\begingroup%
            \pagebreak%
            \thispagestyle{empty}%
	    \begin{tabular}{ll}
		\deanexists  									& {\color{hka}{\@dean}} \\
													& \\
		\textbf{\deen{Erste(r) Gutachter(in):}{First Examiner:}} 	& {\color{hka}{\@firstexaminer}} \\
												 	& \@firstinstitute \\
						    						 	& \@firstuniversity \\
												 	& \\
		\textbf{\deen{Zweite(r) Gutachter(in):}{Second Examiner:}}	& {\color{hka}{\@secondexaminer}} \\
												     	& \@secondinstitute \\ 
												     	& \@seconduniversity \\
												     	& \\
		\thirdrefexists									& {\color{hka}{\@thirdexaminer}} \\
													& \@thirdinstitute \\
													& \@thirduniversity \\
           
	    \end{tabular}		
        \endgroup}
}


% TITLEPAGE OPTIONS
\newcommand{\@dissertationtitlepage}{
	{\begingroup%
		\thispagestyle{empty}
		\logo
		\vspace{0.5cm}	
		\sffamily
		\begin{center}
			{\LARGE \textbf{\@title}} \\
			\vspace{2cm}
			{\Large \@thesistype} \\
			\vspace{0.7cm}
			\deen{zur Erlangung des akademischen Grades}{to obtain the academic degree} \\
			\vspace{0.3cm}
			{\Large \@academicdegreefull} \\
			\vspace{0.15cm}
			{\Large (\@academicdegreeshort)} \\
			\vspace{1.5cm}
			\deen{am}{at the} \@institute \\
			\faculty \\
			\deen{Hochschule Karlsruhe - University of Applied Sciences}{Karlsruhe University of Applied Sciences} \\
			\vspace{1cm}
			{\Large\@listauthors} 
			\vspace{0.1cm}
			\deen{aus}{from} \@place \\
			\vspace{1cm}
			\@submissiondate
		\end{center}
	\endgroup}
}


\newcommand{\@thesistitlepage}{
	{\begingroup%
		\thispagestyle{empty}
		\logo
		\vspace{0.5cm}	
		\sffamily
		\begin{center}
			{\LARGE \textbf{\@title}} \\
			\vspace{2cm}
			{\Large \@thesistype} \\
			\vspace{0.7cm}
			\deen{zur Erlangung des akademischen Grades}{to obtain the academic degree} \\
			\vspace{0.3cm}
			{\Large \@academicdegreefull} \\
			\vspace{0.15cm}
			{\Large (\@academicdegreeshort)} \\
			\vspace{1.5cm}
			\deen{am}{at the} \@institute \\
			\faculty \\
			\deen{Hochschule Karlsruhe - University of Applied Sciences}{Karlsruhe University of Applied Sciences} \\
			\vspace{1cm}
			{\Large\@listauthors} 
			\vspace{0.1cm}
			\deen{aus}{from} \@place \\
			\vspace{1cm}
			\@timeframe
		\end{center}
	\endgroup}
}


\newcommand{\@projecttitlepage}{
	{\begingroup%
		\thispagestyle{empty}
		\logo
		\vspace{0.5cm}	
		\sffamily
		\begin{center}
			{\LARGE \textbf{\@title}} \\
			\vspace{2cm}
			{\Large \@thesistype} \\
			\vspace{1.5cm}
			\deen{am}{at the} \@institute \\
			\faculty \\
			\deen{Hochschule Karlsruhe - University of Applied Sciences}{Karlsruhe University of Applied Sciences} \\
			\vspace{1cm}
			{\Large\@listauthors} 
			\vspace{1cm}
			\@timeframe
		\end{center}
	\endgroup}
}


\newcommand{\@defaulttitlepage}{
	{\begingroup%
		\thispagestyle{empty}
		\logo
		\vspace{0.5cm}	
		\sffamily
		\begin{center}
			{\LARGE \textbf{\@title}} \\
			\vspace{2cm}
			{\Large \@thesistype} \\
			\vspace{1.5cm}
			\deen{am}{at the} \@institute \\
			\faculty \\
			\deen{Hochschule Karlsruhe - University of Applied Sciences}{Karlsruhe University of Applied Sciences} \\
			\vspace{1cm}
			{\Large\@listauthors}
			\vspace{1cm}
			\@timeframe
		\end{center}
	\endgroup}
}


\newcommand{\@createtitlepage}{%
    \expandafter\ifx\@thesistype\dissertation\@dissertationtitlepage\else%
    \expandafter\ifx\@thesistype\masterthesis\@thesistitlepage\else%
    \expandafter\ifx\@thesistype\bachelorthesis\@thesistitlepage\else%
    \expandafter\ifx\@thesistype\projectmaster\@projecttitlepage\else%
    \expandafter\ifx\@thesistype\projectbachelor\@projecttitlepage\else%
    \expandafter\ifx\@thesistype\firstprojectmaster\@projecttitlepage\else%
    \expandafter\ifx\@thesistype\secondprojectmaster\@projecttitlepage\else%
    \defaulttitlepage\fi\fi\fi\fi\fi\fi\fi
}


% TITLEPAGE
\renewcommand{\maketitle}{%
	\@createtitlepage
	\@examiners
	\@ccLicense
    	\@independencedeclaration	
	\@nonDisclosure
	\rmfamily
	\cleardoublepage
}

\makeatother

