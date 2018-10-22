#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 24 12:04:15 2017

@author: gokul

import os
os.chdir('/media/gokul/Academic/!.Events/Code Fest IIT BHU 17/linguipedia')
os.getcwd()
"""
# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
train_data = pd.read_csv('train_tweets.csv')

# Cleaning the texts
import re
import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
corpus = []
for i in range(0, len(train_data)):
    review = re.sub('[^a-zA-Z]', ' ', train_data['tweet'][i])
    review = review.lower()
    review = review.split()
    ps = PorterStemmer()
    review = [ps.stem(word) for word in review if not word in set(stopwords.words('english'))]
    review = ' '.join(review)
    corpus.append(review)
    
# Creating the Bag of Words model
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features = 1500)
X_train = cv.fit_transform(corpus).toarray()
y_train = train_data.loc[:, 'label'].values
               
# Fitting RF to the Training set
from sklearn.ensemble import RandomForestClassifier
classifier = RandomForestClassifier(n_estimators = 120, criterion = 'entropy', random_state =123, n_jobs=-1)
classifier.fit(X_train, y_train)

# Cleaning and creating bag of word for test dataset
test_data = pd.read_csv('test_tweets.csv')
test_corpus = []
for i in range(0, len(test_data)):
    review = re.sub('[^a-zA-Z]', ' ', test_data['tweet'][i])
    review = review.lower()
    review = review.split()
    ps = PorterStemmer()
    review = [ps.stem(word) for word in review if not word in set(stopwords.words('english'))]
    review = ' '.join(review)
    test_corpus.append(review)   

X_test = cv.transform(test_corpus).toarray()

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Writing the predictions to a csv file
result = pd.DataFrame(test_data['id'])
result['label'] = y_pred
result.to_csv('test_predictions.csv', index = False)
