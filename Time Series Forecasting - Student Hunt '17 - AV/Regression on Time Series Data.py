#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 10:46:43 2017

@author: gokul
"""
import os
os.chdir("/media/gokul/Academic/!.Events/Student Hunt '17 - AV")
os.getcwd()
# Multiple Linear Regression

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('train.csv')
dataset['ID'] = dataset['ID'].astype(str)

dataset['year'] = dataset['ID'].apply(lambda x : x[:4]) 
dataset['month'] = dataset['ID'].apply(lambda x : x[4:6]) 
dataset['day'] = dataset['ID'].apply(lambda x : x[6:8]) 
dataset['hour'] = dataset['ID'].apply(lambda x : x[8:10]) 

X = dataset.iloc[:, 2:].values
y = dataset.iloc[:, 1].values
                
#  Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# 1. Fitting Multiple Linear Regression to the Training set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

## 2. Fitting Random Forest Regression to the dataset
#from sklearn.ensemble import RandomForestRegressor
#regressor = RandomForestRegressor(n_estimators = 10, random_state = 0)
#regressor.fit(X_train, y_train)
#
## 3. Fitting SVR to the dataset
#from sklearn.svm import SVR
#regressor = SVR(kernel = 'rbf')
#regressor.fit(X_train, y_train)

# 4. Fitting Polynomial Regression to the dataset
from sklearn.preprocessing import PolynomialFeatures
poly_reg = PolynomialFeatures(degree = 6)
X_poly = poly_reg.fit_transform(X_train)
poly_reg.fit(X_poly, y_train)
regressor_2 = Lasso()
regressor_2.fit(X_poly, y_train)

# Predicting the Test set results
y_pred = regressor.predict(X_test)

# Predicting the Test set results
X_poly_2 = poly_reg.fit_transform(X_test)
y_pred_2 = regressor_2.predict(X_poly_2)

from sklearn.metrics import mean_squared_error
import math
print(math.sqrt(mean_squared_error(y_test, y_pred)))
print(math.sqrt(mean_squared_error(y_test, y_pred_2)))


"""
REAL TEST
"""
# Testing on real Test data
# Importing the dataset
new_dataset = pd.read_csv('test.csv')
new_dataset['ID'] = new_dataset['ID'].astype(str)

new_dataset['year'] = new_dataset['ID'].apply(lambda x : x[:4]) 
new_dataset['month'] = new_dataset['ID'].apply(lambda x : x[4:6]) 
new_dataset['day'] = new_dataset['ID'].apply(lambda x : x[6:8]) 
new_dataset['hour'] = new_dataset['ID'].apply(lambda x : x[8:10]) 

new_X_test = new_dataset.iloc[:, 2:].values

# Predicting the Test set results
new_y_pred = regressor.predict(new_X_test)

result = pd.DataFrame(new_dataset['ID'])
result['Count'] = new_y_pred
result['Count'] = result['Count'].apply(int)

result.to_csv("result_reg.csv", index = False)

