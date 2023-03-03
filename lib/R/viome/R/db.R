#' db_get_connection
#'
#' Return a DBI connection to our Postgres Database
#' @return DBI Connection
#' @examples db_connection <- fieldsets_db_connect
#' @importFrom DBI dbConnect
#' @importFrom RPostgres Postgres
#' @export
db_connect <- function() {
    db_name <- Sys.getenv("POSTGRES_DB")
    db_host <- Sys.getenv("POSTGRES_HOST")
    db_port <- Sys.getenv("POSTGRES_PORT")
    db_user <- Sys.getenv("POSTGRES_USER")
    db_password <- Sys.getenv("POSTGRES_PASSWORD")
    db_schema <- Sys.getenv("POSTGRES_SCHEMA")
    db_options <- sprintf("-c search_path=%s", db_schema)
    db_connection <- DBI::dbConnect(
        RPostgres::Postgres(),
        dbname = db_name,
        host = db_host,
        port = db_port,
        user = db_user,
        password = db_password,
        options = db_options
    )

    return(db_connection)
}

#' db_disconnect
#'
#' End a given DBI connection to our Postgres Database
#' @param conn Existing DBI connection from `fieldsets::db_connect`
#' @examples db_disconnect(db_connection)
#' @importFrom DBI dbDisconnect
#' @export
db_disconnect <- function(conn) {
    return(DBI::dbDisconnect(conn))
}

#' db_fetch_result
#'
#' Execute a query and return results as a data frame.
#' @param query SQL Query Statement
#' @param conn Existing DBI connection from `fieldsets::db_connect`
#' @return data frame
#' @examples db_fetch_results('SELECT * FROM table;', db_connection)
#' @importFrom DBI dbSendQuery dbFetch dbClearResult
#' @importFrom data.table as.data.table
#' @export
db_fetch_result <- function(query, conn) {
    query_execution <- DBI::dbSendQuery(conn, query)
    query_result <- DBI::dbFetch(query_execution)
    DBI::dbClearResult(query_execution)

    return(data.table::as.data.table(query_result))
}

#' db_append_table
#'
#' Append a data table to a given data base table.
#' @param schema DB schema
#' @param table_name Name of table to append to
#' @param data Data values to use for update
#' @param conn Existing DBI connection from `fieldsets::db_connect`
#' @param dryrun Do not write to DB if TRUE
#'
#' @examples db_append_table("public", "my_table", my_data_table, db_connection)
#' @importFrom DBI dbWriteTable
#' @export
db_append_table <- function(schema, table, data, conn, dryrun = FALSE) {
    if (!dryrun) {
        DBI::dbWriteTable(con = conn, name = DBI::Id(schema = schema, table = table), value = data, row.names = FALSE, append = TRUE)
    }
}
