#' Obtain the raw SQL for any lazy query
#'
#' @param qry A tbl_lazy
#' @return Character string of SQL
get_query_sql <- function(qry) {
  dbplyr::sql_render(qry)
}