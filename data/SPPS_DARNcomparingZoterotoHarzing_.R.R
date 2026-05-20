library(stringr)
#Is there a way to make the paths consistent across people, like path through GitHub?
harzinglist <- read.csv("/Users/SchoolAccount/Documents/GitHub/darn-textscan/data/SPPS_deduplicated.csv")
zoterolist <- read.csv("/Users/SchoolAccount/Documents/GitHub/darn-textscan/data/SPPS_DARNZoteroExport.csv")

#Find articles that were included in harzing and not in zotero
unknownarticles <- harzinglist[which(!(harzinglist$DOI %in% zoterolist$DOI)),]
#zoterolist$Title <- gsub("[\u2018\u2019\u201A\u201B\u2032\u2035]", "'", zoterolist$Title)
unknownarticles <- unknownarticles[which(!(tolower(str_sub(unknownarticles$Title, 1, 20)) %in% tolower(str_sub(zoterolist$Title, 1, 20)))),]

write.csv(unknownarticles, "spps_harzingnotzotero.csv")

#List of article titles, sorted alphabetically, to visually check
unknowntitles <- list(str_sub(unknownarticles$Title, 1, 20))
unknowntitles <- tolower(str_sort(unknowntitles[[1]]))
zoterotitles <- list(str_sub(zoterolist$Title, 1, 20))
zoterotitles <- tolower(str_sort(zoterotitles[[1]]))


### Other way around: any zotero not in Harzing?
zoterolist$Title <- gsub("[\u2018\u2019\u201A\u201B\u2032\u2035]", "'", zoterolist$Title)
zoterounknown <- zoterolist[which(!(zoterolist$DOI %in% harzinglist$DOI)),]
zoterounknown <- zoterounknown[which(!(tolower(str_sub(zoterounknown$Title, 1, 20)) %in% tolower(str_sub(harzinglist$Title, 1, 20)))),]
#nope!

zoterounknowntitles <- list(str_sub(unknownarticles$Title, 1, 20))
zoterounknowntitles <- tolower(str_sort(zoterounknowntitles[[1]]))
harzingtitles <- list(str_sub(harzinglist$Title, 1, 20))
harzingtitles <- tolower(str_sort(harzingtitles[[1]]))


