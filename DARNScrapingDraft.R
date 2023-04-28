library(rvest)
SPPS_URL <- "https://journals.sagepub.com/doi/pdf/"
SPPS_DOWNLOAD_URL <- "/?download=true"
SPPS_BASE_URL <- "https://journals.sagepub.com/toc/sppa/13"
startdir = "~/Downloads"
enddir = "~/Documents/Miami!/Year 2/DARNFiles/"

#Sample URL: "https://journals.sagepub.com/toc/sppa/13/1"
##In reality: run function/sapply for multiple volumes at once 
##Probably: sapply(list of base URLs), download_files(1,8))


#Change function to input volume? Automate determining issues?
##Note: have to put the URL inside double quotes.
download_files = function(issuestart, issueend) {
    startdir="~/Downloads/"
    enddir = "~/Documents/Miami!/Year 2/DARNFiles/"
    if (!dir.exists(enddir)) {
      dir.create(file.path(enddir), recursive=TRUE)
    }
    
    for (j in issuestart:issueend) {
      url = paste(SPPS_BASE_URL, j, sep = '/')
      page=read_html(url)
      links <- page %>% html_nodes("a") %>% html_attr("href")
      links <- links[which(regexpr('abs', links) >= 1)]
      
      urlPart1 = SPPS_URL
      urlYear = links %>% str_replace(".*abs/", "")
      urlPart2 = SPPS_DOWNLOAD_URL
      urllist = paste(urlPart1, urlYear, urlPart2, sep = '')
      
      for (i in 1:length(urllist)){
        browseURL(urllist[i])
      }
      
      filenames = urlYear %>% str_replace(".*10.1177/", "") %>%
        paste(".pdf", sep = '') #List of file names for moving them
      
      Sys.sleep(15)   
      
      file.copy(from = paste0(startdir, filenames),
                to = paste0(enddir, filenames))
      file.remove(from=paste0(startdir, filenames))
    }
}




###PROBLEM below
#Set up warning/issue if files don't copy 
#Check that the numbers are equal, if not, print something warning that not all were transferred, but not likely to happen


##Another option: add loop
#SPPS: from volstart (8) and volend (14), append to https://journals.sagepub.com/toc/sppa/VOLNUM/ISSUENUM
#add to end: /IssueStart to /IssueEnd (1:8)


