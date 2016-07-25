#takes 


################## loading necessary data ########################
load("/home/smaham/Desktop/Repeat(2)/plus80.RData")
drugs_info <- read.csv("/home/smaham/Desktop/Repeat(2)/drugs.csv")
#get names of drugs
drug_names <- read.csv("/home/smaham/Desktop/Repeat(2)/drugs.csv")
drug_names <- drug_names[,2]
################## intializing variables #########################
#to iterate
significant_drugs <- unique(freq_table_all$drug_nos)
#create output data frame
bhat_pval_table <- data.frame()
#new row for each drug for each significant column
new_row <-NULL

##################### MAIN LOOP ###############################

for(i in significant_drugs){
  
  ############# get drug related info ################################
  #drug number
  drug_num = i
  #drug name, nickname, approvalStatus
  drug_info= drugs_info[i,c("Column2.drugName","Column8.a.k.a.","Column5.APVD.NA")]
  
  ############## get all variable names of design_matrix #######################
  #redundant code - loading x-values matrix again 
  directory <- paste("/home/smaham/Desktop/Repeat(2)/New_Data/drug",i, "_",drug_names[i], sep="")
  x_path = paste(directory, "/x_matrix.csv", sep="")
  design_matrix <- read.csv(x_path)
  design_matrix <- as.matrix(design_matrix)
  design_matrix <- design_matrix[,2:ncol(design_matrix)]
  dm_column_names <- colnames(design_matrix)
  
  ######################## get significant columns #################################
  #load p_value
  filename = paste("/p_values", i, "(1).RData", sep = "")
  load(paste(directory, filename, sep = ""))
  #get significant columns for drug i
  subset <- subset(freq_table_all, drug_nos == i)
  sig_pval = as.numeric(as.character(subset$column_number))
  
  ####################  build output data frame ######################################
  for (variable_num in sig_pval){
    variable_name = dm_column_names[variable_num]
    pval <- p_values$pval.corr[variable_num]
    bhat <- p_values$bhat[variable_num]
    freq <- subset(subset, column_number == variable_num)$frequency
    new_row <- cbind(drug_num, drug_info, variable_num, variable_name, pval, bhat, freq)
    bhat_pval_table = rbind(bhat_pval_table, new_row)
  }
}

#rename columns
colnames(bhat_pval_table) <- c("drug_num","drug_name","a.k.a","APVD/NA","var_num","var_name","pval","bhat", "freq")
save(bhat_pval_table, file = "/home/smaham/Desktop/Repeat(2)/compact_df_new(2).RData")


#to obtain info for particular drug
#example: drug2
#subset(bhat_pval_table, drug_num =="DRUG2")
