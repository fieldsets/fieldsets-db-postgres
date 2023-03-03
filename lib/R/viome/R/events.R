#' update_event_status
#'
#' Update an event status
#' @param event_id The id of the event to update
#' @param new_status The new status of the event
#' @param conn Existing DBI connection from `fieldsets::db_connect`
#' @importFrom DBI dbSendStatement
#' @examples db_connection <- fieldsets_db_connect
#' @export
update_event_status <- function(event_id, new_status, conn) {
    update_statement <- sprintf("UPDATE pipeline.events SET event_status = '%s'::pipeline.FIELDSETS_EVENT_STATUS WHERE event_id = %d;", new_status, event_id)
    DBI::dbSendStatement(conn, update_statement)
}
