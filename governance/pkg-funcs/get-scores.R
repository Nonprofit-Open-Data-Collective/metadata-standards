#' Function to read in new data and return appended scores.
#'
#' This function takes a matrix of responses to questions for organizations and appends 6 factor scores 
#' along with a total score to the input data.
#'
#' @param feature.matrix A matrix containing responses to questions for organizations. 
#' Output from `get_features` function.
#' Rows represent each organization, and columns represent responses to the following questions:
#' "P12_LINE_1", "P4_LINE_12", "P4_LINE_28", "P4_LINE_29_30", "P6_LINE_1", "P6_LINE_11A", 
#' "P6_LINE_15A", "P6_LINE_18", "P6_LINE_2", "P6_LINE_3", "P6_LINE_8A", "P6_LINE_12_13_14".
#'
#' @return A data frame with the original input data and appended 6 factor scores along with a total score.
#'
#' @details This function generates factor scores for observations in the `feature.matrix` from pre-loaded 
#' factor model ( in `factor-objects.Rdata`) 
#'
#' @references
#' Factor objects are loaded from "governance/pkg-funcs/factor-objects.Rdata".
#'
#' @importFrom governance.pkg.funcs factor.scores
#'
#' @seealso
#' \code{\link{get_features}} for formatting `feature.matrix`.
#'
#' @export
get_scores <- function(feature.matrix){
  
  # ... (Function implementation remains unchanged)
  
}




get_scores <- function(feature.matrix){
  ### Function to read in new data, and return appended scores. 
  
  ### Inputs
  # feature.matrix - a n*12 matrix responses to the questions for the orgs you wish to get a score for 
    # output of get_data function
    # rows are each org
    # cols are the responses to (in this order)
    # "P12_LINE_1", "P4_LINE_12", "P4_LINE_28", "P4_LINE_29_30", "P6_LINE_1", "P6_LINE_11A", 
    # "P6_LINE_15A", "P6_LINE_18", "P6_LINE_2", "P6_LINE_3", "P6_LINE_8A", "P6_LINE_12_13_14"
  
  ### Outputs 
  # feature.matrix with appended 6 factor scores and total score
  
  
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



