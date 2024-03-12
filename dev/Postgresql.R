DBI::dbConnect(
  odbc::odbc(),
  driver = "PostgreSQL Unicode",
  server = "dm-prod",
  port = 5432,
  uid = "SA",
  password = "yourStrongPassword100",
  encoding = "utf8"
)
