library(stringr)
#Is there a way to make the paths consistent across people, like path through GitHub?
harzinglist <- read.csv("/Users/SchoolAccount/Documents/GitHub/darn-textscan/data/JPSP_deduplicated.csv")
zoterolist <- read.csv("/Users/SchoolAccount/Documents/GitHub/darn-textscan/data/JPSP_DARNZotero.csv")

#Find articles that were included in harzing and not in zotero
#Note: because of APA website, can't use DOI (harzing doesn't extract it). So, instead compare by title
#First, titles in the harzing list that aren't in the zotero list
zoterounknown <- harzinglist[which(!(harzinglist$DOI %in% zoterolist$DOI)),]
zoterounknown <- unknownarticles[which(!(tolower(str_sub(unknownarticles$Title, 1, 20)) %in% tolower(str_sub(zoterolist$Title, 1, 20)))),]

write.csv(zoterounknown, "jpsp_harzingnotzotero.csv")

#Then, docs in the harzing list that aren't in the zotero list
harzingunknown <- zoterolist[which(!(tolower(str_sub(zoterolist$Title, 1, 20)) %in% tolower(str_sub(harzinglist$Title, 1, 20)))),]
write.csv(harzingunknown, "jpsp_zoteronotharzing")

#Then, manually compare