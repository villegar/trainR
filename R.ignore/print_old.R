#' Print Values
#'
#' @param x an object used to select a method.
#' @param ... further arguments passed to or from other methods.
#'
#' @return Input data invisibly.
#' @rdname print
#' @export
print <- function(x, ...) {
  UseMethod("print", x)
}
