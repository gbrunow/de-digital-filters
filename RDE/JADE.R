JADE <- function(D, eval, NP = D*10, n = 1500, minB = -100, maxB = 100, maxASize = NP, feedback = NULL){
  source("DESupportFunctions.R")
  
  mcr <- 0.5
  mf <- 0.5
  A <- matrix(NA, D, maxASize)         #archive of solutions that improved compared to the previous generation
  archive <- archiver(A, maxASize)
  
  # --- randomly initialize population --- #
  pop <- matrix(runif(NP*D, minB, maxB), D, NP)
  
  score <- eval(pop)
  
  popStd <- apply(pop, 2, sd)
  
  f <- matrix(1, D,NP)         #scale factor/mutation factor ("mutation" weight)
  cr <- matrix(1,1,NP)*0.25    #crossover propability
  g <- 0                       #generation
  
  # d <- 0.1
  # alpha <- 0.06
  # zeta <- 1
  # 
  
  diversify <- diversifier(n, D)
  p <- 0.9
  # mCR <- matrix(1,1,NP) * 0.5        #µCR
  # mF <- matrix(1,1,NP) * 0.5         #µF
  # C <- 0.35
  c_m <-  0.35
  # SCR <- vector(mode = "numeric")    #List of successfull probabilities CR
  # SF <- vector(mode = "numeric")     #List of successfull scale factors F
  
  top <- round(NP*(1-p))

  
  # --- frequentely usend values ---#
  all <- 1:NP
  
  while(g < n && !is.na(match(TRUE, popStd > 0))){
    g <- g + 1
    
    scoreOrdering <- order(score)
    pBest <- scoreOrdering[1:top]
    best <- pop[ 1:D, sample(pBest, NP, replace = TRUE)]
    
    cr <- rnorm(NP, mean = mcr, sd = 0.1)
    
    f <- rcauchy(n = NP, location = mf, scale = 0.1)
    negatives <- f < 0
    while(!is.na(match(TRUE, negatives))){
      newF <- rcauchy(n = NP, location = mf, scale = 0.1)
      f[negatives] <- newF[negatives]
      negatives <- f < 0
    }
    f[f > 1] <-  1
    #f <-  matrix(rep(f,D), D, NP, byrow = TRUE)
    # f <-  f %*% diag(fi)
    
    #-------- determine wether to cross or not --------#
    cross <- matrix(nrow = D, ncol = NP)
    CRCross <- matrix(runif(NP*D, 0, 1), D, NP)
    for(i in 1:D){
      cross[i,all] <- sample(1:D, NP, replace = TRUE) == D;
      CRCross[i,all] <- CRCross[i,all] < cr
    }
    cross <- cross | CRCross
    #--------------------------------------------------#
    
    popOld <- pop
    oldScore <- score
    
    #-------- actual crossisng --------#
    a <- A[!is.na(A)]
    pop <- pop + (((pop - best) + mutator(pop, a)) %*% diag(f)) * cross 
    
    pop <- diversify(pop, popOld, g)
    
    pop[pop < minB] <- minB
    pop[pop > maxB] <- maxB
    
    score <- eval(pop)
    improved <- score < oldScore
    improved <- improved & !is.na(improved)

    #-------- restore individuals who got worse from previous generation  --------#
    pop[1:D, !improved] <- popOld[1:D, !improved]
    
    #-------- save good solution to the archive --------#
    improvements <- pop[1:D, improved]

    A <- archive(improvements)
    
    sf <- f[improved]
    scr <- cr[improved]
    
    mcr <-  (1 - c_m) * mcr + c_m * mean(scr)
    mf <- (1 - c_m) * mf + c_m * meanl(sf)
    
    popStd <- apply(pop, 2, sd)
    
    if(!is.null(feedback) && g %% (n/100) == 0) {
      feedback(pop,score)
      print(g) 
    }
  }
  
  pop[1:D, order(score)[1]]
  
}