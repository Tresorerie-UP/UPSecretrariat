%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Copyright (c) 2011 Trey Hunner                                          %
%                                                                          %
%  Permission is hereby granted, free of charge, to any person obtaining   %
%  a copy of this software and associated documentation files (the         %
%  "Software"), to deal in the Software without restriction, including     %
%  without limitation the rights to use, copy, modify, merge, publish,     %
%  distribute, sublicense, and/or sell copies of the Software, and to      %
%  permit persons to whom the Software is furnished to do so, subject to   %
%  the following conditions:                                               %
%                                                                          %
%  The above copyright notice and this permission notice shall be          %
%  included in all copies or substantial portions of the Software.         %
%                                                                          %
%  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         %
%  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      %
%  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                   %
%  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE  %
%  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION  %
%  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION   %
%  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.         %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{invoice}

\LoadClass[12pt]{article}

\usepackage[letterpaper,hmargin=0.79in,vmargin=0.79in]{geometry}
\usepackage[parfill]{parskip} % Do not indent paragraphs
\usepackage{fp} % Fixed-point arithmetic
\usepackage{calc} % Counters for totaling hours and cost
\usepackage{longtable}
\usepackage[utf8]{inputenc}

\pagestyle{empty} % No page numbers
\linespread{1.5} % Line spacing

\setlength{\doublerulesep}{\arrayrulewidth} % Double rules look like one thick one

% Command for setting a default hourly rate
\newcommand{\feetype}[1]{
    \textbf{#1}
    \\
}

% Counters for totaling up hours and dollars
\newcounter{heures} \newcounter{subhours} \newcounter{cost} \newcounter{subcost}
\setcounter{heures}{0} \setcounter{subhours}{0} \setcounter{cost}{0} \setcounter{subcost}{0}

% Formats inputed number with 2 digits after the decimal place
\newcommand*{\formatNumber}[1]{\FPround{\cost}{#1}{2}\cost} %

% Returns the total of counter
\newcommand*{\total}[1]{\FPdiv{\t}{\arabic{#1}}{1000}\formatNumber{\t}}

% Create an invoice table
\newenvironment{invoiceTable}{
    % Create a new row from title, unit quantity, unit rate, and unit name
    \newcommand*{\unitrow}[4]{%
         \addtocounter{cost}{1000 * \real{##2} * \real{##3}}%
         \addtocounter{subcost}{1000 * \real{##2} * \real{##3}}%
         ##1 & \formatNumber{##2} ##4 & \formatNumber{##3} & \FPmul{\cost}{##2}{##3}\formatNumber{\cost}%
         \\
    }
    % Create a new row from title and expense amount
    \newcommand*{\feerow}[2]{%
         \addtocounter{cost}{1000 * \real{##2}}%
         \addtocounter{subcost}{1000 * \real{##2}}%
         ##1 & & \formatNumber{##2} & \FPmul{\cost}{##2}{1}\formatNumber{\cost}%
         \\
    }

    \newcommand{\subtotalNoStar}{
        {\bf Sous-total} & {\bf \total{subhours} hours} &  & {\bf CHF \total{subcost}}
        \setcounter{subcost}{0}
        \setcounter{subhours}{0}
        \\*[1.5ex]
    }
    \newcommand{\subtotalStar}{
        {\bf Sous-total} & & & {\bf \total{subcost}}
        \setcounter{subcost}{0}
        \\*[1.5ex]
    }
    \newcommand{\subtotal}{
         \hline
         \@ifstar
         \subtotalStar%
         \subtotalNoStar%
    }

    % Create a new row from date and hours worked (use stored fee type and hourly rate)
    \newcommand*{\hourrow}[3]{%
        \addtocounter{heures}{1000 * \real{##2}}%
        \addtocounter{subhours}{1000 * \real{##2}}%
        \unitrow{##1}{##2}{##3}{heures}%
    }
    \newcommand*{\itemrow}[3]{%
        \addtocounter{heures}{1000 * \real{##2}}%
        \addtocounter{subhours}{1000 * \real{##2}}%
        \unitrow{##1}{##2}{##3}{}%
    }
    \renewcommand{\tabcolsep}{0.8ex}
    \setlength\LTleft{0pt}
    \setlength\LTright{0pt}
    \begin{longtable}{@{\extracolsep{\fill}\hspace{\tabcolsep}} l r r r }
    \hline
    {\bf Description} & \multicolumn{1}{c}{\bf Qté} & \multicolumn{1}{c}{\bf Prix unit.} & \multicolumn{1}{c}{\bf Montant HT} \\*
    \hline\hline
    \endhead
}{
    \hline\hline\hline
    {\bf Total TTC} & & & {\bf CHF \total{cost}} \\
    \end{longtable}
}
