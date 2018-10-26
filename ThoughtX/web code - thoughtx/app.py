# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
"""
Created on Sun Mar 18 00:34:14 2018

@author: new
"""

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
#import matplotlib.pyplot as plt
#import seaborn as sns
#sns.set()
final_df = pd.read_csv("final_features_data.csv")
data = pd.read_csv('data/df_with_title2.csv')

print(final_df.columns[1:])
def result2(f1='battery', f2='sound', f3='color'):
    res3 = {}
    lst5 = []
    new_data_pos = final_df.sort_values(by=[f1, f2, f3], ascending=False)
    for i in new_data_pos.asin[:10]:
        print(i)
        dic5 = {}
        dic5['asin'] = i
        dic5['title'] = data[data['asin'] == i].iloc[0,:]['title']
        lst5.append(dic5)
    res3['products'] = lst5
    return res3

# Top 10 products
rating = data.groupby('title').describe()['overall'].sort_values('mean', ascending=False)[['mean']]
rating.head(10)

# find the 10 most frequent product_type_names.
from collections import Counter
product_type_count = Counter(list(data['title']))
product_type_count.most_common(10)

def top_pop():
	res1 = {}
	res1['top'] = [{'title':x, 'rating':y} for idx,x,y in rating.head(10).iterrows()]
	res1['pop'] = [{'title':x, 'sales':y} for x,y in product_type_count.most_common(10)]
	return res1


#from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
#from sklearn.metrics.pairwise import cosine_similarity  
from sklearn.metrics import pairwise_distances
#from matplotlib import gridspec
#from scipy.sparse import hstack

# Sort the whole data based on title (alphabetical order of title) 
data_copy = data.copy()
data_sorted = data.sort_values('title', ascending=False)
data_sorted.head()

data_unique = data_sorted.drop_duplicates(subset='asin', keep="last")
data_unique.shape
#data_unique[['title']].to_csv("data_input_title.csv", index=False)


#from nltk.corpus import stopwords
#from nltk.tokenize import word_tokenize
#import nltk

#stop_words = set(stopwords.words('english'))
#print ('list of stop words:', list(stop_words)[:10])
#
#def nlp_preprocessing(total_text, index, column):
#    if type(total_text) is not int:
#        string = ""
#        for words in total_text.split():
#            # remove the special chars in review like '"#$@!%^&*()_+-~?>< etc.
#            word = ("".join(e for e in words if e.isalnum()))
#            # Conver all letters to lower-case
#            word = word.lower()
#            # stop-word removal
#            if not word in stop_words:
#                string += word + " "
#        data_unique[column][index] = string
#        
#import time
#start_time = time.clock()
## we take each title and we text-preprocess it.
#for index, row in data_unique.iterrows():
#    nlp_preprocessing(row['title'], index, 'title')
## we print the time it took to preprocess whole titles 
#print(time.clock() - start_time, "seconds")


#from nltk.stem.porter import *
#stemmer = PorterStemmer()

##plotting code to understand the algorithm's decision.
#def plot_heatmap(keys, values, labels, text):
#        # keys: list of words of recommended title
#        # values: len(values) ==  len(keys), values(i) represents the occurence of the word keys(i)
#        # labels: len(labels) == len(keys), the values of labels depends on the model we are using
#                # if model == 'bag of words': labels(i) = values(i)
#                # if model == 'tfidf weighted bag of words':labels(i) = tfidf(keys(i))
#                # if model == 'idf weighted bag of words':labels(i) = idf(keys(i))
#        # url : apparel's url
#
#        # we will devide the whole figure into two parts
#        gs = gridspec.GridSpec(2, 2, width_ratios=[4,1], height_ratios=[4,1]) 
#        fig = plt.figure(figsize=(25,3))
#        
#        # 1st, ploting heat map that represents the count of commonly ocurred words in title2
#        ax = plt.subplot(gs[0])
#        # it displays a cell in white color if the word is intersection(lis of words of title1 and list of words of title2), in black if not
#        ax = sns.heatmap(np.array([values]), annot=np.array([labels]))
#        ax.set_xticklabels(keys) # set that axis labels as the words of title
#        ax.set_title(text) # apparel title
#        
#        
#        # displays combine figure ( heat map and image together)
#        plt.show()
#        
#def plot_heatmap_image(doc_id, vec1, vec2, text, model):
#
#    # doc_id : index of the title1
#    # vec1 : input apparels's vector, it is of a dict type {word:count}
#    # vec2 : recommended apparels's vector, it is of a dict type {word:count}
#    # url : apparels image url
#    # text: title of recomonded apparel (used to keep title of image)
#    # model, it can be any of the models, 
#        # 1. bag_of_words
#        # 2. tfidf
#        # 3. idf
#
#    # we find the common words in both titles, because these only words contribute to the distance between two title vec's
#    intersection = set(vec1.keys()) & set(vec2.keys()) 
#
#    # we set the values of non intersecting words to zero, this is just to show the difference in heatmap
#    for i in vec2:
#        if i not in intersection:
#            vec2[i]=0
#
#    # for labeling heatmap, keys contains list of all words in title2
#    keys = list(vec2.keys())
#    #  if ith word in intersection(lis of words of title1 and list of words of title2): values(i)=count of that word in title2 else values(i)=0 
#    values = [vec2[x] for x in vec2.keys()]
#    
#    # labels: len(labels) == len(keys), the values of labels depends on the model we are using
#        # if model == 'bag of words': labels(i) = values(i)
#        # if model == 'tfidf weighted bag of words':labels(i) = tfidf(keys(i))
#        # if model == 'idf weighted bag of words':labels(i) = idf(keys(i))
#
#    if model == 'bag_of_words':
#        labels = values
#    elif model == 'tfidf':
#        labels = []
#        for x in vec2.keys():
#            # tfidf_title_vectorizer.vocabulary_ it contains all the words in the corpus
#            # tfidf_title_features[doc_id, index_of_word_in_corpus] will give the tfidf value of word in given document (doc_id)
#            if x in  tfidf_title_vectorizer.vocabulary_:
#                labels.append(tfidf_title_features[doc_id, tfidf_title_vectorizer.vocabulary_[x]])
#            else:
#                labels.append(0)
#    elif model == 'idf':
#        labels = []
#        for x in vec2.keys():
#            # idf_title_vectorizer.vocabulary_ it contains all the words in the corpus
#            # idf_title_features[doc_id, index_of_word_in_corpus] will give the idf value of word in given document (doc_id)
#            if x in  idf_title_vectorizer.vocabulary_:
#                labels.append(idf_title_features[doc_id, idf_title_vectorizer.vocabulary_[x]])
#            else:
#                labels.append(0)
#
#    plot_heatmap(keys, values, labels, text)
#
#        
## this function gets a list of wrods along with the frequency of each 
## word given "text"
#def text_to_vector(text):
#    word = re.compile(r'\w+')
#    words = word.findall(text)
#    # words stores list of all words in given string, you can try 'words = text.split()' this will also gives same result
#    return Counter(words) # Counter counts the occurence of each word in list, it returns dict type object {word1:count}
#
#
#
#def get_result(doc_id, content_a, content_b, model):
#    text1 = content_a
#    text2 = content_b
#    
#    # vector1 = dict{word11:#count, word12:#count, etc.}
#    vector1 = text_to_vector(text1)
#
#    # vector1 = dict{word21:#count, word22:#count, etc.}
#    vector2 = text_to_vector(text2)
#
#    plot_heatmap_image(doc_id, vector1, vector2, text2, model)
    
tfidf_title_vectorizer = TfidfVectorizer(min_df = 0)
tfidf_title_features = tfidf_title_vectorizer.fit_transform(data_unique['title'])
import random  
data_senti = data_unique.loc[:, ['asin', 'title']]
lst = list(range(100))
data_senti['sad'] = [random.choice(lst) for _ in range(1184)]
data_senti['angry'] = [random.choice(lst) for _ in range(1184)]
data_senti['neutral'] = [random.choice(lst) for _ in range(1184)]
data_senti['happy'] = [random.choice(lst) for _ in range(1184)]
data_senti['surprise'] = [random.choice(lst) for _ in range(1184)] 

def tfidf_model(doc_id, num_results=5):
    # doc_id: apparel's id in given corpus
    result = {}
    result_list = []
    # pairwise_dist will store the distance from given input apparel to all remaining apparels
    # the metric we used here is cosine, the coside distance is mesured as K(X, Y) = <X, Y> / (||X||*||Y||)
    # http://scikit-learn.org/stable/modules/metrics.html#cosine-similarity
    pairwise_dist = pairwise_distances(tfidf_title_features,tfidf_title_features[doc_id])

    # np.argsort will return indices of 9 smallest distances
    indices = np.argsort(pairwise_dist.flatten())[0:num_results+5]
    #pdists will store the 9 smallest distances
    pdists  = np.sort(pairwise_dist.flatten())[0:num_results+5]

    #data frame indices of the 9 smallest distace's
    df_indices = list(data_unique.index[indices])

    for i in range(0,len(indices)):
        # we will pass 1. doc_id, 2. title1, 3. title2, url, model
        if(pdists[i] != 0.0):
            result_dic = {}
            #get_result(indices[i], data_unique['title'].loc[df_indices[0]], data_unique['title'].loc[df_indices[i]], 'tfidf')
            #print('ASIN :',data_unique['asin'].loc[df_indices[i]])
            #print ('Eucliden distance from the given image :', pdists[i])
            result_dic['AI_Score'] = pdists[i]
            result_dic['asin'] = data_unique['asin'].loc[df_indices[i]]
            result_dic['title'] = data_unique['title'].loc[df_indices[i]]
            result_dic['desc'] = "sample desc"
            #print('='*125)
            result_list.append(result_dic)
            
    result['products'] = result_list
    result['top'] = [{'title':x, 'rating':str(y)} for x, y in zip(rating.index[:10], rating['mean'][:10])]
    result['popular'] = [{'title':x, 'sales':y} for x,y in product_type_count.most_common(10)]
    xx = dict(data_senti.iloc[doc_id, 2:])
    result['sentiment'] = {k:str(v) for k,v in xx.items()}
    print(result['sentiment'])
    return result
#tfidf_model(1, 5)
# in the output heat map each value represents the tfidf values of the label word, the color represents the intersection with inputs title

#def result(ip):
#    #data_unique_copy = data_unique.copy().reset_index()
#    #print(data_unique_copy['title'].head(20))
#    #ip = input("Enter your choice: ")
#    tfidf_model(ip, 5)
#    res = {}
#    return res



from flask import Flask, request, render_template
from flask_restful import Resource, Api
import json
from flask_jsonpify import jsonify


app = Flask(__name__)

app = Flask(__name__)
api = Api(app)

proName = ""

def getProdName():
	return proName

class T1(Resource):
	def get(self):
		global proName
		print(request.get_json())
		prodID = request.args.get("prodID")
		print(prodID)
		tres = tfidf_model(int(prodID))
		result = tres
		'''result = {  #Sample Response Format
			'products': [
			{
				'title': 'Product 1',
				'asin': 11323322,
				'desc': "Sample Desc",
				'AI_Score': "200$"
			},
			{
				'title': 'Product 2',
				'asin': 5423512,
				'desc': "Lorem Ipsum",
				'AI score': "300$"
			}
			]
		}'''
		jdata = json.dumps(result)
		print(jdata)
		return jdata

class T2(Resource):
	def get(self):
		f1, f2, f3 = str(request.args.get("features")).split(";")
		result = result2(f1, f2, f3)
		'''result = {  #Sample Response Format
			'products': [ {
			'title': "lorem",
			'asin': 555

			},{
			'title': "lorem",
			'asin': 555

			}
			]
		}'''
		print([f1, f2, f3])
		jdata = json.dumps(result)
		print(jdata)
		return jdata

api.add_resource(T1, '/t1/', methods=['GET']) # Route_1
api.add_resource(T2, '/t2/', methods=['GET']) # Route_2

@app.after_request
def after_request(response):
	response.headers.add('Access-Control-Allow-Origin', '*')
	return response

@app.route("/")
def myform():
	return render_template('thinkme2.html')

@app.route("/features")
def myform2():
	return render_template('thinkme4.html')

if __name__ == '__main__':
	app.run(debug=True)
