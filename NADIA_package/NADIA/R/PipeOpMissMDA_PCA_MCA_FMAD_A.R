#' @title PipeOpmissMDA_PCA_MCA_FMAD_A
#'
#' @name PipeOpmissMDA_PCA_MCA_FMAD_A
#'
#' @description
#' Implements PCA, MCA, FMAD methods as mlr3 pipeline in approach A, more about methods \code{\link{missMDA_FMAD_MCA_PCA}} and \code{\link{missMDA.reuse}}
#'
#' @section Input and Output Channels:
#' Input and output channels are inherited from \code{\link{PipeOpImpute}}.
#'
#'
#' @section Parameters:
#' The parameters include inherited from [`PipeOpImpute`], as well as: \cr
#' \itemize{
#' \item \code{id} :: \code{character(1)}\cr
#' Identifier of resulting object, default \code{"imput_missMDA_MCA_PCA_FMAD"}.
#' \item \code{optimize_ncp} :: \code{logical(1)}\cr
#' If TRUE, parameter \emph{number of dimensions}, used to predict the missing values, will be optimized. If FALSE, by default ncp=2 is used, default \code{TRUE}.
#' \item \code{set_ncp} :: \code{integer(1)}\cr
#' integer >0. Number of dimensions used by algortims. Used only if optimize_ncp = Flase, default \code{2}.
#' \item \code{ncp.max} :: \code{integer(1)}\cr
#' Number corresponding to the maximum number of components to test when optimize_ncp=TRUE, default \code{5}.
#' \item \code{random.seed} :: \code{integer(1)}\cr
#' Integer, by default random.seed = NULL implies that missing values are initially imputed by the mean of each variable. Other values leads to a random initialization, default \code{NULL}.
#' \item \code{maxiter} :: \code{integer(1)}\cr
#' Maximal number of iteration in algorithm, default \code{998}.
#' \item \code{coeff.ridge} :: \code{double(1)}\cr
#' Value used in \emph{Regularized} method, default \code{1}.
#' \item \code{threshold} :: \code{double(1)}\cr
#' Threshold for convergence, default \code{1e-6}.
#' \item \code{method} :: \code{character(1)}\cr
#' Method used in imputation algorithm, default \code{'Regularized'}.
#' \item \code{out_fill} :: \code{character(1)}\cr
#' Output log file location. If file already exists log message will be added. If NULL no log will be produced, default \code{NULL}.
#' }
#'
#' @examples
#' \donttest{
#'
#'  # Using debug learner for example purpose
#'
#'
#'   graph <- PipeOpMissMDA_PCA_MCA_FMAD_A$new() %>>% LearnerClassifDebug$new()
#'   graph_learner <- GraphLearner$new(graph)
#'
#'   # Task with NA
#'   set.seed(1)
#'   resample(tsk("pima"), graph_learner, rsmp("cv", folds = 3))
#' }
#' @export
PipeOpMissMDA_PCA_MCA_FMAD_A <- R6::R6Class("missMDA_MCA_PCA_FMAD_imputation_A",
                                          lock_objects = FALSE,
                                          inherit = PipeOpImpute, # inherit from PipeOp
                                          public = list(
                                            initialize = function(id = "impute_missMDA_MCA_PCA_FMAD_A", optimize_ncp = TRUE, set_ncp = 2, ncp.max = 5, random.seed = NULL, maxiter = 998,
                                                                  coeff.ridge = 1, threshold = 1e-06, method = "Regularized", out_file = NULL) {

                                              super$initialize(id,
                                                               whole_task_dependent = TRUE, packages = "NADIA", param_vals = list(
                                                                 optimize_ncp = optimize_ncp, set_ncp = set_ncp, ncp.max = ncp.max, random.seed = random.seed,
                                                                 maxiter = maxiter, coeff.ridge = coeff.ridge, threshold = threshold, method = method, out_file = out_file),
                                                               param_set = ParamSet$new(list(
                                                                 "set_ncp" = ParamInt$new("set_ncp", lower = 1, upper = Inf, default = 2, tags = "PCA_MCA_FMAD_A"),
                                                                 "ncp.max" = ParamInt$new("ncp.max", lower = 1, upper = Inf, default = 2, tags = "PCA_MCA_FMAD_A"),
                                                                 "maxiter" = ParamInt$new("maxiter", lower = 50, upper = Inf, default = 998, tags = "PCA_MCA_FMAD_A"),
                                                                 "coeff.ridge" = ParamDbl$new("coeff.ridge", lower = 0, upper = 1, default = 1, tags = "PCA_MCA_FMAD_A"),
                                                                 "threshold" = ParamDbl$new("threshold", lower = 0, upper = 1, default = 1e-6, tags = "PCA_MCA_FMAD_A"),
                                                                 "method" = ParamFct$new("method", levels = c("Regularized", "EM"), default = "Regularized", tags = "PCA_MCA_FMAD_A"),
                                                                 "out_file" = ParamUty$new("out_file", default = NULL, tags = "PCA_MCA_FMAD_A"),



                                                                 "random.seed" = ParamUty$new("random.seed",  default = NULL, tags = "PCA_MCA_FMAD_A"),
                                                                 "optimize_ncp" = ParamLgl$new("optimize_ncp", default = TRUE, tags = "PCA_MCA_FMAD_A")

                                                               ))
                                              )




                                              self$imputed <- FALSE
                                              self$column_counter <- NULL
                                              self$data_imputed <- NULL

                                            }), private = list(
                                              .train_imputer = function(feature, type, context) {

                                                imp_function <- function(data_to_impute) {

                                                  data_to_impute <- as.data.frame(data_to_impute)
                                                  # prepering arguments for function
                                                  col_type <- 1:ncol(data_to_impute)
                                                  for (i in col_type) {
                                                    col_type[i] <- class(data_to_impute[, i])
                                                  }
                                                  percent_of_missing <- 1:ncol(data_to_impute)
                                                  for (i in percent_of_missing) {
                                                    percent_of_missing[i] <- (sum(is.na(data_to_impute[, i])) / length(data_to_impute[, 1])) * 100
                                                  }
                                                  col_miss <- colnames(data_to_impute)[percent_of_missing > 0]
                                                  col_no_miss <- colnames(data_to_impute)[percent_of_missing == 0]

                                                  model_in <- NADIA::missMDA_FMAD_MCA_PCA(data_to_impute, col_type, percent_of_missing,
                                                                                              optimize_ncp = self$param_set$values$optimize_ncp,
                                                                                              set_ncp = self$param_set$values$set_ncp,
                                                                                              ncp.max = self$param_set$values$ncp.max, random.seed = self$param_set$values$random.seed,
                                                                                              maxiter = self$param_set$values$maxiter, coeff.ridge = self$param_set$values$coeff.ridge,
                                                                                              threshold = self$param_set$values$threshold, method = self$param_set$values$method,
                                                                                              out_file = self$param_set$values$out_file,return_ncp = TRUE)





                                                  return(list("data"=model_in$data,"ncp"=model_in$ncp,"raw_data"=data_to_impute))
                                                }

                                                self$imputed_predict <- TRUE
                                                self$flag <- "train"
                                                if (!self$imputed) {
                                                  self$column_counter <- ncol(context) + 1
                                                  self$imputed <- TRUE
                                                  data_to_impute <- cbind(feature, context)

                                                  product <- imp_function(data_to_impute)
                                                  self$data_imputed <- product$data
                                                  self$ncp <- product$ncp
                                                  self$raw_data <- product$raw_data
                                                  colnames(self$data_imputed) <- self$state$context_cols

                                                }
                                                if (self$imputed) {
                                                  self$column_counter <- self$column_counter - 1

                                                }
                                                if (self$column_counter == 0) {
                                                  self$imputed <- FALSE
                                                }
                                                self$train_s <- TRUE

                                                self$action <- 3


                                                return(list('ncp' = self$ncp,"raw_data"=self$raw_data,"data_imputed" = self$data_imputed, "train_s" = self$train_s, "flag" = self$flag, "imputed_predict" = self$imputed_predict, "imputed" = self$imputed, "column_counter" = self$column_counter))

                                              },
                                              .impute = function(feature, type, model, context) {

                                                if (is.null(self$action)) {


                                                  self$train_s <- TRUE
                                                  self$flag <- "train"
                                                  self$imputed_predict <- TRUE
                                                  self$action <- 3
                                                  self$data_imputed <- model$data_imputed
                                                  self$ncp <- model$ncp
                                                  self$raw_data <- model$raw_data
                                                  self$imputed <- FALSE
                                                  self$column_counter <- 0

                                                }
                                                imp_function <- function(data_to_impute) {

                                                  data_to_impute <- as.data.frame(data_to_impute)
                                                  # prepering arguments for function
                                                  col_type <- 1:ncol(data_to_impute)
                                                  for (i in col_type) {
                                                    col_type[i] <- class(data_to_impute[, i])
                                                  }
                                                  percent_of_missing <- 1:ncol(data_to_impute)
                                                  for (i in percent_of_missing) {
                                                    percent_of_missing[i] <- (sum(is.na(data_to_impute[, i])) / length(data_to_impute[, 1])) * 100
                                                  }
                                                  col_miss <- colnames(data_to_impute)[percent_of_missing > 0]
                                                  col_no_miss <- colnames(data_to_impute)[percent_of_missing == 0]

                                                  data_imputed <- NADIA::missMDA.reuse(train_data = self$raw_data,new_data = data_to_impute,
                                                                                       ncp = self$ncp,col_type = col_type,random.seed =self$param_set$values$radnom.seed,
                                                                                      maxiter = self$param_set$values$maxiter,coeff.ridge = self$param_set$values$coeff.ridge,
                                                                                      method = self$param_set$values$method,threshold = self$param_set$values$threshold)





                                                  return(data_imputed)
                                                }
                                                if (self$imputed) {
                                                  feature <- self$data_imputed[, setdiff(colnames(self$data_imputed), colnames(context))]


                                                }
                                                if ((nrow(self$data_imputed) != nrow(context) | !self$train_s) & self$flag == "train") {
                                                  self$imputed_predict <- FALSE
                                                  self$flag <- "predict"
                                                }

                                                if (!self$imputed_predict) {
                                                  data_to_impute <- cbind(feature, context)
                                                  self$data_imputed <- imp_function(data_to_impute)
                                                  colnames(self$data_imputed)[1] <- setdiff(self$state$context_cols, colnames(context))
                                                  self$imputed_predict <- TRUE
                                                }


                                                if (self$imputed_predict & self$flag == "predict") {
                                                  feature <- self$data_imputed[, setdiff(colnames(self$data_imputed), colnames(context))]

                                                }

                                                if (self$column_counter == 0 & self$flag == "train") {
                                                  feature <- self$data_imputed[, setdiff(colnames(self$data_imputed), colnames(context))]
                                                  self$flag <- "predict"
                                                  self$imputed_predict <- FALSE
                                                }
                                                self$train_s <- FALSE

                                                return(feature)
                                              }

                                            )
)
