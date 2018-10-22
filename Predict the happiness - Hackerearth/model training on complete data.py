#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 10:37:04 2017

@author: gokul

import os
os.chdir("/media/gokul/Academic/!.Events/_.HackerEarth/Predict the happiness")
os.getcwd()
"""

import pandas as pd
import numpy as np

# Read in the data
df = pd.read_csv('train.csv')
test_df = pd.read_csv('test.csv')

print(df.columns)
df = df[["Description", "Is_Response"]]
df["Is_Response"] = np.where(df["Is_Response"]=="not happy", 0, 1)

# Checking Class imbalance
print(df["Is_Response"].mean())

from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
import re
stops = set(stopwords.words("english"))
def cleanData(text, lowercase = True, remove_stops = True, stemming = True):
    txt = str(text)
    txt = re.sub(r'[^A-Za-z0-9\s]',r'',txt)
    txt = re.sub(r'\n',r' ',txt)
    
    if lowercase:
        txt = " ".join([w.lower() for w in txt.split()])
        
    if remove_stops:
        txt = " ".join([w for w in txt.split() if w not in stops])
    
    if stemming:
        st = PorterStemmer()
        txt = " ".join([st.stem(w) for w in txt.split()])

    return txt


X_train = df["Description"].apply(cleanData)
y_train = df["Is_Response"]
X_test = test_df["Description"].apply(cleanData)
#y_test = test_df["Is_Response"]

from sklearn.feature_extraction.text import TfidfVectorizer
vect = TfidfVectorizer(min_df=100, ngram_range=(2,3), max_features = 500).fit(X_train)
X_train_vectorized = vect.transform(X_train)
len(vect.get_feature_names())

#from sklearn.linear_model import LogisticRegression
#model = LogisticRegression()
#model.fit(X_train_vectorized, y_train)

from sklearn.naive_bayes import MultinomialNB #BEST
model = MultinomialNB()
model.fit(X_train_vectorized, y_train)

## Fitting Random Forest Classification to the Training set
#from sklearn.ensemble import RandomForestClassifier
#model = RandomForestClassifier(n_estimators = 10, criterion = 'entropy', random_state = 0)
#model.fit(X_train_vectorized, y_train)


predictions = model.predict(vect.transform(X_test))

result = pd.DataFrame(test_df["User_ID"])
result["Is_Response"] = np.where(predictions == 0, "not happy", "happy")
result.to_csv("Result.csv", index = False)