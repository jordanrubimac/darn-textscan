library(pdftools)
library(pdfsearch)
library(tidyverse)
library(DescTools)

# Replace these with actual file paths
pdf_files <-"/Users/SchoolAccount/Downloads/TestforDarnLevel1/TestforDarnLevel2a"
terms_to_screen_path <- "/Users/SchoolAccount/Documents/Miami!/Year 2/DARN/DARN Text Screening/samplescreeningterms.csv"
# Read terms to screen from CSV
terms_to_screen_df <- read_csv(terms_to_screen_path)

# Function to screen PDF for terms and get page numbers
screen_pdf_for_terms <- function(pdf_file, terms_df) {
  text <- pdf_text(eval(substitute(pdf_file)))
  
  cleaned_text <- gsub("[^[:alnum:] ]", "", text)
  cleaned_text <- tolower(cleaned_text)
  cleaned_text <- gsub("\\s+", " ", cleaned_text)
  
  results <- lapply(terms_df$Header, function(term) {
    matches <- grep(term, text, ignore.case = TRUE)
    if (length(matches) > 0) {
      pages <- as.numeric(sapply(matches, function(match) pdf_info(pdf_file)$pages[match]))
      splittitle <- strsplit(pdf_file, "/")
      data.frame(
        term = rep(term, length(pages)),
        doi = rep(splittitle[[1]][length(splittitle[[1]])], length(pages)),
        page = matches,
        author = rep(StrTrunc(pdf_info(pdf_file)$keys$Author, maxlen=20), length(pages)),
        title = rep(StrTrunc(pdf_info(pdf_file)$keys$Title, maxlen=40), length(pages))
      )
    } else {
      NULL
    }
  })
  results_df <- do.call(rbind, Filter(NROW, results))
  return(results_df)
}


#Pull file names for just PDFs
pdf_list <- list.files(pdf_files, pattern = "\\.pdf$")
#Initialize empty DF
fullresults <- data.frame(matrix(0, ncol = 4, nrow = 0))

#Apply function 
for (i in 1:length(pdf_list)) {
  current_pdf <- paste(eval(substitute(pdf_files)), '/', pdf_list[i], sep='')
  currenpdfresults <- screen_pdf_for_terms(current_pdf, terms_to_screen_df)
  fullresults <- rbind(fullresults, currenpdfresults)
}


# Display the result
print(fullresults)
