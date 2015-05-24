Reading and Cleaning Data Project
================================

There is one script called 'run_analysis.R'. This script looks for a directory
called data which contains the data set for Samsung Wearables experiment

The script reads in the training and test data from the data/train and data/test 
directories and combines them to one single dataset.

It then reads in the labels and merges it with the activity-names. In order to preserve
the row order, an row-id is added, which is the basis for a sorting post merge.

The feature names are read in, and then it is filtered based on the regex mean()|std() for
the features which are mean or standard deviations. The combined dataset is filtered
based on the indices of those features.

Then the activity labels and the subject_id are added. The feature vector is assigned as the 
names of the data frame, giving each variable a meaningful name.

The resulting data-frame is grouped by subject-id 
and activity and all other numeric columns are summarized as means.

In the end, the data frame is written to a file output.txt.
