### Making eins-with-group
### list of all EIN's that could possibly have a group number
### keeping all useful information 

## 
library(tidyverse)
library(knitr)
bmf.master <- read_csv("https://nccsdata.s3.amazonaws.com/raw/bmf/2023-08-BMF.csv")
load("affiliate/data-rodeo/IRS-EO.Rda")
load("affiliate/data-rodeo/dat-core-group.RDA")
dat.soi <- read_csv("affiliate/data-rodeo/dat-soi-group.csv")

#any EIN in bmf master that could possibly be part of a group return
bmf.ein <-
  bmf.master%>%
  #format for joining later
  mutate(GEN = str_pad(as.character(GROUP), width = 4, side = "left", pad = "0")) %>% 
  mutate_at(vars(c(EIN, SUBSECTION, CLASSIFICATION,RULING, FOUNDATION, ACTIVITY, STATUS, FILING_REQ_CD, ACCT_PD )), 
            as.character) %>% 
  mutate(EIN = str_pad(EIN, 9, pad = "0", side = "left"),
         SUBSECTION = str_pad(SUBSECTION, 2, pad = "0", side = "left"),
         CLASSIFICATION = str_pad(CLASSIFICATION, 4, pad = "0", side = "left"),
         RULING = str_pad(RULING, 6, pad = "0", side = "left"),
         FOUNDATION = str_pad(FOUNDATION, 4, pad = "0", side = "left"),
         ACTIVITY = str_pad(ACTIVITY, 8, pad = "0", side = "left"),
         STATUS = str_pad(STATUS, 2, pad = "0", side = "left"),
         FILING_REQ_CD = str_pad(FILING_REQ_CD, 2, pad = "0", side = "left"),
         ACCT_PD = str_pad(ACCT_PD, 2, pad = "0", side = "left")
  ) %>% 
  select(-GROUP) %>%
  #keep only the ones in a group
  rowwise() %>%
  filter(GEN != "0000" | 
           FILING_REQ_CD == "3" | 
           grepl("Group Return", NAME, ignore.case = T) | 
           grepl("Group Return", SORT_NAME, ignore.case = T)| 
           AFFILIATION != 3)


#Core files have already screened for possible group return
core.ein <- dat.core  %>% 
  #only keep the most recent year
  group_by(EIN) %>% 
  slice_max(year)


#SOI files have already screened for possible group return
soi.ein <- dat.soi %>% 
  #only keep the most recent year
  group_by(EIN) %>% 
  slice_max(soi.year)

#any EIN in IRS EO that could possibly be part of a group return
#get EINs to keep 
ein.keep <- unique(bmf.ein$EIN, core.ein$EIN, soi.ein$EIN, fromLast = F)

eo.ein <- 
  eoALL %>%
  filter(AFFILIATION != 3 ) %>% #remove independent group
  #get rid of the ones with GEN == 0000, 
  #but keep those that are potnentially part of a group in a different data set
  filter(GROUP != "0000" | EIN %in% ein.keep) 

  
  



### Combine into one data set ------------------------------------
#join
df1 <-
  bmf.ein %>% 
  full_join(eo.ein)  %>% 
  full_join(soi.ein) %>% 
  full_join(core.ein)


#clean up data
df2<- 
  df1 %>% 
  #removing unneded columns
  select(-starts_with("ISSR"), -year, - soi.year) 


#Combining SORT_NAME, DBA_NAME
add_name_function <- function(dba, sort){
  temp.names <- unique(c(dba, sort))
  temp.names <- temp.names[!is.na(temp.names)]
  return(paste(temp.names, collapse = " "))
}

df3 <- 
  df2 %>% 
  rowwise() %>%
  mutate(NAME_ADDITIONAL  = add_name_function(DBA_NAME, SORT_NAME))
  

#Get getting if the EIN  has group return in the name or additional name 
df3 <-
  df3 %>% 
  mutate(HAS_GROUP_RETURN =
           base::grepl(pattern = "GROUP RETURN|GRP RETURN", x = NAME, ignore.case = TRUE) |
           base::grepl(pattern = "GROUP RETURN|GRP RETURN", x = NAME_ADDITIONAL, ignore.case = TRUE))


# When GEN is missing, fill it in with GROUP
# if both GEN and GROUP are present, I've verified that there are none that do not match
df3 <- df3 %>%   
  mutate(GEN = ifelse(is.na(GEN), GROUP, GEN)) %>%
  select(-GROUP)


#do the same thing with GEN and GRP_EXMPT_NUM
#there are two errors in GRP_EXMPT_NUM I am manually fixing
df3$GRP_EXMPT_NUM[df2$EIN == "344237230"] <- 0102
df3$GRP_EXMPT_NUM[df2$EIN == "990145127"] <- 2457

df3 <- 
  df3 %>%
  mutate(GRP_EXMPT_NUM = str_pad(GRP_EXMPT_NUM, 4, pad = "0", side = "left")) %>% 
  mutate(GEN = ifelse(is.na(GEN), GRP_EXMPT_NUM, GEN))  %>% 
  select(-GRP_EXMPT_NUM)



#same thing for affiliation and afcd, but there are 3 that disagree,
#but they disagree in a way that the affiliation code is acceptable 
#EIN 455362006 has AFFLIATION = 7 and AFCD = 9. Both are subordinate designations so we keep with AFFLIATION = 7
#EIN 264373000 has AFFLIATION = 9 and AFCD = 7. Both are subordinate designations and this EIN is clearly a religious org so we keep with AFFLIATION = 9
#EIN 650839302 has AFFLIATION = 8 and AFCD = 6. Both are central organization, and this EIN is clearly a church so we keep with AFFLIATION = 8

df3 <- df3 %>%   
  mutate(AFFILIATION = as.character(AFFILIATION)) %>%
  mutate(AFFILIATION = ifelse(is.na(AFFILIATION), AFCD, AFFILIATION)) %>%
  select(-AFCD)

# SPLITTING AFFILATION into AFF_ROLL and RELIGIOUS
#AFF_ROLL is the roll that orgs plays in their respective affiliation structure: independent, parent, or subordinate
df3 <- 
  df3 %>% 
  rowwise() %>%
  mutate(AFF_ROLL = case_when(
    AFFILIATION == "3" ~ "independent",
    AFFILIATION %in% c("1", "6", "8") ~ "parent",
    AFFILIATION %in% c("2", "7", "9") ~ "subordinate"
  )) %>% 
  mutate(RELIGIOUS = ifelse(
    AFFILIATION == "8" | FOUNDATION == "10" | FILING_REQ_CD == "13" | (SUBSECTION == "3" & CLASSIFICATION == "7") | SUBSECTION == "40",
    "yes", "no"))
  

#renaming some variables to more clearly name where they came from 
df3 <- 
  df3 %>%
  rename(NTEE_IRS = NTEE_CD) 




#save 
dat.all.with.group <- df3
save(dat.all.with.group, file = "affiliate/data-rodeo/ein-group-info.Rda")

