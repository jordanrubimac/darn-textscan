#read filenames, read .csv, look for lines in csv that aren't in filenames

pdf_files_spps <-"/Users/SchoolAccount/Downloads/SPPS"
pdflist <- list.files(pdf_files_spps)
zoterolist <- read.csv("/Users/SchoolAccount/Documents/GitHub/darn-textscan/data/SPPS_DARNZoteroExport.csv")

pdflist <- sub("\\-.*", "", pdflist)
zoterolist$shortauthor <- sub("\\,.*", "", zoterolist$Author)
extraarticles <- zoterolist[which(!(pdflist %in% tolower(zoterolist$shortauthor))),]


