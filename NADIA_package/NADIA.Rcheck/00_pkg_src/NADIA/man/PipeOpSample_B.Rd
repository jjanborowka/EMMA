% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PipeOpSample_B.R
\name{PipeOpSample_B}
\alias{PipeOpSample_B}
\title{PipeOpSample_B}
\description{
Impute features by sampling from non-missing data in approach B (independently during the training and prediction phase).
}
\section{Input and Output Channels}{

Input and output channels are inherited from \code{\link{PipeOpImpute}}.
}

\section{Parameters}{

The parameters include inherited from [`PipeOpImpute`], as well as: \cr
\itemize{
\item \code{id} :: \code{character(1)}\cr
Identifier of resulting object, default `"impute_sample_B"`.
}
}

\examples{
{
  graph <- PipeOpSample_B$new() \%>>\% mlr3learners::LearnerClassifGlmnet$new()
  graph_learner <- GraphLearner$new(graph)

  # Task with NA

  resample(tsk("pima"), graph_learner, rsmp("cv", folds = 3))
}
}
\section{Super classes}{
\code{\link[mlr3pipelines:PipeOp]{mlr3pipelines::PipeOp}} -> \code{\link[mlr3pipelines:PipeOpImpute]{mlr3pipelines::PipeOpImpute}} -> \code{Sample_B_imputation}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{PipeOpSample_B$new()}}
\item \href{#method-clone}{\code{PipeOpSample_B$clone()}}
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
\if{html}{\out{<div class="r">}}\preformatted{PipeOpSample_B$new(id = "impute_sample_B", param_vals = list())}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PipeOpSample_B$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
