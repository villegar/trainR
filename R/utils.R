#' Wrapper for \code{\link[base:getElement]{base::getElement}}
#'
#' Wrapper for \code{\link[base:getElement]{base::getElement}}, but instead of
#' returning \code{NULL} when the \code{name} is not found, returns an user
#' specified \code{default} value, \code{NA}.
#'
#' @inheritParams base::getElement
#' @param as_list Boolean flag to return the element as a list.
#' @param default Default value to return if \code{name} is not found.
#'
#' @return Element from object, if exists, \code{default} otherwise.
#' @export
#'
#' @examples
#' test_obj <- list(a = 4, c = 2)
#' get_element(test_obj, "a")
#' get_element(test_obj, "b")
get_element <- function(object, name, as_list = FALSE, default = NA) {
  tryCatch({
  out <- getElement(object, name)
  if (is.null(out))
    return(default)
  if (as_list)
    return(out)
  unlist(out)
  }, error = function(e) {
    if (as_list)
      return(default)
    return(default)
  })
}

#' Get the full station name
#' @param crs (string, 3 characters, alphabetic): The CRS code of the station.
#' @return String with station name.
#' @keywords internal
get_location <- function(crs) {
  if (all(crs %in% station_codes$crs))
    return(purrr::map_chr(crs, ~station_codes$name[station_codes$crs == .]))
  return("UNK")
}

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

#' Update class of data object
#'
#' @param data Data object (e.g. \code{list}).
#' @param class String of new class.
#'
#' @return Original data object with new \code{class}.
#' @keywords internal
#'
#' @examples
#' out <- list(woof = list(name = "Barto", age = 6)) %>%
#'   trainR:::reclass(names(.))
reclass <- function(data, class) {
  if (!is.null(class) & !inherits(data, class))
    class(data) <- c(class, class(data))
  data
}

#' Configure user's token
#'
#' Configure user's token to access the National Rail Enquiries (NRE) data
#' feeds.
#'
#' @param path Path to text file where the token should be stored.
#' @export
set_token <- function(path = "inst/token.txt") {
  usethis::edit_file(path)
}
