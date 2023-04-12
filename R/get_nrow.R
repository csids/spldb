#' Get table names, number of rows, and size of data
#' @param connection db connection
#' @export
get_table_names_and_info.Microsoft <- function(connection) UseMethod("get_nrow")

#' @export
`get_table_names_and_info.Microsoft SQL Server` <- function(connection) {
  # table_rows <- connection %>%
  #   DBI::dbGetQuery("select o.name as table_name, i.rowcnt as n from sys.objects o join sys.sysindexes i on o.object_id = i.id where o.is_ms_shipped = 0 and i.rowcnt > 0 order by o.name") %>%
  #   setDT() %>% unique()
  table_rows <- connection %>%
    DBI::dbGetQuery("sp_msforeachtable 'sp_spaceused [?]") %>%
    setDT()
  table_rows[, size_total_gb := round(as.numeric(stringr::str_extract_all(reserved, "[0-9]+"))/1024/1024, digits = 2)]
  table_rows[, size_data_gb := round(as.numeric(stringr::str_extract_all(data, "[0-9]+"))/1024/1024, digits = 2)]
  table_rows[, size_index_gb := round(as.numeric(stringr::str_extract_all(index_size, "[0-9]+"))/1024/1024, digits = 2)]
  table_rows[, nrow := as.numeric(stringr::str_extract_all(rows, "[0-9]+"))]

  table_rows <- table_rows[,.(
    table_name = name,
    nrow,
    size_total_gb,
    size_data_gb,
    size_index_gb
  )]

  data.table::shouldPrint(table_rows)
  return(table_rows)
}
