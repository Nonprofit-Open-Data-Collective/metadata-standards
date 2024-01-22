### Trying to figure out how the psych package calculate the scores

library(psych)

### Read in Data -----------------------------
#see governance/governance-factor-analysis for how this matrix was created
load("governance/governance-design-matrix.Rdata")

### Make Model ---------------------------------
model2.6 = fa(features2, nfactor=6, cor="poly", fm="mle", rotate = "equamax", 
              scores = "Thurstone")

#How things should be calculated
#S = DW
#W = C^-1 L



### How it is 
data.scaled <- scale(features2)
D <- data.scaled
C <- model2.6$r  # =  polychoric(features2)$rho
#C - polychoric(features2)$rho
W <- model2.6$weights
L <- model2.6$loadings #same as model2.6$Structure
S <- model2.6$scores
n <- nrow(features2)

#S = DW so lets check DW - S
D %*% W - S

# it should be W = C^-1 L
#but in their weight, they are using the pearson correlation for C
C.pearson = cor(features2)
(solve(C.pearson) %*% L) - W


### How it should be 
new.score <- factor.scores(features2, model2.6, rho = polychoric(features2)$rho,
                           method = "Thurstone")
W.poly = new.score$weights

C.poly <- polychoric(features2)$rho
solve(C.poly) %*% L - W.poly
