### Function to read in new data, and return appended scores. 

get_scores <- function(feature.matrix){
  
  ### Inputs
  # data.matrix - a n*12 matrix responses to the questions for the orgs you wish to get a score for 
    # output of get_data function
    # rows are each org
    # cols are the responses to (in this order)
    # "P12_LINE_1", "P4_LINE_12", "P4_LINE_28", "P4_LINE_29_30", "P6_LINE_1", "P6_LINE_11A", 
    # "P6_LINE_15A", "P6_LINE_18", "P6_LINE_2", "P6_LINE_3", "P6_LINE_8A", "P6_LINE_12_13_14"
  
  
  load("governance/pkg-funcs/factor-objects.Rdata")
  
  ### Make sure data is formatted correctly -------------------------------------
  col.names.correct <- colnames(features2[, 1:12])
  
  
  #does data have the correct colnames 
  feature.matrix <- as.data.frame(feature.matrix)
  if(all(col.names.correct %in% colnames(feature.matrix))){
    temp.dat <- feature.matrix[, col.names.correct]
  }else{
    stop("data object does not include necessary factors as columns")
  }
  
  # check matrix is entiryly of 0 and 1's 
  temp.dat <- as.data.frame(sapply(feature.matrix, as.numeric))
  all.0.or.1 <- all(temp.dat == 0 | temp.dat == 1) 
  if(!all.0.or.1){
    stop("data object must only have 0 or 1 entries for all factors")
  }
  

  ### Get New Factor Scores -------------------------
  scores <- factor.scores(temp.dat, #new data  
                          model2.6, #original fitted model of features2
                          rho = poly.cor, #polychoric correlation of features2
                          method = "Thurstone") #using regression equation to "predict" new scores. 
  
  ### Append scores to data object
  scores.keep <- as.data.frame(scores$scores)
  scores.keep$total.score <- rowSums(scores.keep)
  
  feature.matrix <- cbind(feature.matrix, scores.keep)
  
  ### Return
  return(feature.matrix)
  
  
}



