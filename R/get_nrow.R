#' Get table names and number of rows
#' @param connection db connection
#' @export
get_table_names_and_nrow <- function(connection) UseMethod("get_nrow")

#' @export
`get_table_names_and_nrow.Microsoft SQL Server` <- function(connection) {
  table_rows <- connection %>%
    DBI::dbGetQuery("select o.name as table_name, i.rowcnt as n from sys.objects o join sys.sysindexes i on o.object_id = i.id where o.is_ms_shipped = 0 and i.rowcnt > 0 order by o.name") %>%
    setDT() %>% unique()

  data.table::shouldPrint(table_rows)
  return(table_rows)
}
