

#' Join SV, taxonomy, and sample info for an amplicon
#'
#' @param con DBI connection
#' @param amplicon Amplicon name prefix
#' @return A tbl_lazy representing the joined tables
join_amplicon_data <- function(con, amplicon) {
  sv_tbl   <- get_table(con, paste0(amplicon, "_sv"))
  tax_tbl  <- get_table(con, paste0(amplicon, "_tax"))
  info_tbl <- get_table(con, "sampleinfo")
  sv_tbl %>%
    inner_join(tax_tbl, by = "sv") %>%
    inner_join(info_tbl, by = "sample")
}

