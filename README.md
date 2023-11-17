# darn-textscan
Code for screening articles, used for DARN research subgroup's state-of-the-field review


## Data cleaning tasks
Specifically, I have three CSV files, one for each journal, and corresponding R scripts (`spsp.Rmd`, `pspb.Rmd`, `jpsp.Rmd`) that require your attention. The task involves:

1. Going through the deduplicated CSV files to locate missing DOIs.
2. Searching for these missing DOIs in academic databases like PubMed, Google Scholar, and within the dataset itself.
3. Modifying the existing R scripts (`spsp.Rmd`, `pspb.Rmd`, `jpsp.Rmd`) to update the DOIs you locate.

Each R script uses a series of `dplyr` pipes for data manipulation. A snippet of the current R code for one of the scripts is as follows:


mutate(DOI = case_when(is.na(DOI) ~ paste0("MISSING_DOI_", trimmed_title), TRUE ~ DOI )) %>%
mutate(
  DOI = case_when(
    DOI == "MISSING_DOI_who gets to vote?: racialized mental images of …" ~ "10.1177/1948550619899238",
    "OLD STRING" ~ "new DOI",
    TRUE ~ DOI)) %>%
group_by(DOI) %>%


You can find the full R scripts and CSV files on GitHub:  
- R Scripts: [`spsp.Rmd`](https://github.com/jordanrubimac/darn-textscan/blob/main/spsp.Rmd), [`pspb.Rmd`](https://github.com/jordanrubimac/darn-textscan/blob/main/pspb.Rmd), [`jpsp.Rmd`](https://github.com/jordanrubimac/darn-textscan/blob/main/jpsp.Rmd)  
- CSV Files: [Data Files](https://github.com/jordanrubimac/darn-textscan/tree/main/data)

For your reference, the deduplicated file for each journal is where I have already performed some data processing.
