#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 11:25:21 2017

@author: gokul

import os
os.chdir("/media/gokul/Academic/!.Events/Student Hunt '17 - AV")
os.getcwd()
"""


# Importing the libraries
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('train.csv')
dataset['ID'] = dataset['ID'].astype(str)

dataset['year'] = dataset['ID'].apply(lambda x : int(x[:4])) 
dataset['month'] = dataset['ID'].apply(lambda x : int(x[4:6])) 
dataset['day'] = dataset['ID'].apply(lambda x : int(x[6:8])) 
dataset['hour'] = dataset['ID'].apply(lambda x : int(x[8:10]))

X_train = dataset.iloc[:, 2:].values
y_train = dataset.iloc[:, 1].values
                      
                
# 1. Fitting Multiple Linear Regression to the Training set
from sklearn.linear_model import LinearRegression
#regressor = LinearRegression()
#regressor.fit(X_train, y_train)

# 4. Fitting Polynomial Regression to the dataset
from sklearn.preprocessing import PolynomialFeatures
poly_reg = PolynomialFeatures(degree = 5)
X_poly = poly_reg.fit_transform(X_train)
poly_reg.fit(X_poly, y_train)
regressor_2 = LinearRegression()
regressor_2.fit(X_poly, y_train)

# Testing on real Test data
# Importing the dataset
new_dataset = pd.read_csv('test.csv')
new_dataset['ID'] = new_dataset['ID'].astype(str)

new_dataset['year'] = new_dataset['ID'].apply(lambda x : int(x[:4])) 
new_dataset['month'] = new_dataset['ID'].apply(lambda x : int(x[4:6]))
new_dataset['day'] = new_dataset['ID'].apply(lambda x : int(x[6:8]))
new_dataset['hour'] = new_dataset['ID'].apply(lambda x : int(x[8:10])) 

X_test = new_dataset.iloc[:, 2:].values

                         
# Predicting the Test set results
#y_pred = regressor.predict(X_test)

# Predicting the Test set results for polynomial regression
X_poly_2 = poly_reg.fit_transform(X_test)
y_pred = regressor_2.predict(X_poly_2)

result = pd.DataFrame(new_dataset['ID'])
result['Count'] = y_pred-1
result['Count'] = result['Count'].apply(int)

result.to_csv("result_reg.csv", index = False)