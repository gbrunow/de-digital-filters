filterGenerator <- function (filterFunction, cutoff, order = 5, type = "IIR", method = "JADE", samples = 512){
  source('filterEvaluator.R')
  source('filters.R')
  
  eval <- filterEvaluator(filterFunction, cutoff, type, samples)
  
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