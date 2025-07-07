#' Filter joined data by sample(s)
#'
#' @param qry A tbl_lazy from join_amplicon_data()
#' @param samples Character vector of sample IDs
#' @return A tbl_lazy filtered by sample
filter_by_sample <- function(qry, samples) {
  qry %>% filter(sample %in% samples)
}

#' Filter joined data by taxonomy ranks/values
#'
#' @param qry A tbl_lazy from join_amplicon_data()
#' @param tax_filter Named list of taxonomy filters, e.g. list(rank1 = "Bacteria")
#' @return A tbl_lazy filtered by taxonomy
filter_by_taxa <- function(qry, tax_filter) {
  for (nm in names(tax_filter)) {
    val <- tax_filter[[nm]]
    qry <- qry %>% filter(.data[[nm]] == val)
  }
  qry
}



#' Example usage:
#' con <- connect_duckdb("metabarcode.duckdb")
#' base_qry <- join_amplicon_data(con, "16S")
#' # Now auto-hierarchy: specifying only "rank3" will group by rank1, rank2, rank3
#' agg_order <- aggregate_by_taxa(con, "16S", ranks = "rank3") %>% collect()
#' # Or specify multiple ranks and use auto_hierarchy=FALSE to group only those
#' agg_custom <- aggregate_by_taxa(con, "16S", ranks = c("rank1","rank3"), auto_hierarchy = FALSE) %>% collect()
#' # Preview SQL
#' cat(get_query_sql(aggregate_by_taxa(con, "16S", ranks = "rank3")))