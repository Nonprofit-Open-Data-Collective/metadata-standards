##### Make factor object and Store Data###########
# To be used later when making a governance score 
# only need to run this once to store the data object

### Libraries --------------------------------
library(psych)

### Read in Data -----------------------------
#see governance/governance-factor-analysis for how this matrix was created
load("governance/governance-design-matrix.Rdata")

### Make Model ---------------------------------
model2.6 = fa(features2, nfactor=6, cor="poly", fm="mle", rotate = "equamax", 
              scores = "Thurstone")

### Store Necessary object from model --------------------------
weights <- model2.6$weights
scores <- model2.6$scores

### Get scaling factors (were used in calculating weights, needed to scale new data)
data.scaled <- scale(features2)
scaled.mean <- attr(data.scaled, "scaled:center")
scaled.sd <- attr(data.scaled, "scaled:scale")

### Saving these objects to be used in governance score
save.image(file = "governance/pkg-funcs/factor-objects.Rdata")

### Objects in this  R data
# features2 - design matrix 
# model2.6 - EFA model with 6 factors 
# weights - weights from model2.6
# scores - scores from model2.6
# data.scaled = features2 but columns are scaled to have 0 mean and 1 sd
# scaled.mean = column means of features2
# scaled.sd = column sd of features2
