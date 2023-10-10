
##Note: have to put all URLs inside double quotes.



download_articles_pspb <- function(volume,
                                   PSPB_URL = "https://journals.sagepub.com/doi/pdf/",
                                   PSPB_DOWNLOAD_URL = "/?download=true",
                                   PSPB_BASE_URL = "https://journals.sagepub.com/toc/pspc",
                                   PSPB_VOLUME_BASE_URL = "https://journals.sagepub.com/loi/pspc/group/",
                                   startdir = "~/Downloads",
                                   enddir = "~/Documents/Miami!/Year 2/DARNFiles/") {
  startdir <- startdir
  enddir <- enddir
  require(rvest)
  require(stringr)

  if (!dir.exists(enddir)) {
    dir.create(file.path(enddir),
               recursive=TRUE)
  }

  if (volume < 6){
    pspb_decade <- "d1970"
  } else if (volume<50) {
    pspb_decade <- paste0('d', toString((volume + 1974) - ((volume + 1974) %% 10)))
  } else {
    pspb_decade <- 'ERROR'
    }
  pspb_year = paste0('y',toString(volume + 1974))

  volumeurl = paste0(PSPB_VOLUME_BASE_URL, pspb_decade) %>%
    paste(pspb_year, sep='.')
  volumepage = read_html(volumeurl)
  volumelinks <- volumepage %>% html_nodes("a") %>% html_attr("href")
  volumelinks <- volumelinks[which(regexpr(toString(volume), volumelinks) >= 1 & regexpr('toc', volumelinks) >= 1)]


  for (j in 1:length(volumelinks)) {
    url = paste(PSPB_BASE_URL, volume, j, sep = '/')
    page=read_html(url)
    links <- page %>% html_nodes("a") %>% html_attr("href")
    links <- links[which(regexpr('abs', links) >= 1)]

    urlPart1 = PSPB_URL
    urlYear = links %>% str_replace(".*abs/", "")
    urlPart2 = PSPB_DOWNLOAD_URL
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

#I would love to know how to get within the function to examine aspects of the environment, but alas.
#I've been manually running the lines of the function and the issue's coming at line 34, with read_html.
#I've tried adding in a header and identifying myself with 'user-agent', but that didn't seem to do anything. :(


###PROBLEM below
#Set up warning/issue if files don't copy
#Check that the numbers are equal, if not, print something warning that not all were transferred, but not likely to happen

