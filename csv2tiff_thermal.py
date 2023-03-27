
import csv
import os
from os import listdir
from os.path import isfile, join
from pprint import pprint

import tifffile as tf

wd = "path_to_dir"

files = [file for file in listdir(wd) if isfile(join(wd, file))]    # find all files in dir
 

for csv_file in files:
    if csv_file.endswith('.csv'): # filter CSV files 
     path = os.path.join(wd, 'temp_fin', csv_file.replace('.csv','.tif')) # create path for final result
     pprint(path)
     with open(csv_file,'r') as dest_f: #read CSV files
      data_iter = csv.reader(dest_f, delimiter = ';')
      next(data_iter) #skip 1st row
  
      data = [[data.replace(',','.') for data in data] for data in data_iter] # replace decimal comma with decimal point
      tf.imsave(path, data) #save new file on created path (var path)


