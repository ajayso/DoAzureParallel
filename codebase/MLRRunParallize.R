library(doAzureParallel)


# This script takes it to next level of parallelization by using parallelmap, mlr the algorithms are parallelization enabled. 
#generateClusterConfig("pool_config.json")


pool <- makeCluster("pool_config.json")

# 4. Register the pool as your parallel backend
registerDoAzureParallel(pool)

dorealbigparallelstuff = function(){
  
  options(repos=structure(c(CRAN="https://cran.cnr.berkeley.edu/")))
  install.packages('randomForest');
  install.packages('mlr');
  install.packages('parallelMap');
  
  
  library("mlr")
  library("parallelMap")
  storagedir = getwd()
  parallelStartMulticore(2)
  #parallelStartBatchJobs(storagedir = storagedir)
  
  lrn = makeLearner("classif.randomForest")
  download.file ("http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data","adult.txt")
  adult = read.table("adult.txt",
                     sep=",",header=F,col.names=c("age", "type_employer", "fnlwgt", "education", 
                                                  "education_num","marital", "occupation", "relationship", "race","sex",
                                                  "capital_gain", "capital_loss", "hr_per_week","country", "income"),
                     fill=F,strip.white=T        
  )
  adult.task = makeClassifTask(data = adult, target = "education")
  rdesc = makeResampleDesc("CV", iters = 3)
  executiontime = system.time(res <- resample(lrn, adult.task, rdesc))
  res
  
  parallelStop()
  return (executiontime)
}

getDoParWorkers()
number_of_iterations <- 1
results <- foreach(i = 1:number_of_iterations) %dopar% {
  ii = dorealbigparallelstuff()
  ii
}


stopCluster(pool)




