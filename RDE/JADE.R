JADE <- function(D, NP = D*10, eval, n = 1500, minB = -100, maxB = 100){
  source("DESupportFunctions.R")
  
  G <- 0                       #generation
  F <- matrix(1, D,NP)         #scale factor/mutation factor ("mutation" weight)
  CR <- matrix(1,1,NP)*0.25    #crossover propability
  
  d <- 0.1
  alpha <- 0.06
  zeta <- 1
  
  P <- 0.9
  mCR <- matrix(1,1,NP) * 0.5        #µCR
  mF <- matrix(1,1,NP) * 0.5         #µF
  C <- 0.35
  SCR <- vector(mode = "numeric")    #List of successfull probabilities CR
  SF <- vector(mode = "numeric")     #List of successfull scale factors F
  
  top <- round(NP*(1-P))
  
  # --- randomly initialize population --- #
  pop <- matrix(runif(NP*D, minB, maxB), NP, D)
  
  score <- eval(pop)
  
  popStd <- apply(pop, 2, sd)
  
  while(G < n && !is.na(match(TRUE, popStd > 0))){
    G <- G + 1
    popOld <- pop
    
    crossingTargets <- crosser(NP)
    
    #-------- determine wether to cross or not --------#
    cross <- matrix(nrow = D, ncol = NP)
    for(i in 1:D){
      cross[i,1:NP] <- sample(1:D, NP, replace = TRUE) == D;
    }
    CRCross <- matrix(runif(NP*D, 0, 1), D, NP) < CR
    cross <- cross | cross
    #--------------------------------------------------#
    
    oldScore <- score
    
    score <- eval(pop)
    
    scoreOrdering <- order(score)
    pBest <- scoreOrdering[1:top]
    best <- pop[sample(pBest, 1), 1:D]
    
    mCR <-  (1-C) * mCR + C * mean(SCR)
    CR <- mean(mCR) + 0.1 * rnorm(NP)
    
    Fi <- mF + 0.1 * rcauchy(NP)
    Fi[Fi > 1] <-  1
    negatives <- Fi < 0
    while(!is.na(match(TRUE, negatives))){
      newFi <- mF + 0.1 * rcauchy(NP)
      Fi[negatives] <- newFi[negatives]
      negatives <- Fi < 0
    }
    
    third <- sample(1:NP, floor(NP/3))
    
    
  }
  
}