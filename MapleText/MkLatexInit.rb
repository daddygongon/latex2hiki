require 'kconv'
dir_name=File::basename(ARGV[0])
hiki_inLatex=dir_name+"/"+dir_name
puts hiki_file=hiki_inLatex+".tex"
if File.exists?(hiki_file) then
  printf("File %s exists.\n",hiki_file)
  printf("Remove %s manually if you are sure to do this.\n",hiki_file)
  exit(1)
end
file1=File.open(hiki_file,"w")

output = <<'EOF'
\documentclass[10pt,a4j]{jreport}
\usepackage[dvips]{graphicx,color}
\usepackage{tabularx}
\usepackage{verbatim}
\usepackage{amsmath,amsthm,amssymb}
\topmargin -15mm\oddsidemargin -4mm\evensidemargin\oddsidemargin
\textwidth 170mm\textheight 257mm\columnsep 7mm
\setlength{\fboxrule}{0.2ex}
\setlength{\fboxsep}{0.6ex}

\pagestyle{empty}

\newcommand{\MaplePlot}[2]{{\begin{center}
    \includegraphics[width=#1,clip]{#2}
                     \end{center}
%
} }

\newenvironment{MapleInput}{%
    \color{red}\verbatim
}{%
    \endverbatim
}

\newenvironment{MapleError}{%
    \color{blue}\verbatim
}{%
    \endverbatim
}

\newenvironment{MapleOutput}{%
    \color{blue}\begin{equation*}
}{%
    \end{equation*}
}

\newenvironment{MapleOutputGather}{%
    \color{blue}\gather
}{%
    \endgather
}

\newcommand{\ChartElement}[1]{{
\color{magenta}\begin{flushleft}$\left[\left[\left[\textbf{\large #1}\right]\right]\right]$
\end{flushleft}\vspace{-10mm}
} }

\newcommand{\ChartElementTwo}[1]{{
\color{magenta}\begin{flushleft}$\left[\left[\left[\textbf{\large #1}\right]\right]\right]$
\end{flushleft}
} }

\newcommand{\ChartElementThree}[2]{{
\color{magenta}\begin{flushleft}$\left[\left[\left[\textbf{\large #2}\right]\right]\right]$
\end{flushleft}\vspace{#1}
} }

\newif\ifHIKI
%\HIKItrue % TRUEの設定
\HIKIfalse % FALSEの設定
\begin{document}
EOF

output << "\\chapter{(#{ARGV[0]})}\n"
output2 =  <<'EOF'
\section{}
%\input{---.tex}


\end{document}
EOF
output3=NKF.nkf("-s",output)
output3<<NKF.nkf("-s",output2)
file1.print output3
file1.close

