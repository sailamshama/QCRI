library(bastah)
library(doMC)
library(foreach)

drug_names <- read.csv("/home/qcricse/Desktop/Repeat/drugs.csv")
drug_names <- drug_names[,2]

########################### drug loop ##################################

foreach (i = 7:139, .errorhandling="pass")%do%{
  
  directory <- paste("/home/qcricse/Desktop/Repeat/New_Data/drug",i, "_",drug_names[i], sep="")
  setwd(directory)
  #create vector of column numbers that showed up as significant
  cols_raw <- c()
  
  ####################### read data ####################################
  
  design_matrix <- read.csv(paste(directory, "/x_matrix.csv", sep=""))
  design_matrix <- as.matrix(design_matrix[,2:ncol(design_matrix)])
  response_vector <- read.csv(paste(directory,"/y_vector.csv", sep=""))
  response_vector <- response_vector[,2]
  
  ###################### bastah iteration ###############################
  for(run in 1:10){
    #run bastah
    p_values <- bastah(design_matrix, response_vector, ncores = 4, verbose= TRUE, family = "gaussian")
    #obtain significant columns for particular run
    significant_columns <- which(p_values$pval.corr <= 0.05)
    #add to raw columns
    cols_raw <- append(cols_raw, significant_columns)
   
    ### save data ###
    save(p_values, file = paste(directory,"/p_values", i,"(",run,").RData", sep = ""))
    
  }
  #create frequency table
  freq_table <- table(cols_raw)
  save(freq_table, file=paste(directory,"/freq_table",i,".RData", sep = ""))
  
}