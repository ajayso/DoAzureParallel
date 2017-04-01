library(doAzureParallel)


# This script takes it to next level of how to by use mlr , this is run without parallelization to benchmark the execution time
#generateClusterConfig("pool_config.json")


pool <- makeCluster("pool_config.json")


registerDoAzureParallel(pool)

dorealbigparallelstuff = function(){


  options(repos=structure(c(CRAN="https://cran.cnr.berkeley.edu/")))
  install.packages('randomForest');
  install.packages('mlr');
  install.packages('parallel');
  
 
  library("mlr")
  library("randomforest")
  
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
  xx = system.time(res <- resample(lrn, adult.task, rdesc))
  return (xx)
}

getDoParWorkers()
number_of_iterations <- 2
results <- foreach(i = 1:number_of_iterations) %dopar% {
  ii = dorealbigparallelstuff()
  ii
}


stopCluster(pool)




