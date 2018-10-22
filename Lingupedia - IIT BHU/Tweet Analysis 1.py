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
                        
# Cleaning and creating bag of words for test dataset
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
      
"""
select any one model
"""         
# 1 Naive Bayes 
from sklearn.naive_bayes import GaussianNB
classifier = GaussianNB()

# 2 Decision Trees 
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy', random_state = 0)

# 3 RF
from sklearn.ensemble import RandomForestClassifier
classifier = RandomForestClassifier(n_estimators = 100, criterion = 'entropy', random_state =0, n_jobs=-1)


# 4 Kernel-SVM
from sklearn.svm import SVC
classifier = SVC(kernel = 'rbf', random_state = 0)

# 5.Log.Regr 
from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)

# 6 knn 
from sklearn.neighbors import KNeighborsClassifier
classifier = KNeighborsClassifier(n_neighbors = 10, metric = 'minkowski', p = 2)

# 7 Gradient Boost 
from sklearn.ensemble import GradientBoostingClassifier
classifier = GradientBoostingClassifier(learning_rate = 0.3, n_estimators =50 , max_depth = 5)
# 8 MLP
from sklearn.neural_network import MLPClassifier
classifier = MLPClassifier(hidden_layer_sizes = [10], solver='lbfgs',random_state = 0)

"""
model ends
"""
# Fitting the classifier
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Writing the predictions to a csv file
result = pd.DataFrame(test_data['id'])
result['label'] = y_pred
result.to_csv('test_predictions.csv', index = False)
