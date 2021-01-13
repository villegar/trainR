#' Get user's token
#'
#' Get user's token to access the National Rail Enquiries (NRE) data feeds.
#'
#' @param path Path to text file with token.
#'
#' @return String with token, first line of the input file.
#' @export
get_token <- function(path = "inst/token.txt") {
  tryCatch({
    f <- file(path, open = "r")
    on.exit(close(f))
    readLines(f)[1]
  }, error = function(e) {
    stop("Error reading the token file: \n", path)
  })
}

#' Configure user's token
#'
#' Configure user's token to access the National Rail Enquiries (NRE) data
#' feeds.
#'
# @param path Path to text file where the token should be stored.
#' @export
set_token <- function() { # path = "inst/token.txt") {
  # usethis::edit_file(path)
  usethis::edit_r_environ(scope = "user")
}
