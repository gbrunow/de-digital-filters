fast_freqz <- function (filters, type='IIR', samples=512){
  w <-seq(0, pi, pi/samples)
  z <- exp(-1i*w);
  nfilters <- dim(filters)[2];
  nvalues <- dim(filters)[1];
  half <- nvalues/2;
  b <- filters[1:half, 1:nfilters]
  a <- filters[(half + 1):nvalues, 1:nfilters]
  h <- matrix(NA, length(w), nfilters)
  
  for(i in 1:nfilters){
    h[1:length(w), i] <- polyval(b[1:half, i], z)/polyval(a[1:half, i], z)
  }
  
  response <- data.frame(w = w, h = h)
}
