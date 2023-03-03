library(data.table)
library(stringr)
library(DBI)
library(jsonlite)

#' update_sample_status: Update the samplestatus for a list of sampleids
#'
#' This function will update the 'samplestatus' column in the database for a set of 'sampleid's accordingly. Each sampleid
#' can have a different samplestatus for the update. This function requires that entries for these sampleids already exist in the table.
#'
#' The sampleids and samplestatus values can be passed as two vectors with corresponding entris, 'sampleid' and 'samplestatus',
#' or passed in as a TSV file with a header that includes columns named 'sampleid' and 'samplestatus'.
#'
#' Canonically, the table is 'analysis_data_string_value' in database VBDB.
#'
#' @param  analysisid character vector of analysisid.
#' @param  sampleid character vector of sampleids. Mutually exclusive with 'file'.
#' @param  samplename character vector of samplenames. Only required if you want a LIMS file (see 'limsfile' argument).
#'			See the 'samplename' column in table 'sample' in 'bioinfo_edge_v2'. Mutually exclusive with 'file'.
#' @param  samplestatus	character vector of samplestatuse. Mutually exclusive with 'file'.
#' @param  dryrun	if TRUE, then will not actually perform the sample status update, but will rather
#'				print the SQL command that it would have executed.
#' @param  table character string giving the name of the table within the database for which the samplestatus will be updated.
#' @param  schema schema of fieldsets tables we will write to.
#'
#' @export
#' @return

update_sample_status <- function(
    analysisid = NULL,
    sampleid = NULL,
    samplename = NULL,
    samplestatus = NULL,
    dryrun = FALSE,
    table,
    schema,
    db_connection
) {
    # args checkpoints
    stopifnot((!is.null(analysisid)))
    stopifnot((!is.null(sampleid)))
    stopifnot((!is.null(sampleid) && !is.null(samplestatus)))

    if (!is.null(sampleid)) {
        stopifnot(length(sampleid) == length(samplestatus))
    }

    if (!is.null(analysisid)) {
        stopifnot(length(analysisid) == length(samplestatus))
    }

    # core logic
    fieldsets::verb("Starting sample status update...\n\n")

    fieldsets::verb("No sample file provided. Building sample table...\n")
    sampdt <- data.table::data.table(sampleid = sampleid, samplestatus = samplestatus)
    if (!is.null(samplename)) {
        if (length(samplename) != nrow(sampdt)) {
            fieldsets::verb(
                "\n\nERROR! provided sample names are not same length as sampleids and samplestatuses!\n"
            )
            show(length(samplename))
            show(nrow(sampdt))
            stop()
        }
        sampdt[, samplename := samplename]
    }

    fieldsets::verb("Retrieved sample ids successfully.\n")

    if (any(duplicated(sampdt$sampleid))) {
        fieldsets::verb("\n\nERROR! some sampleids are provided multiple times!\n")
        dups <- sampdt$sampleid[duplicated(sampdt$sampleid)]
        show(sampdt[sampleid %in% dups, ])
        stop()
    }

    fieldsets::verb("No analysis file provided. Querying database...\n")
    adt <- data.table::data.table(analysisid = analysisid)
    get_sample_query <- paste(
        "SELECT a.analysis_id, a.execution_id, s.sample_name, s.sample_name_lims",
        "FROM fieldsets.analysis AS a",
            "INNER JOIN fieldsets.sample AS s",
                "ON s.sample_id = a.sample_id",
        sprintf("WHERE a.analysis_id IN (%s);", noquote(paste("'", adt$analysisid, "'", sep = "", collapse = ","))),
        collapse = " "
    )
    analysisdt <- fieldsets::db_fetch_result(query = get_sample_query, conn = db_connection)

    fieldsets::verb("Retrieved analysis ids successfully.\n")

    fieldsets::verb("Merging analysis metadata to sample datatable using sampleid...\n")
    analysis_samdt <- merge(sampdt, analysisdt, by.x = "sampleid", by.y = "sample_name")

    fieldsets::verb("Merged successfully.\n")

    get_analysis_query <- paste(
        "SELECT *",
        "FROM fieldsets.analysis AS a",
        sprintf("WHERE a.analysis_id IN (%s);", noquote(paste("'", analysis_samdt$analysis_id, "'", sep = "", collapse = ","))),
        collapse = " "
    )
    sourcedt <- fieldsets::db_fetch_result(get_analysis_query, db_connection)
    diffdt <- analysis_samdt$analysis_id %in% sourcedt$analysis_id

    if (!all(diffdt)) {
        fieldsets::verb("\n\nERROR! entries do not exist for all indicated samples!")
        print(analysis_samdt[!diffdt, ], top = 5e3)
        stop()
    }

    fieldsets::verb("Updating samplestatuses...\n")
    for (rowx in seq_len(analysis_samdt)) {
        analysis_id <- analysis_samdt$analysis_id[rowx]
        sample_id <- analysis_samdt$sampleid[rowx]
        sample_status <- analysis_samdt$samplestatus[rowx]
        fieldsets::verb("\t\t%s  -->  %s\n", sample_id, sample_status)

        update_query <- sprintf(
            "UPDATE %s.%s SET analysis_data_value = %s WHERE analysis_id = %s AND analysis_data_id = %s",
            schema,
            table,
            sample_status,
            analysis_id,
            44
        )
        if (!dryrun) {
            DBI::dbSendStatement(db_connection, update_query)
        } else {
            fieldsets::verb(sprintf("Update SQL: %s", update_query))
        }
    }
    fieldsets::verb("Done! Samplestatus updates completed.\n\n")
}