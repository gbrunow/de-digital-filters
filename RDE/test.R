library(rbenchmark)
b <-  c(36.62, -72.46, 33.18, 60.22, -87.52, 40.22)
a <-  c(100, -53.32, 42.75, 92.44, -31.62, 26.28)

freqz100 <- function(b,a){
  for(i in 1:100){
    freqz(b,a)
  }
}

#response1 <- freqz(b,a)
#response2 <- fast_freqz(b,a)

#freqz_plot(response1$f, response1$h)
#freqz_plot(response2$w, response2$h)

filter = c(b,a)
filters = replicate(100, filter)
#benchmark(freqz100(b,a), fast_freqz(filters))

count <- function(inc = 1, i = 0){
  j = i;
  function(){
    j <<- j + inc
    j
  }
}