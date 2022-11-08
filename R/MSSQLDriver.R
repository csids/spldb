#' Connect to an MSSQL database
#' @export
msbcp <- function(){
  new("MsbcpDriver")
}

#' @importClassesFrom odbc OdbcDriver
#' @export
setClass("MsbcpDriver", contains = "OdbcDriver")

#' @importClassesFrom odbc OdbcConnection
setClass("Microsoft SQL Server", contains = "OdbcConnection", where = odbc:::class_cache)

#' @export
setClass("Msbcp", contains = "OdbcConnection", slots = c(blah="list", x = "environment"))

#' @inheritParams methods::show
#' @export
setMethod(
  "show", "Msbcp",
  function(object) {
    cat("<Msbcp>\n")
    print(object@blah)
    callNextMethod(object)
    # TODO: Print more details
  })



setGeneric("dbUseDB", function(object, db) {
  standardGeneric("dbUseDB")
})

setMethod(
  "dbUseDB",
  signature(object="Msbcp"),
  function(object, db) {
    if(!is.null(db)){
      tryCatch(
        {
          a <- DBI::dbExecute(object, glue::glue({
            "USE {db};"
          }))
        },
        error = function(e) {
          a <- DBI::dbExecute(object, glue::glue({
            "CREATE DATABASE {db};"
          }))
          a <- DBI::dbExecute(object, glue::glue({
            "USE {db};"
          }))
        }
      )
    }
    object
  }
)


#' Connect to a ODBC compatible database
#'
#' @importFrom DBI dbConnect
#' @inheritParams DBI::dbConnect
#' @param ... Additional ODBC keywords, these will be joined with the other
#' arguments to form the final connection string.
#' @export
setMethod(
  "dbConnect", "MsbcpDriver",
  function(drv, ..., db = NULL) {
    dots <- list(...)
    a <- callNextMethod(drv, ..., db = db)
    test <- new("Msbcp", ptr = a@ptr, quote = a@quote, info = a@info, encoding = a@encoding, blah=dots)
    # do.call(DBI::dbConnect, c(msbcp(),conn@blah))
    dbUseDB(test, db)
    test
  }
)
