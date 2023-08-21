##### Making SOI-group.csv
### This file contains all orgs in SOI files from years 2000-2019 that filed as part of a group

### Libraries
library(dplyr)
library(data.table)


### Needed functions 
get.soi.orgs <- function(year){
  temp.dir <- tempdir()
  
  
  year.2digit <- year %% 2000
  year.2digit <- ifelse(nchar(year.2digit) == 2, year.2digit, paste0("0", year.2digit))
  
  #get paths 
  path.c3z <- paste0("https://nccs-data.urban.org/dl.php?f=soi/", year, "/soi.soi", year.2digit, "c3z.csv")
  path.ot9 <- paste0("https://nccs-data.urban.org/dl.php?f=soi/", year, "/soi.soi", year.2digit, "ot9.csv")
  path.otz <- paste0("https://nccs-data.urban.org/dl.php?f=soi/", year, "/soi.soi", year.2digit, "otz.csv")
  
  #read in files + uniform formatting
  SOI.c3z <-  
    read_csv(path.c3z,
             col_select = matches(c("EIN", "NAME", "GRP_EXMPT_NUM", "COND"), ignore.case = TRUE)) %>%
    rename_with(toupper)
  
  SOI.otz <- 
    read_csv(path.otz,
            col_select = matches(c("EIN", "NAME", "GRP_EXMPT_NUM"), ignore.case = TRUE)) %>%
    rename_with(toupper)
  
  SOI.ot9 <- 
    read_csv(path.ot9,
             col_select = matches(c("EIN", "name", "grp_ret_for_afflts", "grp_exmpt_num"), ignore.case = TRUE)) %>%
    rename_with(toupper)
  
  #formatting group exemption number 
  if("GRP_EXMPT_NUM" %in% colnames(SOI.c3z)){
    SOI.c3z <- mutate(SOI.c3z, GRP_EXMPT_NUM = as.numeric(GRP_EXMPT_NUM))
    print("FIXED c3z")
  }
  if("GRP_EXMPT_NUM" %in% colnames(SOI.otz)){
    SOI.otz <- mutate(SOI.otz, GRP_EXMPT_NUM = as.numeric(GRP_EXMPT_NUM))
    print("FIXED otz")
  }
  if("GRP_EXMPT_NUM" %in% colnames(SOI.ot9)){
    SOI.ot9 <- mutate(SOI.ot9, GRP_EXMPT_NUM = as.numeric(GRP_EXMPT_NUM))
    print("FIXED ot9")
  }
  
  
  #join together
  dat.return <- 
    SOI.c3z %>% 
    #join all relevant information
    full_join(SOI.otz) %>%
    full_join(SOI.ot9) %>%
    #add indicator of what soi year it came from
    mutate(soi.year = year)
  
  rm(path.c3z, path.ot9, path.otz, SOI.c3z, SOI.otz, SOI.ot9)
  
  
  return(dat.return)

}


### Download all the needed data
soi.2012 <- get.soi.orgs(2012)
soi.2011 <- get.soi.orgs(2011)
soi.2010 <- get.soi.orgs(2010)
soi.2009 <- get.soi.orgs(2009)
soi.2008 <- get.soi.orgs(2008)
soi.2007 <- get.soi.orgs(2007)
soi.2006 <- get.soi.orgs(2006)
soi.2005 <- get.soi.orgs(2005)
soi.2004 <- get.soi.orgs(2004)
soi.2003 <- get.soi.orgs(2003)
soi.2002 <- get.soi.orgs(2002)
soi.2001 <- get.soi.orgs(2001)
soi.2000 <- get.soi.orgs(2000)



### Merge into one 
df.names <- ls()[ls() %>% startsWith("soi.20")]
df.list <-  vector(mode = "list", length = length(df.names))
for(i in 1:length(df.names)){df.list[[i]] <- get(df.names[i])}


dat.soi <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)


#keep only the ones that seem to be part of a group
dat.soi <- 
  dat.soi %>%
  filter(
    COND == "G" |
    !is.na(GRP_RET_FOR_AFFLTS)| 
    !is.na(GRP_EXMPT_NUM) | 
    grepl("Group RETURN", NAME, ignore.case = TRUE)) 

## Save -------------
write_csv(dat.soi, "data-rodeo/dat-soi-group.csv")

