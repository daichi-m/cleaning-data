# This script reads in and does the analysis for the Samsung dataset

run_analysis <- function() {
  
  library('dplyr');
  # Read in the test and training data
  testData <- read.table('data/test/X_test.txt');
  trainData <- read.table('data/train/X_train.txt');
  cmbData <- rbind(testData, trainData);
  
  # Read in the feature vectors and the labels
  features <- read.table('data/features.txt', stringsAsFactors = FALSE);
  activities <- read.table('data/activity_labels.txt', col.names = c("id", "activity"));
  
  # Load the activity labels and merge with activity names
  trainLabel <- read.table('data/train/y_train.txt', col.names = c('id'));
  testLabel <- read.table('data/test/y_test.txt', col.names = c('id'));
  cmbLabel <- rbind(testLabel, trainLabel);
  len <- length(cmbLabel$id);
  cmbLabel <- cbind(cmbLabel, row_id = seq(1,len));
  cmbLabel <- cmbLabel %>% merge(activities, by= 'id') %>% arrange(row_id);
  
  # Filter the datasets for mean and std
  reqd_features <- grep('mean\\(\\)|std\\(\\)', features[,2]);
  cmbData <- cmbData[,reqd_features];
  cmbData <- cbind(cmbData, cmbLabel$activity);
  
  # Give meaningful variable names
  featNames <- features$V2[reqd_features];
  names(cmbData) <- c(featNames, 'activity');
  
  # Adds the data of the subjects
  testSub <- read.table('data/test/subject_test.txt', col.names = c('subject_id'));
  trainSub <- read.table('data/train/subject_train.txt', col.names = c('subject_id'));
  cmbSub <- rbind(testSub, trainSub);
  cmbData <- cbind(cmbData, cmbSub);
  
  # Group By and find means of the variables
  aggrData <- group_by(cmbData, activity, subject_id);
  print(groups(aggrData));
  funSpec <- funs(mean, "mean", mean(., na.rm = TRUE));
  aggrData <- summarise_each(aggrData, funs = funSpec);
  
  # Write to output file
  write.table(aggrData, 'output.txt', row.names = FALSE);
  
}