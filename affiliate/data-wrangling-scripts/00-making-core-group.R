### download core files and only keep variables related to group numbers 
library(readr)
library(dplyr)

### Function for 2015 and before 
get_core <- function(year){
  ## Get Paths
  path.co <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "co.csv")
  path.pf <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/nccs.core", year, "pf.csv")
  path.pc <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/nccs.core", year, "pc.csv")
  
  
  ## Get files
  core.co <- read_csv(path.co,
                      col_select= any_of(c("EIN", "NAME",  "AFCD", "GEN")))
  
  core.pf <- read_csv(path.pf,
                      col_select = any_of(c("EIN", "NAME",  "AFCD", "GEN")))
  
  core.pc <- read_csv(path.pc,
                      col_select = any_of(c("EIN", "NAME", "AFCD", "GEN")))
  
  
  #combine into one
  df.list <- list(core.co, core.pf, core.pc)
  core.combine <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)
  
  #keep only cases that are affiliated with a group
  if("AFCD" %in% colnames(core.combine)){
    core.combine <- 
      core.combine %>% 
      filter(AFCD %in% c(6, 7, 8, 9)) %>%
      mutate(year = year)
  }
  if(!("GEN" %in% core.combine)){core.combine$GEN<-NA}
  
  
  #keep large file 
  assign('dat.return', core.combine)
  
  ## clean up 
  rm(list=ls(pattern="core."))
  
  return(dat.return)

}





### 2019 ----------------------------------------------------
year = 2019
  
## Get Paths
path.co <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "co.csv")
path.pf <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "pf.csv")
path.pc <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "pc.csv")


## Get files
core.co <- read_csv(path.co,
                    col_select= any_of(c("EIN", "NAME",  "AFCD", "GEN")))

core.pf <- read_csv(path.pf,
                    col_select = any_of(c("EIN", "NAME",  "AFCD", "GEN")))

core.pc <- read_csv(path.pc,
                    col_select = any_of(c("EIN", "NAME", "AFCD", "GEN")))


#combine into one
df.list <- list(core.co, core.pf, core.pc)
core.combine <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)

#keep only cases that are affiliated with a group
if("AFCD" %in% colnames(core.combine)){
  core.combine <- 
    core.combine %>% 
    filter(AFCD %in% c(6, 7, 8, 9)) %>%
    mutate(year = year)
}

## add GEN column if there is none
if(!("GEN" %in% core.combine)){core.combine$GEN<-NA}

#keep large file 
assign(paste0("dat.", year), core.combine)

## clean up 
rm(list=ls(pattern="core."))

### 2018 ----------------------------------------------------
year = 2018

## Get Paths
path.co <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "co.csv")
path.pc <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "pc.csv")


## Get files
core.co <- read_csv(path.co,
                    col_select= any_of(c("EIN", "NAME",  "AFCD", "GEN")))

core.pf <- read_csv(path.pf,
                    col_select = any_of(c("EIN", "NAME",  "AFCD", "GEN")))


#combine into one
df.list <- list(core.co, core.pf)
core.combine <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)

#keep only cases that are affiliated with a group
if("AFCD" %in% colnames(core.combine)){
  core.combine <- 
    core.combine %>% 
    filter(AFCD %in% c(6, 7, 8, 9)) %>%
    mutate(year = year)
}
if(!("GEN" %in% core.combine)){core.combine$GEN<-NA}


#keep large file 
assign(paste0("dat.", year), core.combine)

## clean up 
rm(list=ls(pattern="core."))

### 2017 ----------------------------------------------------
year = 2017

## Get Paths
path.co <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "co.csv")
path.pc <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "pc.csv")


## Get files
core.co <- read_csv(path.co,
                    col_select= any_of(c("EIN", "NAME",  "AFCD", "GEN")))

core.pc <- read_csv(path.pc,
                    col_select = any_of(c("EIN", "NAME", "AFCD", "GEN")))


#combine into one
df.list <- list(core.co, core.pc)
core.combine <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)

#keep only cases that are affiliated with a group
if("AFCD" %in% colnames(core.combine)){
  core.combine <- 
    core.combine %>% 
    filter(AFCD %in% c(6, 7, 8, 9)) %>%
    mutate(year = year)
}
if(!("GEN" %in% core.combine)){core.combine$GEN<-NA}

#keep large file 
assign(paste0("dat.", year), core.combine)

## clean up 
rm(list=ls(pattern="core."))






  
### 2016 ----------------------------------------------------
year = 2016

## Get Paths
path.co <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.coreco.core", year, "co.csv")
path.pc <- paste0("https://nccs-data.urban.org/dl.php?f=core/", year, "/coreco.core", year, "pc.csv")


## Get files
core.co <- read_csv(path.co,
                    col_select= any_of(c("EIN", "NAME",  "AFCD", "GEN")))


core.pc <- read_csv(path.pc,
                    col_select = any_of(c("EIN", "NAME", "AFCD", "GEN")))


#combine into one
df.list <- list(core.co, core.pc)
core.combine <- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)

#keep only cases that are affiliated with a group
if("AFCD" %in% colnames(core.combine)){
  core.combine <- 
    core.combine %>% 
    filter(AFCD %in% c(6, 7, 8, 9)) %>%
    mutate(year = year)
}
if(!("GEN" %in% core.combine)){core.combine$GEN<-NA}


#keep large file 
assign(paste0("dat.", year), core.combine)

## clean up 
rm(list=ls(pattern="core."))

### 2015 - 2000----------------------------------------------------
for(i in 2000:2015){
  assign(paste0("dat.", i), get_core(i))
  paste("Done with", i)
}

#merge ------------------------------------------
df.names <- ls()[ls() %>% startsWith("dat.20")]
df.list <-  vector(mode = "list", length = length(df.names))
for(i in 1:length(df.names)){df.list[[i]] <- get(df.names[i])}


dat.core<- Reduce(function(x, y) merge(x, y, all=TRUE), df.list)

### Save --------------------
save(dat.core, file = "data-rodeo/dat-core-group.RDA")

# 
# 
# 
# 
# 
# ### Merge into one - keep only most recent EIN listing
# ### Merge into one 
# df.names <- ls()[ls() %>% startsWith("dat.20")]
# df.list <-  vector(mode = "list", length = length(df.names))
# for(i in 1:length(df.names)){df.list[[i]] <- get(df.names[i])}
# 
# ein.list <-  vector(mode = "list", length = length(df.names))
# for(i in 1:length(df.names)){ein.list[[i]] <- unique(df.list[[i]]$EIN)}
# 
# ## keep most recent listing of EIN's 
# dat.keep <- df.list[[20]]
# dat.keep$GEN <- NA
# ein.already.have <- ein.list[[20]]
# for(i in 19:1){
#   #store temp data
#   dat.temp <- df.list[[i]]
#   ein.temp <- ein.list[[i]]
#   
#   #find with records in the data set are new EIN's
#   ein.dont.need <- ein.temp %in%  ein.already.have
#   ein.keep.temp <- !ein.dont.need
#   
#   #only keep the new EIN's
#   dat.keep.temp <- dat.temp[ein.keep.temp, ]
#   if(!("GEN" %in% dat.keep.temp)){dat.keep.temp$GEN<-NA}
#   
#   #merge this with keep data
#   dat.keep <- rbind(dat.keep, dat.keep.temp)
#   
#   #update new ein list
#   ein.already.have <- dat.keep$EIN
#   
#   
# }
# 
# 
# 
