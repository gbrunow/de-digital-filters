crosser <- function(NP, skip = rep(TRUE,NP)){
  
  crossing <- matrix(sample(1:NP, NP, replace = TRUE), 1, NP)
  
  crossing <- matrix(sample(1:NP, NP, replace = TRUE), 2, NP)
  
  repeated <- crossing[1, 1:NP] == crossing [2, 1:NP] & skip
  while(!is.na(match(TRUE, repeated))){
    newCrossing <- matrix(sample(2:NP, NP, replace = TRUE), 1, NP)
    crossing[repeated] = newCrossing[repeated]
    repeated <- crossing[1, 1:NP] == crossing [2, 1:NP] & skip
  }
  
  crossing <- matrix(sample(1:NP), 3, NP)
  
  repeated <- crossing[1, 1:NP] == crossing [3, 1:NP]
  repeated <- repeated || crossing[2, 1:NP] == crossing [3, 1:NP] & skip
  while(!is.na(match(TRUE, repeated))){
    newCrossing <- matrix(sample(1:NP, NP, replace = TRUE), 1, NP)
    crossing[repeated] = newCrossing[repeated]
    repeated <- crossing[1, 1:NP] == crossing [3, 1:NP]
    repeated <- repeated || crossing[2, 1:NP] == crossing [3, 1:NP] & skip
  }
  
  crossing
}