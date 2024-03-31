#### Crosstabs with BMF and 501ctypes codes 

library(tidyverse)


## Import function for 501c type information
source("tax-exempt-status/func-501c-types.R")
set.seed(395)


## Import current BMF from URBAN
link <- "https://nccsdata.s3.us-east-1.amazonaws.com/legacy/bmf/BMF-2022-01-501CX-NONPROFIT-PX.csv"
bmf <- read_csv(link)


bmf_urban <-
  bmf %>% 
  #sample_n(10000) %>%
  select(FRCD, SUBSECCD, FNDNCD, LEVEL1, LEVEL2, FILER,
         STATE, NTEEFINAL, NTEECC, NTEE1, LEVEL3) %>% 
  mutate(new_columns = map(SUBSECCD, get_tax_exempt_type)) 

bmf_urban <- bmf_urban %>% 
  unnest(new_columns) 


### Import BMF From IRS - needed for duductibility code 
e01 <- "https://www.irs.gov/pub/irs-soi/eo1.csv"
e02 <- "https://www.irs.gov/pub/irs-soi/eo2.csv"
e03 <- "https://www.irs.gov/pub/irs-soi/eo3.csv"
e04 <- "https://www.irs.gov/pub/irs-soi/eo4.csv"

bmf_e01 <- read_csv(e01)
bmf_e02 <- read_csv(e02)
bmf_e03 <- read_csv(e03)
bmf_e04 <- read_csv(e04)

dfs <- list(bmf_e01, bmf_e02, bmf_e03, bmf_e03)

# Merge data frames
bmf_irs <- Reduce(function(x, y) merge(x, y, all = TRUE), dfs)

bmf_irs <-
  bmf_irs %>% 
  #sample_n(10000) %>%
  mutate(new_columns = map(SUBSECTION, get_tax_exempt_type)) 

bmf_irs <- bmf_irs %>% 
  unnest(new_columns) 



save(bmf_urban, bmf_irs, file = "tax-exempt-status/bmf-with-501ctype.Rdata")


##### FRCD Vs REQUIRED_990 --------------------
table(bmf_urban$FRCD, bmf_urban$required_990)

## Investigating the codes that are not classified correctly
bmf_urban %>% 
  filter(FRCD == "000" & required_990 == "Y") %>%
  pull(supporting) %>% 
  table()

bmf_urban %>% 
  filter(FRCD == "140" & required_990 == "Y") %>%
  pull(supporting) %>% 
  table()



# bmf_urban %>% 
#   select(FRCD, required_990) %>% 
#   group_by_all() %>% 
#   summarise(count = n() ) %>% 
#   pivot_wider(names_from = required_990, values_from = count)



##### FNDCD Vs Tax exempt subgroup --------------------
table(bmf_urban$FNDNCD, bmf_urban$tax_exempt_subgroup)


##### IRS Deductibility Vs  --------------------
table(bmf_irs$DEDUCTIBILITY, bmf_irs$donations_deductible)

bmf_irs %>% 
  filter(DEDUCTIBILITY == "1" & donations_deductible == "NO") %>%
  pull(SUBSECTION) %>% 
  table()



bmf_irs %>% 
  filter(DEDUCTIBILITY == "2" & (donations_deductible == "YE" | donations_deductible == "YU")) %>%
  pull(FILING_REQ_CD) %>%
  table()


bmf_irs %>% 
  filter(DEDUCTIBILITY == "2" & (donations_deductible == "YE" | donations_deductible == "YU")) %>%
  mutate(major.group = str_sub(NTEE_CD, 1, 1))%>%
  pull(major.group) %>%
  table()

bmf_irs %>% 
  filter(DEDUCTIBILITY == "4" & (donations_deductible == "NO")) %>%
  pull(SUBSECTION) %>% 
  table()


### Filer code -------------
table(bmf_irs$FOUNDATION, bmf_irs$govt_established)
table(bmf_irs$govt_established)

bmf_irs %>% 
  filter(FOUNDATION == "14") %>% 
  mutate(major.group = str_sub(NTEE_CD, 1, 1))%>%
  pull(major.group) %>%
  table()
  View()

  
### Status Code -----
table(bmf_irs$STATUS, bmf_irs$DEDUCTIBILITY)
table(bmf_irs$STATUS, bmf_irs$donations_deductible)
table(bmf_irs$donations_deductible, bmf_irs$DEDUCTIBILITY, bmf_irs$STATUS)
