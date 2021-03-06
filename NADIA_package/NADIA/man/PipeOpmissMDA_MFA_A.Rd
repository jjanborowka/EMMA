% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PipeOpmissMDA_MFA_A.R
\name{PipeOpmissMDA_MFA_A}
\alias{PipeOpmissMDA_MFA_A}
\alias{PipeOpMissMDA_MFA_A}
\title{PipeOpmissMDA_MFA_A}
\description{
Implements MFA methods as mlr3 pipeline in A approche , more about MFA \code{\link{missMDA_MFA}} and \code{\link{missMDA.reuse}}
}
\section{Input and Output Channels}{

Input and output channels are inherited from \code{\link{PipeOpImpute}}.
}

\section{Parameters}{

The parameters include inherited from [`PipeOpImpute`], as well as: \cr
\itemize{
\item \code{id} :: \code{character(1)}\cr
Identifier of resulting object, default \code{"imput_missMDA_MFA"}.
\item \code{ncp} :: \code{integer(1)}\cr
Number of dimensions used by algorithm, default \code{2}.
\item \code{maxiter} :: \code{integer(1)}\cr
Maximal number of iteration in algorithm, default \code{998}.
\item \code{coeff.ridge} :: \code{integer(1)}\cr
Value used in \emph{Regularized} method, default \code{1}.
\item \code{threshold} :: \code{double(1)}\cr
Threshold for convergence, default \code{1e-06}.
\item \code{method} :: \code{character(1)}\cr
Method used in imputation algorithm, default \code{'Regularized'}.
\item \code{out_fill} :: \code{character(1)}\cr
Output log file location. If file already exists log message will be added. If NULL no log will be produced, default \code{NULL}.
}
}

\examples{
\donttest{

 # Using debug learner for example purpose

  graph <- PipeOpMissMDA_MFA_A$new() \%>>\% LearnerClassifDebug$new()
  graph_learner <- GraphLearner$new(graph)

  # Task with NA

  resample(tsk("pima"), graph_learner, rsmp("cv", folds = 3))
}
}
\section{Super classes}{
\code{\link[mlr3pipelines:PipeOp]{mlr3pipelines::PipeOp}} -> \code{\link[mlr3pipelines:PipeOpImpute]{mlr3pipelines::PipeOpImpute}} -> \code{missMDA_MFAimputation_A}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{PipeOpMissMDA_MFA_A$new()}}
\item \href{#method-clone}{\code{PipeOpMissMDA_MFA_A$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="predict">}\href{../../mlr3pipelines/html/PipeOp.html#method-predict}{\code{mlr3pipelines::PipeOp$predict()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="print">}\href{../../mlr3pipelines/html/PipeOp.html#method-print}{\code{mlr3pipelines::PipeOp$print()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="train">}\href{../../mlr3pipelines/html/PipeOp.html#method-train}{\code{mlr3pipelines::PipeOp$train()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PipeOpMissMDA_MFA_A$new(
  id = "impute_missMDA_MFA_A",
  ncp = 2,
  maxiter = 998,
  coeff.ridge = 1,
  threshold = 1e-06,
  method = "Regularized",
  out_file = NULL
)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PipeOpMissMDA_MFA_A$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
