#' verb
#'
#' Print debug statements to stdout if debgug mode is enabled
#' @param message String message to print
#' @export
verb <- function(...) {
    debug_mode <- Sys.getenv("DEBUG_MODE")
    if (tolower(debug_mode) == "true") {
        cat(sprintf(...), sep = "", file = stderr())
    }
}

#' logger
#'
#' Print statements to stdout regardless of DEBUG_MODE environment variable.
#' @param message String message to print
#' @export
logger <- function(...) cat(sprintf(...), sep = "", file = stderr())
