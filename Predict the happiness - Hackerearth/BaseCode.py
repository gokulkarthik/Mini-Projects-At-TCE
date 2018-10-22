#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 10:20:56 2017

@author: gokul

import os
os.chdir("/media/gokul/Academic/!.Events/_.HackerEarth/Predict the happiness")
os.getcwd()
"""

import pandas as pd
import numpy as np

# Read in the data
df = pd.read_csv('train.csv')

print(df.columns)
df = df[["Description", "Is_Response"]]
df["Is_Response"] = np.where(df["Is_Response"]=="not happy", 0, 1)

# Checking Class imbalance
print(df["Is_Response"].mean())

from sklearn.model_selection import train_test_split
# Split data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(df['Description'], 
                                                    df['Is_Response'], 
                                                    random_state=0)

from sklearn.feature_extraction.text import CountVectorizer
vect = CountVectorizer(min_df=10, ngram_range=(1,3)).fit(X_train)
X_train_vectorized = vect.transform(X_train)
X_test_vectorized = vect.transform()
len(vect.get_feature_names())

from sklearn.linear_model import LogisticRegression
model = LogisticRegression()
model.fit(X_train_vectorized, y_train)

predictions = model.predict(vect.transform(X_test))

from sklearn.metrics import roc_auc_score
print('AUC: ', roc_auc_score(y_test, predictions))