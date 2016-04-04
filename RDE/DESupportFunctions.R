mutator <- function(pop, A = NULL, archiveSize = 0){
  if(!is.matrix(pop)){
    print("The parameter 'pop' has to be a matrix")
  } else {
  
    D <- dim(pop)[1]
    NP <- dim(pop)[2]
    PA <- NP + archiveSize
    
    a <- matrix(sample(NP, NP, replace = TRUE), 1, NP)
    
    repeated <- a == 1:NP
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(NP, NP, replace = TRUE), 1, NP)
      a[repeated] = newCrossing[repeated]
      repeated <- a == 1:NP
    }
    
    b <- matrix(sample(PA, NP, replace = TRUE), 1, NP)
    
    repeated <- b == 1:NP | b == a
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE), 1, NP)
      b[repeated] = newCrossing[repeated]
      repeated <- b == 1:NP | b == a
    }
    
    c <- matrix(sample(PA, NP, replace = TRUE), 1, NP)
    
    repeated <- c == 1:NP | c== a | c == b
    while(!is.na(match(TRUE, repeated))){
      newCrossing <- matrix(sample(PA, NP, replace = TRUE), 1, NP)
      c[repeated] = newCrossing[repeated]
      repeated <- c == 1:NP | c== a | c == b
    }
    
    if(!is.null(A) && is.matrix(A)){
      union <- cbind(pop,A)
    } else {
      union <- pop
    }
    
    popB <- union[1:D,b]
    popC <- union[1:D,c]
    mutation <- popB - popC
    
    result <- list(mutation = mutation, a = a)
  }
  result
}

archiver <- function(A, maxASize){
  archiveSize <- 0
  D <- dim(A)[1]
  function(improvements){
    if(!is.null(improvements)){
      improvSize <- dim(improvements)[2]
      if(!is.null(improvSize) && improvSize > 0){
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
      }
    }
    result <- list(A = A, size = archiveSize)
    result
  }
}

meanl <- function(x, p = 2){
  lehmerMean <- sum(x^p)/sum(x^(p-1))
}

diversifier <- function(n, alpha = 0.06, d = 0.1, zeta = 1){
  function(mutation, g){
    threshold <- alpha * d * ((n-g)/g)^zeta
    restore <-  abs(mutation) < threshold
    restore
  }
}

