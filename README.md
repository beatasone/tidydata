
##README to describe procedure for creating tidy data set for Smartphone Human Activity Recognition
---
This is for a course project for the Coursera course Getting and Cleaning Data.

The script run_anlayis.R will take the raw data and extract a tidy data set as described below.

The project entailed merging two sets of data a training and test data set.  Only a portion of the original variables describing mean and standard deviation was to be retained.  This data was matched to the activity description and subject or volunteer performing the actvity.  The data was then summarized providing the average of the reduced set of variables for each activity and each volunteer.

The CodeBook.Rmd outlines the variable names, variable types and description with units.

A few notes on run_analysis.R script

The dplyr and plyr packages were loaded to provide efficient tools for working with dataframes. The code will run with the raw data tables loaded in the working directory.

Since both the test and training data had similar procedures to make the data tidy.  I decided to work through the steps for each group before joining in a final dataframe. This then was easily repeated for the other data set.

The first step was to load the raw data tables. Then the variable names were updated using the the make names function. The activity level and subject data was merged with the variable data, and the activity number was replaced with the activity description. A filter was then used to remove any of the variables that did not contain measurements for mean or standard deviation.

The above was repeated for the other data set and then the two datasets were combined with a join.  This totaldata set was grouped by activity and subject and then an average was providing for each of the mean and std variables maintained in the dataframe.

Lastly the final data set was written to a txt file for uploading. This file is called finaltidydataset.txt

---











# tidydata
