#' Count helper functions
#'
#' Variants of \code{dplyr}'s \code{\link[dplyr]{count}} function, letting you
#' count the instances of each value in columns of your data frame.
#' \describe{
#' \item{\code{count_all}}{\code{group_by_all + tally}}
#' \item{\code{count_at}}{\code{group_by_at + tally}}
#' \item{\code{count_if}}{\code{group_by_if + tally}}
#' }
#' @param x A \code{tbl} object.
#' @param .vars A list of columns generated by vars(), a character vector of
#' column names, a numeric vector of column positions, or NULL. Passed to
#' \code{\link[dplyr]{group_by_at}}.
#' @param .predicate A predicate function to be applied to the columns or a
#' logical vector. The variables for which \code{.predicate} is or returns
#' \code{TRUE} are selected. This argument is passed to
#' \code{rlang::as_function()} and thus supports quosure-style lambda functions
#' and strings representing function names. Passed to
#' \code{\link[dplyr]{group_by_if}}.
#' @param wt (Optional) If omitted (and no variable named n exists in the data),
#' will count the number of rows. If specified, will perform a "weighted" tally
#' by summing the (non-missing) values of variable wt. A column named n (but
#' not nn or nnn) will be used as weighting variable by default in tally(), but
#' not in count(). This argument is automatically quoted and later evaluated in
#' the context of the data frame. It supports unquoting. Passed to
#' \code{\link[dplyr]{count}}.
#' @param sort Logical. Should the results be sorted by decreasing \code{n}.
#' @return A summarized version of \code{x}.
#' @seealso \code{\link[dplyr]{count}} and \code{\link[dplyr]{group_by_all}}
#' @examples
#' library(dplyr)
#' n <- 100
#' quarks <- data_frame(
#'   first_gen = sample(c("up", "down"), n, replace = TRUE),
#'   second_gen = sample(c("charm", "strange"), n, replace = TRUE),
#'   third_gen = factor(sample(c("top", "bottom"), n, replace = TRUE))
#' )
#' quarks %>% count_all()
#' quarks %>% count_at(vars(contains("ir")))
#' quarks %>% count_if(is.factor)
#' @importFrom dplyr group_vars
#' @importFrom dplyr group_by_all
#' @importFrom dplyr group_by
#' @importFrom dplyr tally
#' @importFrom rlang enquo
#' @importFrom rlang syms
#' @export
count_all <- function(x, wt = NULL, sort = FALSE) {
  groups <- group_vars(x)
  x <- group_by_all(x)
  x <- tally(x, wt = !!enquo(wt), sort = sort)
  x <- group_by(x, !!!syms(groups), add = FALSE)
  x
}

#' @rdname count_all
#' @importFrom dplyr group_by_at
#' @export
count_at <- function(x, .vars, wt = NULL, sort = FALSE) {
  groups <- group_vars(x)
  x <- group_by_at(x, .vars = .vars, add = TRUE)
  x <- tally(x, wt = !!enquo(wt), sort = sort)
  x <- group_by(x, !!!syms(groups), add = FALSE)
  x
}

#' @rdname count_all
#' @importFrom dplyr group_by_if
#' @export
#' @export
count_if <- function(x, .predicate, wt = NULL, sort = FALSE) {
  groups <- group_vars(x)
  x <- group_by_if(x, .predicate = .predicate, add = TRUE)
  x <- tally(x, wt = !!enquo(wt), sort = sort)
  x <- group_by(x, !!!syms(groups), add = FALSE)
  x
}
