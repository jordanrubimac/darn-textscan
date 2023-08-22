library(pdftools)
library(stringr)

docstoscan <- list.files(pattern = "pdf$")
texttoscan <- lapply(docstoscan, pdf_text)

searchterms <- read.csv('searchterms.csv')



#####Testing Mode

searchterms <- c('disabled', 'and', 'research')
setwd("/Users/SchoolAccount/Downloads/TestforDarnLevel1/TestforDarnLevel2a")
docstoscan <- list.files(pattern = "pdf$")
texttoscan <- lapply(docstoscan, pdf_text)

scantext <- function(text, terms) {
  str_detect(texttoscan[[1]], regex(searchterms[i]), ignore_case=T))
}

scantext(texttoscan, searchterms)