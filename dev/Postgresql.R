

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


dbtable <- csdb::DBTable_v9$new(
  dbconfig = list(
    driver = Sys.getenv("SC9_DBCONFIG_DRIVER"),
    server = Sys.getenv("SC9_DBCONFIG_SERVER"),
    port = as.integer(Sys.getenv("SC9_DBCONFIG_PORT")),
    db = Sys.getenv("SC9_DBCONFIG_DB_ANON"),
    schema = "public", #Sys.getenv("SC9_DBCONFIG_SCHEMA_ANON"),
    user = Sys.getenv("SC9_DBCONFIG_USER"),
    password = Sys.getenv("SC9_DBCONFIG_PASSWORD"),
    trusted_connection = Sys.getenv("SC9_DBCONFIG_TRUSTED_CONNETION")
  ),
  table_name = "anon_test",
  field_types = c(
    "granularity_time" = "TEXT",
    "granularity_geo" = "TEXT",
    "country_iso3" = "TEXT",
    "location_code" = "TEXT",
    "border" = "INTEGER",
    "age" = "TEXT",
    "sex" = "TEXT",
    "isoyear" = "INTEGER",
    "isoweek" = "INTEGER",
    "isoyearweek" = "TEXT",
    "season" = "TEXT",
    "seasonweek" = "DOUBLE",
    "calyear" = "INTEGER",
    "calmonth" = "INTEGER",
    "calyearmonth" = "TEXT",
    "date" = "DATE",
    "covid19_cases_testdate_n" = "INTEGER",
    "covid19_cases_testdate_pr100000" = "DOUBLE"
  ),
  keys = c(
    "granularity_time",
    "location_code",
    "date",
    "age",
    "sex"
  ),
  indexes = list(
    "ind1" = c("granularity_time", "granularity_geo", "country_iso3", "location_code", "border", "age", "sex", "date", "isoyear", "isoweek", "isoyearweek")
  ),
  validator_field_types = csdb::validator_field_types_blank,
  validator_field_contents = csdb::validator_field_contents_blank
)
dbtable$connect()

dbtable$insert_data(csdb::nor_covid19_cases_by_time_location)
dbtable$connect()
dbtable$dbconnection$is_connected()
dbtable$tbl()

dbtable$upsert_data(csdb::nor_covid19_cases_by_time_location)
dbtable$drop_rows_where("calmonth = 9")
dbtable$keep_rows_where("calmonth = 9")
dbtable$add_indexes()
dbtable$drop_constraint()
dbtable$confirm_indexes()

dbtable$nrow()
dbtable$info()



