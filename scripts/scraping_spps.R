
##Note: have to put all URLs inside double quotes.

download_articles_spps = function(volume,
                               SPPS_URL = "https://journals.sagepub.com/doi/pdf/",
                               SPPS_DOWNLOAD_URL = "/?download=true",
                               SPPS_BASE_URL = "https://journals.sagepub.com/toc/sppa",
                               SPPS_VOLUME_BASE_URL = "https://journals.sagepub.com/loi/sppa/group/",
                               startdir = "~/Downloads",
                               enddir = "~/Documents/Miami!/Year 2/DARNFiles/" ) {
  require(rvest)
  require(stringr)
    startdir = startdir
    enddir = enddir
    if (!dir.exists(enddir)) {
      dir.create(file.path(enddir), recursive=TRUE)
    }


    if (volume > 10){
      spps_decade = "d2020"
    } else if (volume<11) {
      spps_decade="d2010"
    } else {spps_decade='ERROR'}
    spps_year = paste0('y',toString(volume+2009))

    volumeurl = paste0(SPPS_VOLUME_BASE_URL, spps_decade) %>%
      paste(spps_year, sep='.')
    volumepage = read_html(volumeurl)
    volumelinks <- volumepage %>% html_nodes("a") %>% html_attr("href")
    volumelinks <- volumelinks[which(regexpr(toString(volume), volumelinks) >= 1 & regexpr('toc', volumelinks) >= 1)]


    for (j in 1:length(volumelinks)) {
      url = paste(SPPS_BASE_URL, volume, j, sep = '/')
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

