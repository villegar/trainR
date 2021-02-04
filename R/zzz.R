#===================
# On load
#===================
.onAttach <- function(libname, pkgname) {
  if (Sys.getenv("NRE") == "")
    packageStartupMessage("~~ Package trainR\nRemember to set your NRE access token, `trainR::set_token()` ~~")
}
