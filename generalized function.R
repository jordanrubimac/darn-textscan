download_articles <- function(volume,
                              journal = c("PSPB", "SPPS"),
                              BASE_URL = NULL,
                              VOLUME_BASE_URL = NULL,
                              URL = "https://journals.sagepub.com/doi/pdf/",
                              DOWNLOAD_URL = "/?download=true",
                              startdir = "~/Downloads",
                              enddir = "~/Documents/Miami!/Year 2/DARNFiles/",
                              provided_urls = NULL) {
  require(httr)
  require(rvest)
  require(stringr)
  
  journal <- match.arg(journal)

  if (!dir.exists(enddir)) {
    dir.create(file.path(enddir), recursive=TRUE)
  }

  # Decade and Year Calculation
  if (journal == "PSPB") {

    if(is.null(BASE_URL)) { BASE_URL = "https://journals.sagepub.com/toc/pspc" }

    if (volume < 6) {
      decade <- "d1970"
    } else if (volume < 50) {
      decade <- paste0('d', toString((volume + 1974) - ((volume + 1974) %% 10)))
    } else {
      decade <- 'ERROR'
    }
    year = paste0('y', toString(volume + 1974))
    nissues <- 12
  } else if (journal == "SPPS") {
    if(is.null(BASE_URL)) { BASE_URL = "https://journals.sagepub.com/toc/sppa" }

    if (volume > 10) {
      decade = "d2020"
    } else if (volume < 11) {
      decade = "d2010"
    } else {
      decade = 'ERROR'
    }
    year = paste0('y', toString(volume + 2009))
    nissues <- 8
  }

  #volumeurl = paste0(VOLUME_BASE_URL, decade) %>% paste(year, sep='.')
  #volumepage = GET(volumeurl, add_headers('user-agent' = 'Research Project')) %>% read_html()
  ##Error comes from above line: can't use read_html (403 error response again)
  #volumelinks <- volumepage %>% html_nodes("a") %>% html_attr("href")
  #volumelinks <- volumelinks[which(regexpr(toString(volume), volumelinks) >= 1 & regexpr('toc', volumelinks) >= 1)]
  #10/31: removed, because this was just getting the number of issues, which is consistent in each journal. See new
  #variable named 'nissues' created above.
  
  
  for (j in 1:nissues) {
    if (is.null(provided_urls)) {
      url = paste(BASE_URL, volume, j, sep = '/')
      page = GET(url, add_headers('user-agent' = 'Mozilla/5.0')) %>% read_html()
      ##Error is the above line: can no longer read the URLs on the page for each issue, which sucks.
      links <- page %>% html_nodes("a") %>% html_attr("href")
      links <- links[which(regexpr('abs', links) >= 1)]

      urlPart1 = URL
      urlYear = links %>% str_replace(".*abs/", "")
      urlPart2 = DOWNLOAD_URL
      urllist = paste(urlPart1, urlYear, urlPart2, sep = '')
    } else {
      urllist <- provided_urls
    }

    for (i in 1:length(urllist)) {
      browseURL(urllist[i])
    }

    filenames = urlYear %>% str_replace(".*10.1177/", "") %>% paste(".pdf", sep = '')
    date_time<-Sys.time()
    delay_seconds <- 70
    while((as.numeric(Sys.time()) - as.numeric(date_time))<delay_seconds){}

    # Check if files copied successfully
    copied_files <- sapply(paste0(startdir, filenames), function(src) {
      dest <- paste0(enddir, basename(src))
      file.copy(src, dest)
    })

    if (sum(copied_files) != length(filenames)) {
      warning("Not all files were transferred successfully.")
    }

    #file.remove(from=paste(startdir, filenames, sep="/"))
    #Removed for now, reason: file names aren't just the doi and pdf combined
  }
}
