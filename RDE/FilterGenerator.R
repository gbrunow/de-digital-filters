filterGenerator <- function (filterFunction, cutoff, order = 5, type = "IIR", method = "JADE", samples = 512){
  source('filtersEvaluator.R')
  source('filters.R')
  source('JADE.R')
  source("fast_freqz.R")
  
  D <- (order + 1)*2
  feedback <- function(pop, score){
    best <- pop[1:D, order(score)[1]]
    b <- best[1:(D/2)]
    a <- best[((D/2)+1):D]
    r <- freqz(b,a)
    #freqz_plot(r$f, r$h)
    plot(r$f,abs(r$h))
  }
  
  eval <- filtersEvaluator(filterFunction, cutoff, type, samples = 128)
  
  filter <- JADE(D, eval, NP = 150, maxASize = 150, feedback = feedback)
  
  
  notImplemented <- print("Method not implemented yet.")
  solver <-  switch(method,
          "JADE" = 1,
          "DE" = notImplemented,
          "SADE" = notImplemented,
          print("Unknown method.")
         )
  
  #solve (eval)
  #where: error <- eval(pop)
}