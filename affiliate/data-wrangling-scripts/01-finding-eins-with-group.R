### Making eins-with-group
### list of all EIN's that could possibly have a group number
### keeping all useful information 

## 
library(tidyverse)
library(knitr)
bmf.master <- readRDS("affiliate/data-raw/bmf-master.rds")
load("affiliate/data-rodeo/IRS-EO.Rda")
load("affiliate/data-rodeo/dat-core-group.RDA")
dat.soi <- read_csv("affiliate/data-rodeo/dat-soi-group.csv")

#any EIN in bmf master that could possibly be part of a group return
bmf.ein <-
  bmf.master%>%
  mutate(GEN = as.numeric(GEN))  %>%
  filter(!is.na(GEN) | 
           FRCD %in% c("30", "3")| 
           grepl("Group Return", NAME, ignore.case = T),
         grepl("Group Return", SEC_NAME, ignore.case = T)) %>% 
  #only keep columns that are useful 
  select(EIN:ZIP5, RULEDATE, FIPS, FNDNCD )


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


#Combining SEC_NAME, SORT_NAME, DBA_NAME
df2$NAME_ADDITIONAL <- NA


for(i in 1:nrow(df2)){
  #Find additional names and only keep the unique ones
  temp.names <- unique(c(df2$SEC_NAME[i], df2$SORT_NAME[i], df2$DBA_NAME[i]))
  temp.names <- temp.names[!is.na(temp.names)]
  
  df2$NAME_ADDITIONAL[i] <- paste(temp.names, collapse = " ")
}

df2 <- df2 %>% select(-c(SEC_NAME, SORT_NAME, DBA_NAME))

#Get getting if the EIN  has group return in the name or additional name 
df2 <-
  df2 %>% 
  mutate(HAS_GROUP_RETURN =
           base::grepl(pattern = "GROUP RETURN|GRP RETURN", x = NAME, ignore.case = TRUE) |
           base::grepl(pattern = "GROUP RETURN|GRP RETURN", x = NAME_ADDITIONAL, ignore.case = TRUE))


# When GEN is missing, fill it in with GROUP
# if both GEN and GROUP are present, I've verified that there are none that do not match
df2 <- df2 %>%   
  mutate(GEN = ifelse(is.na(GEN), GROUP, GEN)) %>%
  select(-GROUP)


#do the same thing with GEN and GRP_EXMPT_NUM
#there are two errors in GRP_EXMPT_NUM I am manually fixing
df2$GRP_EXMPT_NUM[df2$EIN == "344237230"] <- 0102
df2$GRP_EXMPT_NUM[df2$EIN == "990145127"] <- 2457

df2 <- 
  df2 %>%
  mutate(GRP_EXMPT_NUM = str_pad(GRP_EXMPT_NUM, 4, pad = "0", side = "left")) %>% 
  mutate(GEN = ifelse(is.na(GEN), GRP_EXMPT_NUM, GEN))  %>% 
  select(-GRP_EXMPT_NUM)


#same thing for subsection code, ruledate
df2 <- df2 %>%   
  mutate(SUBSECTION = ifelse(is.na(SUBSECTION), SUBSECCD, SUBSECTION)) %>%
  select(-SUBSECCD) %>%
  mutate(SUBSECTION = ifelse(is.na(RULEDATE), RULING, RULEDATE)) %>%
  select(-RULING) 

#same thing for affiliation and afcd, but there are 3 that disagree,
#but they disagree in a way that the affiliation code is acceptable 
#EIN 455362006 has AFFLIATION = 7 and AFCD = 9. Both are subordinate designations so we keep with AFFLIATION = 7
#EIN 264373000 has AFFLIATION = 9 and AFCD = 7. Both are subordinate designations and this EIN is clearly a religious org so we keep with AFFLIATION = 9
#EIN 650839302 has AFFLIATION = 8 and AFCD = 6. Both are central organization, and this EIN is clearly a church so we keep with AFFLIATION = 8

df2 <- df2 %>%   
  mutate(SUBSECTION = ifelse(is.na(AFFILIATION), AFCD, AFFILIATION)) %>%
  select(-AFCD)
  

#renaming some variables to more clearly name where they came from 
df2 <- 
  df2 %>%
  rename(NTEE_NCCS = NTEEFINAL,
         NTEE_IRS = NTEE_CD) 




#save 
write_csv(df2, "affiliate/data-rodeo/ein-group-info.csv")

