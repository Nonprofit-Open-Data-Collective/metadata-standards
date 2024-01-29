##### Make factor object and Store Data###########
# To be used later when making a governance score 
# only need to run this once to store the data object

### Libraries --------------------------------
library(psych)

### Read in Data -----------------------------
#see governance/governance-factor-analysis for how this matrix was created
load("governance/governance-design-matrix.Rdata")

### Make Model ---------------------------------
# use polychoric correlations
model2.6 = fa(features2, nfactor=6, cor="poly", fm="mle", rotate = "equamax", 
              scores = "Thurstone")

### Calculating Polychoric correlations 
poly.cor <- polychoric(features2)$rho

### Calculating Scores -------------------------------------------------
# do not rely on output from fa.model object. 
# fa.model object uses the incorrect correlation matrix. 
# You must specify using the polychoric correlations to calculate the scores 
# Use "Thurstone" for scores method to get regression calculations
scores <- factor.scores(features2, 
                        model2.6, 
                        rho = polychoric(features2)$rho,
                        method = "Thurstone")

# add scores + total score to feature2 matrix 
features2 <- as.data.frame(cbind(features2, scores$scores))
features2$total.score <- rowSums(features2[ ,c(paste0("ML", 1:6))])


### Saving these objects to be used in governance score
save.image(file = "governance/pkg-funcs/factor-objects.Rdata")

### Objects in this  R data
# features2 = design matrix with scores 
# features2_ID = ID/EIN/AWS information of each entry used in the features2 matrix, matches on row. 
# model2.6 = EFA model with 6 factors
# scores = scores from model2.6 using polychoric correlations
# poly.cor = polychoric correlations of features2