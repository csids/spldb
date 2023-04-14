# Version 2023.4.14

- `get_table_names_and_info` is now ordered according to `table_name`.

# Version 2023.4.12

- `get_table_names_and_nrow` is now changed to `get_table_names_and_info` and also includes size_total_gb, size_data_gb, size_index_gb.
- `info` is now included as a method for `DBTable_v9` 

# Version 2023.4.4

- `confirm_indexes` is now added to `DBTable_v9`, which confirms that the names and number of indexes in the database are the same as in the R code. It does not confirm the contents of the indexes!
- `nrow` is now added to `DBTable_v9`, which is an application of the new `get_table_names_and_nrow` function.
- `get_table_names_and_nrow` added as an exported function, that will get all the table names and the nrows from a dbconnection.

# Version 2023.4.2

- `create_table` now automatically adds the indexes.

# Version 2023.3.31

- Removing info messages from `drop_rows_where`.

# Version 2023.3.8

- connect() in DBConnection_v9 is smarter, more robust with error checking and making fewer useless calls to the db. Tries to connect twice now before throwing an error.
- autoconnection is now more robust in DBConnection_v9.

# Version 2023.2.17

- Package is created.
