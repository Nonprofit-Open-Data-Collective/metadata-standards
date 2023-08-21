### FUnction to scrape propublica and get the GEN of any given EIN

# Libraries 
library(httr)
library(rvest)
library(XML)


#The function - input `ein` as characterstring
scrape_gen <- function(ein){
  url <- paste0("https://projects.propublica.org/nonprofits/organizations/", ein)
  
  tryCatch({
    # Open link
    page <- GET(url)
    # Parse page
    page_content <- content(page, "text")
    soup <- read_html(page_content)
    # Extract most recent 990 link
    href_string <- soup %>%
      html_nodes(".filings .single-filing.cf .left-label .action.xml") %>%
      html_attr("href")
    # Extract the relevant link
    url2 <- paste0("https://projects.propublica.org", href_string[1])
    # Open link
    response <- GET(url2)
    # Parse XML
    root <- xmlRoot(xmlTreeParse(content(response, "text"), useInternalNodes = TRUE))
    namespaces <- c(irs = "http://www.irs.gov/efile")
    # Extract exemption number
    group_exemption_num_element <- getNodeSet(root, "//irs:GroupExemptionNum", namespaces = namespaces)
    group_exemption_num <- xmlValue(group_exemption_num_element[[1]])
    ret <- group_exemption_num
    return(ret)
  }, error = function(e) {
    return(NA)
  })
  }