con <- DBI::dbConnect(
  odbc::odbc(),
  driver = "PostgreSQL Unicode",
  server = "dm-prod",
  port = 5432,
  uid = "SA",
  password = "yourStrongPassword100",
  database = "sc_interactive_config",
  encoding = "utf8"
)
DBI::dbExecute(con, "\\c sc_interactive_config;")
DBI::dbExecute(con, "CREATE DATABASE sc_interactive_config;")

dbconnection <- csdb::DBConnection_v9$new(
  driver = Sys.getenv("SC9_DBCONFIG_DRIVER"),
  server = Sys.getenv("SC9_DBCONFIG_SERVER"),
  port = 5432,#as.integer(Sys.getenv("SC9_DBCONFIG_PORT")),
  db = Sys.getenv("SC9_DBCONFIG_DB_ANON"),
  user = Sys.getenv("SC9_DBCONFIG_USER"),
  password = Sys.getenv("SC9_DBCONFIG_PASSWORD"),
  trusted_connection = Sys.getenv("SC9_DBCONFIG_TRUSTED_CONNETION")
)
dbconnection
dbconnection$connect()
