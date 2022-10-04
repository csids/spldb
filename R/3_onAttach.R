#' @import data.table ggplot2
#' @importFrom magrittr %>%
.onAttach <- function(libname, pkgname) {
    version <- tryCatch(
      utils::packageDescription("spldb", fields = "Version"),
      warning = function(w){
        1
      }
    )
  
  packageStartupMessage(paste0(
    "spldb ",
    version,
    "\n",
    "https://docs.sykdomspulsen.no/spldb/"
  ))
}
