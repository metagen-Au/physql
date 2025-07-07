
#' Aggregate abundance at specified (or inferred) taxonomic ranks after joining
#'
#' @param con DBI connection
#' @param amplicon Amplicon name prefix
#' @param ranks Character vector of taxonomic rank columns to group by; if NULL or length=1 and auto_hierarchy=TRUE,
#'              will infer all ranks from top down to the specified rank
#' @param sample_filter (Optional) Character vector of sample IDs to pre-filter
#' @param tax_filter (Optional) Named list of taxonomy filters to pre-filter
#' @param auto_hierarchy Logical. If TRUE (default) and ranks length <=1, will include all preceding ranks
#' @return A tbl_lazy grouping & summing in the database
aggregate_by_taxa <- function(con, amplicon,
                              ranks = NULL,
                              sample_filter = NULL,
                              tax_filter = NULL,
                              auto_hierarchy = TRUE) {
  # Start with full join
  qry <- join_amplicon_data(con, amplicon)
  
  # Pre-apply any filters (all in SQL)
  if (!is.null(sample_filter)) {
    qry <- qry %>% filter(sample %in% sample_filter)
  }
  if (!is.null(tax_filter)) {
    qry <- filter_by_taxa(qry, tax_filter)
  }
  
  # Determine taxonomic columns in correct order
  all_tax_cols <- DBI::dbListFields(con, paste0(amplicon, "_tax"))
  all_tax_cols <- setdiff(all_tax_cols, "sv")
  if (length(all_tax_cols) == 0) {
    stop("No taxonomic columns found in ", paste0(amplicon, "_tax"))
  }
  
  # Default to the first rank if none specified
  if (is.null(ranks) || length(ranks) == 0) {
    ranks <- all_tax_cols[1]
  }
  # Validate requested ranks
  if (!all(ranks %in% all_tax_cols)) {
    bad <- setdiff(ranks, all_tax_cols)
    stop("Requested ranks not found: ", paste(bad, collapse = ", "))
  }
  
  # Compute grouping columns
  if (auto_hierarchy && length(ranks) == 1) {
    # Include all ranks up to the position of the specified one
    idx <- match(ranks, all_tax_cols)
    grouping <- all_tax_cols[seq_len(idx)]
  } else if (auto_hierarchy && length(ranks) > 1) {
    idx <- match(ranks, all_tax_cols)
    grouping <- all_tax_cols[seq_len(max(idx))]
  } else {
    grouping <- ranks
  }
  
  # Perform aggregation in-database
  qry %>%
    group_by(across(all_of(grouping))) %>%
    summarize(
      total_abundance = sum(abundance, na.rm = TRUE),
      distinct_samples = n_distinct(sample),
      .groups = "drop"
    )
}
