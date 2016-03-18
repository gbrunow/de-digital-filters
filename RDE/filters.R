lowpass <- function(w, cutoff){
  h <- vector(mode = "numeric", length=10L)
  h[w < cutoff] <- 1
  h[w >= cutoff] <- 0
  h
}

highpass <- function(w, cutoff){
  h <- vector(mode = "numeric", length=10L)
  h[w < cutoff] <- 0
  h[w >= cutoff] <- 1
  h
}

bandpass <- function(w, cutoff){
  h <- vector(mode = "numeric", length=10L)
  h[w < cutoff[1]] <- 0
  h[w >= cutoff[1]] <- 1
  h[w > cutoff[2]] <- 0
  h
}

bandstop <- function(w, cutoff){
  h <- vector(mode = "numeric", length=10L)
  h[w < cutoff[1]] <- 1
  h[w >= cutoff[1]] <- 0
  h[w > cutoff[2]] <- 1
  h
}