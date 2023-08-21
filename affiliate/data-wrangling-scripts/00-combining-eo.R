#### Combining EO Files from 
#https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf

### Libraries ----------------------------------
library(readr)


### Read in Raw data----------------------------------------------------------
eo1 <- read_csv("https://www.irs.gov/pub/irs-soi/eo1.csv")
eo2 <- read_csv("https://www.irs.gov/pub/irs-soi/eo2.csv")
eo3 <- read_csv("https://www.irs.gov/pub/irs-soi/eo3.csv")
eo4 <- read_csv("https://www.irs.gov/pub/irs-soi/eo4.csv")
eoINT <- read_csv("https://www.irs.gov/pub/irs-soi/eo_xx.csv") #international 
eoPR <- read_csv("https://www.irs.gov/pub/irs-soi/eo_pr.csv") #Puerto Rico

### Combine into one and save -----------------------------------------------
eo4$CLASSIFICATION <- as.character(eo4$CLASSIFICATION)
eoINT$CLASSIFICATION <- as.character(eoINT$CLASSIFICATION)
eoPR$CLASSIFICATION <- as.character(eoPR$CLASSIFICATION)


df_list <- list(eo1, eo2, eo3, eo4, eoINT, eoPR)
eoALL <- df_list %>% reduce(full_join)

save(eoALL, file = "affiliate/data-rodeo/IRS-EO.Rda")
