mutator <- function(pop, A = NULL, archiveSize = 0){
  if(!is.matrix(pop)){
    print("The parameter 'pop' has to be a matrix")
  } else {
  
    if(!is.null(A) && is.matrix(A)){
      archiveSize <- dim(A)[2]
    }
    D <- dim(pop)[1]
    NP <- dim(pop)[2]
    PA <- NP + archiveSize
    
    probAdj = c(rep(NP/PA, NP), rep(1-(NP/PA), PA - NP))
    
    crossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)
    crossingIndexes <- matrix(NA, dim(pop)[1], dim(pop)[2])
    popA <- crossingIndexes;
    popB <- crossingIndexes;
    
    repeated <- crossing[1, 1:NP] == 1:NP
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)
      crossing[repeated] = newCrossing[repeated]
      repeated <- crossing[1, 1:NP] == 1:NP
    }
    
    crossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 2, NP)
    
    repeated <- crossing[1, 1:NP] == 1:NP
    repeated <- repeated || crossing[1, 1:NP] == crossing [2, 1:NP]
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE, prob = probAdj), 1, NP)
      crossing[repeated] = newCrossing[repeated]
      repeated <- crossing[1, 1:NP] == 1:NP
      repeated <- repeated || crossing[1, 1:NP] == crossing [2, 1:NP]
    }
    
    if(!is.null(A) && is.matrix(A)){
      union <- cbind(pop,A)
    } else {
      union <- pop
    }
    popA <- union[1:D, crossing[1, 1:NP]]
    popB <- union[1:D, crossing[2, 1:NP]]
    mutation <- popA - popB
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

