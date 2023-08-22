library(pdftools)
library(stringr)

docstoscan <- list.files(pattern = "pdf$")
texttoscan <- lapply(docstoscan, pdf_text)

##NOTE: This script is out of date and obsolete; kept for posterity only


#####Testing Mode

searchterms <- c('disabled', 'and', 'research')
setwd("/Users/SchoolAccount/Downloads/TestforDarnLevel1/TestforDarnLevel2a")
docstoscan <- list.files(pattern = "pdf$")
texttoscan <- lapply(docstoscan, pdf_text)



scantext <- function(text, termstocheck) {
  selectedarticles <- data.frame(matrix(nrow=0, ncol=(length(termstocheck)+1)))
  colnames(selectedarticles) <- c('Paper', termstocheck)
  
  selectedarticles[j, 'Paper'] <- docstoscan[j]
  
  for (i in 1:length(termstocheck)) {
    itemincluded <- str_detect(texttoscan[[1]], regex(termstocheck[i], ignore_case=T))
    if (sum(itemincluded)>0) {
        selectedarticles[j,(i+1)] <- 1
      }
  }
  #for rows where sum(selectedarticles[,c(2:4)], na.rm=T) == 0, delete row
}

scantext(texttoscan, searchterms)
