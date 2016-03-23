mutator <- function(pop, A = NULL, archiveSize = 0, cross = rep(TRUE, NP)){
  if(!is.matrix(pop)){
    print("The parameter 'pop' has to be a matrix")
  } else {
  
    # if(!is.null(A) && is.matrix(A)){
    #   archiveSize <- dim(A)[2]
    # }
    D <- dim(pop)[1]
    NP <- dim(pop)[2]
    PA <- NP + archiveSize
    
    probAdj = c(rep(NP/PA, NP), rep(1-(NP/PA), PA - NP))
    
    crossing1 <- matrix(rep(1:NP, D), 1, NP)
    crossing1[cross] <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)[cross]
    
    repeated <- crossing1[1, 1:NP] == 1:NP & cross
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)
      crossing1[repeated] = newCrossing[repeated]
      repeated <- crossing1[1, 1:NP] == 1:NP & cross
    }
    
    crossing2 <- matrix(rep(1:NP, D), 1, NP)
    crossing2[cross] <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)[cross]
    
    crossing <- rbind(crossing1, crossing2)
    
    repeated <- crossing[2, 1:NP] == 1:NP
    repeated <- repeated || crossing[1, 1:NP] == crossing [2, 1:NP] & cross
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)
      crossing[repeated] = newCrossing[repeated]
      repeated <- crossing[2, 1:NP] == 1:NP
      repeated <- repeated || crossing[1, 1:NP] == crossing [2, 1:NP] & cross
    }
    
    if(!is.null(A) && is.matrix(A)){
      union <- cbind(pop,A)
    } else {
      union <- pop
    }
    mutation <- matrix(0, D, NP)
    popA <- matrix(NA, dim(pop)[1], dim(pop)[2])
    popB <- popA;
    
    popA[1:D,cross] <- union[1:D, crossing[1, 1:NP]][1:D,cross]
    popB[1:D,cross] <- union[1:D, crossing[2, 1:NP]][1:D,cross]
    mutation[1:D,cross] <- popA[1:D,cross] - popB[1:D,cross]
  }
  
  mutation
}

archiver <- function(A, maxASize){
  archiveSize <- 0
  D <- dim(A)[1]
  function(improvements){
    improvSize <- dim(improvements)[2]
    
    archiveIndex <- (archiveSize+1):(archiveSize + improvSize)
    inBoundIndex <- archiveIndex[archiveIndex <= maxASize]
    
    if(length(inBoundIndex) > 0){
      A[1:D, inBoundIndex] <<- improvements[1:D, inBoundIndex - archiveSize]
    }
    
    #number of solutions that have to be removed from the current archive to make room for the new ones
    nremove <- improvSize - (maxASize - archiveSize) 
    if(nremove > 0){
      removeIndex <- sample(1:archiveSize, size = nremove)
      A[1:D, removeIndex] <<- improvements[1:D, archiveIndex[archiveIndex > maxASize] - archiveSize]
    }
    
    archiveSize <<- archiveSize + improvSize
    if(archiveSize > maxASize){
      archiveSize <<- maxASize
    }
    A
  }
}

meanl <- function(x, p = 2){
  lehmerMean <- sum(x^p)/sum(x^(p-1))
}

diversifier <- function(n, D, alpha = 0.006, d = 0.1, zeta = 1){
  #function(pop, popOld, cross, a, g){
  function(pop, popOld, g){
    threshold <- alpha * ((n-g)/g)^zeta;
    #recross <- colSums(abs(pop - popOld)) < threshold
    #recross <- colSums(abs(pop - popOld)) < threshold
    restore <- colSums(abs(pop - popOld)) < threshold
    #pop <- popOld[1:D,recross] + (((popOld[1:D,recross] - best[1:D,recross]) + mutator(popOld, a, cross = recross)) %*% diag(f)) * cross
    pop[1:D, restore] <- popOld[1:D, restore]
    
    pop
    
  }
}

