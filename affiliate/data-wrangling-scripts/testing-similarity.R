### Testing Similarity of names with a GEN
# test scrip to test some ideas of how the similarity of names with a GEN can be quantified 


library(stopwords)



df <- GEN_ParentName_crosswalk[[5]][[68]]
#df <- GEN_ParentName_crosswalk[[5]][[44]]


df <- df %>% 
  left_join(dat.all %>% 
              filter( EIN %in% df$EIN) %>%
              select(EIN, NAME_ADDITIONAL)) %>% 
  distinct()

parent.name <- df$NAME[1]
sub.name <- df$NAME[2]

raw.dist <- adist(parent.name, sub.name, partial = T, ignore.case = T)


#maximum possible distance between two strings of the same length
#The maximum Levenshtein distance (all chars are different) is max(string1.length, string2.length)


percent.diff <- raw.dist/max.dist
percent.diff


df$percent.diff <- NA
parent.name <- unique(df$NAME[df$AFF_ROLL == "parent"])

for(i in 1:nrow(df)){
  #get the name 
  sub.name <- df$NAME[i]
  
  #find the distance to the parent name 
  raw.dist <- adist(sub.name, parent.name, partial = T, ignore.case = T)
  
  #find the max distance
  max.dist <- max(nchar(parent.name), nchar(sub.name))
  
  #save the percent distance 
  df$percent.diff[i] <- raw.dist/max.dist
  
}

#is any of these per.diff an outlier? 
Q3 <- quantile(df$percent.diff[df$AFF_ROLL != "parent"], 0.75) 
Q1 <- quantile(df$percent.diff[df$AFF_ROLL != "parent"], 0.25)

outlier <- Q3 + 1.5*(Q3 - Q1)

df$is.outlier <- df$percent.diff >= outlier
df %>% View


## I think this is good on name alone, but we might need more info than just name to get this confidence correct 



### Trying on all the data 
dat.test <- GEN_name_crosswalk

for(j in 1:nrow(dat.test)){
  
  dat.temp <- dat.test[[5]][[j]]
  
  dat.temp$percent.diff <- NA
  parent.name <- dat.test$AFF_NAME[j]
  
  
  for(i in 1:nrow(dat.temp)){
    #get the name 
    sub.name <- dat.temp$NAME[i]
    
    #find the distance to the parent name 
    raw.dist <- adist(sub.name, parent.name, partial = T, ignore.case = T)
    
    #find the max distance
    max.dist <- max(nchar(parent.name), nchar(sub.name))
    
    #save the percent distance 
    dat.temp$percent.diff[i] <- raw.dist/max.dist
    
  }
  
  Q3 <- quantile(dat.temp$percent.diff[dat.temp$AFF_ROLL != "parent" & dat.temp$percent.diff > 0], 0.75, na.rm = T) 
  Q1 <- quantile(dat.temp$percent.diff[dat.temp$AFF_ROLL != "parent" & dat.temp$percent.diff > 0], 0.25, na.rm = T)
  
  outlier <- Q3 + 1.5*(Q3 - Q1)
  
  dat.temp$is.outlier <- dat.temp$percent.diff >= outlier
  
  dat.test[[5]][[j]] <- dat.temp
  
  
}


#HOW MANY OUTLIERS ARE THERE? 
count <- rep(0, nrow(dat.test))
for(i in 1:nrow(dat.test)){
  dat.temp <- dat.test[[5]][[i]]
  count[i] <- sum(dat.temp$is.outlier, na.rm =  TRUE)
}
sum(count)
mean(count)
mean(count / dat.test$NUM_EINS)
hist(count)
hist(count / dat.test$NUM_EINS)

which(count == max(count))
dat.test$AFF_NAME[374]
dat.test[[5]][[374]] %>% View

#we need to drop stop words 