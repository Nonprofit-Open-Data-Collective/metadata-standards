library(dplyr)
library(ngram)
library(stopwords)
library(SemNetCleaner)

### Storing Stop Words
stop.words <- c(toupper(stopwords(source = "smart")), paste(utils::as.roman(1:10)))
#removing some stop words we want to keep 
stop.words <- stop.words[!(stop.words %in% c("OFF", "ALL", "NEW"))]



### Function to make a word singular
to_singluar <- function(word){
  
  #make lowercase for singularize 
  word1 <- tolower(word)
  
  #make signular
  word2 <-  singularize(word1, dictionary = FALSE)
  
  #if the word was originally lowercase, return word2, 
  #if the word was originally uppercase, return toupper(word2)
  if(word == word1){return(word2)}else{return(toupper(word2))}
  
}









find_parent_name <- function(child_names, min_phrase = 2){
  
  ### Purpose:
  # Find the most likely name of the parent organization from a data frame of child organizations
  
  ### Input
  # child_names = vector of names of the child organizations  (character string)
  # min_phrase = minimum number of words that make up a phrase, default is 2
  # e.g. child_names = c("Child Name 1", "Child Name 2", "Chile Name 3")
  # e.g. min_phrase = 2
  
  #If min_phrase = 1,we are less confident in our result since we are matching single words and not n-grams (n>1)
  #Recommended to only use min_phrase = 1, if min_phrase = 2 returns NA or a nonsensical result
  
  
  
  ### Output
  # most likely name of the parent or
  
  
  #Initilize a Data Frame
  temp_names <- data.frame(orig.name = child_names,
                           short.name = NA)
  #Initize a list for n-grams
  temp_list <- vector(mode = "list", length = nrow(temp_names))
  
  #Find the most common n-grams for n = 2,3,4,5,6
  
  for(j in 1:nrow(temp_names)){
    
    #remove stop words from the name
    temp_words <- tolower(temp_names$orig.name[j]) #to lower for singularize
    temp_words <- strsplit(temp_words, split = " |-")[[1]] #split
    temp_words <- unlist(lapply(temp_words, to_singluar)) #make each work singular
    #temp_words <- unlist(lapply(temp_words, singularize, dictionary = FALSE)) #run it twice to take care of situations like "childrens" to "child". This dones't actually help in many cases and isn't worth the extra run time
    temp_words <- toupper(temp_words[!(toupper(temp_words) %in% stop.words)])  #remove stop words and make upper case

    #remove words that are only numbers
    temp_words <- temp_words[grepl("\\D", temp_words)]
    
    #store phrase without stop words
    temp_names$short.name[j] <- paste(temp_words, collapse = " ")
    
    #max words to search for is the minimum of 6 and the number of words
    m <- max(min(6, length(temp_words)), min_phrase)
    if(m > min_phrase-1 & length(temp_words) > 0){
      temp_list[[j]] <- ngram_asweka(temp_names$short.name[j], min=min_phrase, max=m)
    }else{
      temp_list[[j]] <- ""
      }
  }
  
  
  # Make a data frame of the most common phrases
  temp <- unlist(temp_list) %>% table %>% sort(decreasing = TRUE)
  temp_df <- data.frame(names = names(temp),
                        count = c(unname(temp))) 
  
  #if everything has count == 1, return message "cannot find parent name"
  has.more.than.1 <- max(c(temp_df$count, 0)) > 1
  if(!has.more.than.1){
    warning("WARNING: Cannot find parent name. Child names are too unrelated. Returning NA.")
    return(NA)
    }
  
  #Some wrangling to prepare for search for most likely name
  
  t2 <- temp_df %>%
    #get rid of anything that is just a number 
    filter(grepl("\\D", names)) %>% 
    #remove words that are just stop words 
    filter(!(names %in% stop.words)) %>% 
    #find the number of words in each phrase
    rowwise() %>%
    mutate(num_words = lengths(strsplit(names, ' '))) %>% 
    arrange(desc(count),(num_words)) 
  
  #if there is a phrase that appears more than one, remove all phrases that appear only once
  #this is usually not entered if min_phrase = 1
  if(max(t2$count) > 1){
    t2 <- t2 %>% filter(count > 1)
  }

  
  #This is the crucial step
  #Find the longest phrase used most often that is not part of a phrase used less often
  continue = TRUE
  leftover_list <- t2
  current_guess <- leftover_list$names[1]
  current_count <- leftover_list$count[1]
  
  leftover_list <- leftover_list[-1, ]
  cn <- 1 #counter for fail safe
  
  while(continue){
    
    #is current_count unique?
    current_count_unique <- !(current_count %in% leftover_list$count)
    
    #if it is not unique, find the phrase with the same count but larger number of words, update the current guess
    if(!current_count_unique){
      current_guess <- leftover_list %>% filter(count == current_count) %>% arrange(num_words) %>% tail (1) %>% pull(names)
      
      #remove these words from the left over list
      leftover_list <- leftover_list %>% filter(count != current_count)
    }
    
    #if there is nothing in the leftover_list, stop the loop
    if(nrow(leftover_list) ==0){break}
    
    #Is the current guess part of a phrase with the next hightest count
    next_highest_count <- max(leftover_list$count, 0)
    new_phrase <- 
      leftover_list %>%
      #only look at the ones with the next hightest count
      filter(count == next_highest_count) %>% 
      #does the name have the current guess in it?
      mutate(has.phrase = grepl(current_guess, names)) %>%
      #only keep the ones that do
      filter(has.phrase == TRUE) %>%
      #only keep the one with the hightest word count
      filter(num_words == max(c(num_words,0), na.rm = TRUE)) %>%
      #only keep that phrase
      head(1) %>%
      pull(names)
    
    #if it is, update the current guess
    #if not, stop the loop
    if(!!length(new_phrase)){
      current_guess <- new_phrase
      continue <- TRUE
      
      #remove current guess from the left_over list
      leftover_list <- leftover_list %>% filter(names != current_guess)
    }else{
      continue <- FALSE
    }
    
    #fail-safe
    cn <- cn+1
    if(cn > 100){break}
  }
  
  
  ### Get most likely name 
  #find all the original names that match the current guess, take the one with the smallest number of words
  t3 <- temp_names %>%
    #keep ones with current_guess in the short name
    filter(grepl(current_guess, short.name)) %>% 
    #keep only the ones with the shortest number of words
    rowwise() %>%
    mutate(num_words = length(strsplit(short.name, " ")[[1]])) %>%
    ungroup()%>%
    filter(num_words == min(num_words))  %>%
    #only keep unique orig.names
    distinct(orig.name)
 
  #if this name is unique, return this name
  if(length(t3$orig.name) == 1){return(t3$orig.name)}
  
  #else search through the remaining names to find the one with the fewest words 
  #after removing every word that isn't a stop word or in the current guess
  
  t3$keep.name <- NA
  #list of all words to keep: current guess, signluarized current guess, and all stop words, the word "NO"
  keep_words_split <- strsplit(current_guess, " ")[[1]]
  keep_words <- c(keep_words_split, 
                  unlist(lapply(keep_words_split, to_singluar)),
                  stop.words[!(stop.words %in% c("NO"))])
  
  for(j in 1:nrow(t3)){
    #store the temp phrase
    temp_phrase <- t3$orig.name[j]
    #split
    temp_phrase <- strsplit(temp_phrase, " ")[[1]]
    temp_phrase2 <- unlist(lapply(temp_phrase, to_singluar)) #make each work singular
    #keep everything that is a stop word or in the original phrase (or a singlar version of the originial phrase)
    t3$keep.name[j] <- paste(temp_phrase[temp_phrase2 %in% keep_words], collapse = " ")
  }
  
  return_name <- 
    t3 %>%
    distinct(keep.name) %>%
    #find the number of words
    rowwise() %>%
    mutate(num_words = length(strsplit(keep.name, " ")[[1]])) %>%
    #keep only the name with the smallest number of words
    ungroup%>%
    filter(min(num_words) == num_words) %>%
    pull(keep.name)
  
  return(return_name)
  
  
  
}


# 
# 
# ### Testing
# find_parent_name(dat8$names[[12]])






  
