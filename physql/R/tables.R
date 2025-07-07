#'
#' @param con DBI connection
#' @param table Name of the table
#' @return A tbl_lazy object
get_table <- function(con, table) {
  dplyr::tbl(con, table)
}