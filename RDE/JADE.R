JADE <- function(D, eval, NP = 75, n = 1000, minB = -100, maxB = 100, maxASize = NULL){
  source("DESupportFunctions.R")
  library('tcltk')

  if(is.null(maxASize)){
    maxASize = NP
  }
  
  mcr <- 0.5
  mf <- 0.5
  
  cr <- rep(mcr,NP)
  f <- rep(mf,NP)
  
  A <- matrix(NA, D, maxASize)         #archive of solutions that improved compared to the previous generation
  archive <- archiver(A, maxASize)
  archiveSize = 0;
  
  # --- randomly initialize population --- #
  pop <- matrix(runif(NP*D, minB, maxB), D, NP)
  
  score <- eval(pop)
  
  popStd <- rep(1,NP)
  
  g <- 0                       #generation
  
  diversify <- diversifier(n, D)
  
  p <- 0.9
  top <- round(NP*(1-p))
  c_m <-  0.35
  
  # create progress bar
  pb <- tkProgressBar(title = "Please wait...", min = 0, max = n, width = 300)
  
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
    
    #-------- determine wether to cross or not --------#
    cross <- matrix(nrow = D, ncol = NP)
    CRCross <- matrix(runif(NP*D, 0, 1), D, NP)
    for(i in 1:D){
      cross[i,1:NP] <- sample(1:D, NP, replace = TRUE) == D
      CRCross[i,1:NP] <- CRCross[i,1:NP] < cr
    }
    cross <- cross | CRCross
    #--------------------------------------------------#
    
    popOld <- pop
    oldScore <- score
    
    #-------- actual crossisng --------#
    m <- mutator(pop, A, archiveSize)
    pop <- pop[1:D,m$a] + (((pop[1:D,m$a] - best) + m$mutation) %*% diag(f)) * cross
    
    pop[pop > maxB] <- maxB
    pop[pop < minB] <- minB
    
    restore <- diversify(m$mutation, g)
    pop[restore] <- popOld[restore]
    
    score <- eval(pop)
    
    improved <- score < oldScore
    worse <- score > oldScore
    if(anyNA(worse)){
       print("NA!")
       eval(pop)
    }

    #-------- restore individuals who got worse from previous generation  --------#
    pop[1:D, worse] <- popOld[1:D, worse]
    score[worse] <- oldScore[worse]
    
    #-------- save good solution to the archive --------#
    improvements <- pop[1:D, improved]
    a <- archive(improvements)
    A <- a$A
    archiveSize <- a$size
    
    scr <- cr[improved]
    sf <- f[improved]
    
    if(length(scr) > 0){
      mean_scr <- meanl(scr);
    } else {
      mean_scr = 0;
    }
    if(length(sf) > 0){
      mean_sf <- mean(scr);
    } else {
      mean_sf = 0;
    }
    
    mcr <-  (1 - c_m) * mcr + c_m * mean_scr
    mf <- (1 - c_m) * mf + c_m * mean_sf
    
    popStd <- apply(pop, 2, sd)
    
    percentage <- (g/n)
    if(percentage %% 0.01 == 0) {
      setTkProgressBar(pb, g, label=paste(round(percentage*100, 0),"% done"))
    }
  }
  close(pb)
  pop[1:D, order(score)[1]]
  
}