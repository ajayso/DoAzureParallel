library(doAzureParallel)

# This script shos how to use DoAzureParallel
#generateClusterConfig("pool_config.json")


pool <- makeCluster("pool_config.json")

registerDoAzureParallel(pool)

# Test Function
somefunction = function(){
 return (11)
  
  
}

# Get the number of instances
getDoParWorkers()

number_of_iterations <- 2
#Execute For loop in parallel instances.
results <- foreach(i = 1:number_of_iterations) %dopar% {
  i  = somefunction()
  i
}


stopCluster(pool)