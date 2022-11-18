#' blah
#' @examples
#' x()
#' @export
x <- function(){
  print(2)
}

create_db_config <- function(
  driver = NULL,
  server = NULL,
  port = NULL,
  user = NULL,
  password = NULL,
  db = NULL,
  trusted_connection = NULL
){
  retval <- list(
    driver = driver,
    server = server,
    port = port,
    user = user,
    password = password,
    db = db,
    trusted_connection = trusted_connection
  )
  class(retval) <- c("csdb_db_config", class(retval))
  return(retval)
}

use_or_create_db <- function(conn, db) {
  tryCatch(
    {
      a <- DBI::dbExecute(conn, glue::glue({
        "USE {db};"
      }))
    },
    error = function(e) {
      a <- DBI::dbExecute(conn, glue::glue({
        "CREATE DATABASE {db};"
      }))
      a <- DBI::dbExecute(conn, glue::glue({
        "USE {db};"
      }))
    }
  )
}

create_db_connection <- function(
    db_config
){
  use_trusted <- FALSE
  if (!is.null(db_config$trusted_connection)) if (db_config$trusted_connection == "yes") use_trusted <- TRUE

  if (use_trusted & db_config$driver %in% c("ODBC Driver 17 for SQL Server")) {
    conn <- DBI::dbConnect(
      MSSQL(),
      driver = db_config$driver,
      server = db_config$server,
      port = db_config$port,
      trusted_connection = "yes"
    )
  } else if (db_config$driver %in% c("ODBC Driver 17 for SQL Server")) {
    conn <- DBI::dbConnect(
      MSSQL(),
      driver = db_config$driver,
      server = db_config$server,
      port = db_config$port,
      uid = db_config$user,
      pwd = db_config$password,
      encoding = "utf8"
    )
  } else {
    conn <- DBI::dbConnect(
      MSSQL(),
      driver = db_config$driver,
      server = db_config$server,
      port = db_config$port,
      user = db_config$user,
      password = db_config$password,
      encoding = "utf8"
    )
  }
  if (!is.null(db_config$db)) use_or_create_db(conn, db_config$db)
  attr(conn, "db_config") <- db_config
  return(conn)
}
