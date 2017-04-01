library(doAzureParallel)
library(devtools)
# This script shows how to use multiple cores of the azure compute instance using the parallel package , where by one can use the parallel constructs for lapply...

#generateClusterConfig("pool_config.json")


pool <- makeCluster("pool_config.json")

# 4. Register the pool as your parallel backend
registerDoAzureParallel(pool)

dorealparallelstuff = function(){
  library(parallel)
  base <- 2
  
  no_cores <- detectCores()
  cl <- makeCluster(no_cores,"FORK")
  
  #clusterExport(cl, "base")
  
  oo = parLapply(cl,2:4, function(exponent)  base^exponent)
  return (oo)
}

getDoParWorkers()
number_of_iterations <- 2
results <- foreach(i = 1:number_of_iterations) %dopar% {
  ii = dorealparallelstuff()
  ii
}


stopCluster(pool)




