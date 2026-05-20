library(pdftools)
library(pdfsearch)
library(tidyverse)
library(DescTools)

#Load file path for full PDFs
pdf_files <-"~/PDFs"
setwd(pdf_files)
#Load file path for the list of terms to screen
terms_to_screen_path <- "~/GitHub/darn-textscan/data/terminologtoscan_darn.csv"

# Read in the .CSV with the terms to screen
terms_to_screen_df <- read_csv(terms_to_screen_path, col_names=F)

#Adjust a few of the terms, such that the regular expressions screening will search for words that START with that word stem
terms_to_screen_df[which(terms_to_screen_df$X1=='lame'),] <- "\\blame"
terms_to_screen_df[which(terms_to_screen_df$X1=='abled'),] <- "\\babled"
terms_to_screen_df[which(terms_to_screen_df$X1=='Ailing'),] <- "\\bailing"


# Function to screen each PDF for terms, return the term, author, year, and title of article
screen_pdf_for_terms <- function(pdf_file, terms_df) {
  #browser()
  text <- pdf_text(pdf_file)
  #text <- pdf_text(eval(substitute(pdf_file)))

  cleaned_text <- gsub("[^[:alnum:] ]", "", text)
  cleaned_text <- tolower(cleaned_text)
  cleaned_text <- gsub("\\s+", " ", cleaned_text)

  results <- lapply(terms_df$X1, function(term) {
    matches <- grep(term, text, ignore.case = TRUE)
    if (length(matches) > 0) {
#      browser()

      #pages <- as.numeric(sapply(matches, function(match) pdf_info(pdf_file)$pages[match]))
      splittitle <- strsplit(pdf_file, "-")
      data.frame(
        term = (term),
        author = (StrTrunc(strsplit(pdf_file, "-")[[1]][1], maxlen=20)),
        year = StrTrunc(strsplit(pdf_file, "-")[[1]][2], maxlen=10),
        title = StrTrunc(strsplit(pdf_file, "-")[[1]][3], maxlen =40)
      )
    } else {
      NULL
    }
  })
  results_df <- do.call(rbind, Filter(NROW, results))
  return(results_df)
}

#Pull file names for the PDFs
pdf_list <- list.files(pdf_files, pattern = "\\.pdf$")

#Apply the function across all of the pdfs to screen
results_list <- lapply(pdf_list, screen_pdf_for_terms, terms_df = terms_to_screen_df)

#Write output
results_csv <- bind_rows(results_list)
write_csv(results_csv, "screenedarticleterms.csv")
