# physql

`physql` is an R package for fast, lazy analysis of amplicon (metabarcoding) data using DuckDB (or MotherDuck). It lets you:

- **Connect** to on-disk DuckDB files (`.duckdb`) or in-memory databases  
- **Reference** tables as lazy `dbplyr` pipelines  
- **Join** your SV (sequence variant), taxonomy, and sample-info tables in a single SQL query  
- **Filter** by sample or taxonomic rank entirely in-database  
- **Aggregate** abundances at any taxonomic level with “auto-hierarchy”  
- **Preview** the underlying SQL before you `collect()` the results  

---

## Installation

```r
# From CRAN
install.packages("physql")

# Or development version:
remotes::install_github("metagenAu/physql")
