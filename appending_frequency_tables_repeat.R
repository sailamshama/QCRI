#result: creates take with columns: drug, columns, frequency. Saves table with those drugs whose column frequency > 80%

library(doMC)
library(foreach)
registerDoMC(4)

#get names of drugs
drug_names <- read.csv("/home/qcricse/Desktop/Repeat(2)/drugs.csv")
drug_names <- drug_names[,2]
freq_table_all <- data.frame()

foreach(i=1:139, .errorhandling = "pass") %do%{
  
  #obtain frequency data for particular drug
  drug_nos <- i #just name the
  filename = paste("/freq_table",i,".RData",sep="")
  path = paste("/home/qcricse/Desktop/Repeat(2)/New_Data/drug",i, "_",drug_names[i],filename, sep="")
  load(path)
  
  #edge case, significant columns => empty freq. table  
  #if (!length(freq_table$rows)) next()
  
  #convert to data frame
  freq_table <- as.data.frame(freq_table)
  #name columns #should've beend done in previous script
  colnames(freq_table) <- c("column_number", "frequency")
  #add column for drug name
  length <- length(freq_table$column_number)
  freq_table <- cbind(rep(drug_nos, length), freq_table)
  colnames(freq_table)[1] <- "drug_nos"
  
  #append to main dataframe
  freq_table_all<-rbind(freq_table_all,freq_table)
}

##subset to frequency over 80 and save as plus80.RData
plus80 <- subset(freq_table_all, frequency>=8)
save(freq_table_all, file = "/home/qcricse/Desktop/Repeat(2)/plus80.RData")
