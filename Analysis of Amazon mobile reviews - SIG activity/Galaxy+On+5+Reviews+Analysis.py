
# coding: utf-8

# # 1. Text Pre-processing

# The following processes are done using **Libre Office Writer.** 
# 
# * *PhoneReviews.doc* is coverted to *PhoneReviews.txt*.
# * *PhoneRevies.txt* is splitted into *GalaxyOn5Reviews.txt* and *LenovoK5NoteReviews.txt* 

# In[1]:

import re
import numpy as np
import pandas as pd
import sklearn 
import matplotlib.pyplot as plt
import nltk


# In[2]:

#Return an ndarray
review_text = np.loadtxt("GalaxyOn5Reviews.txt", dtype='string', delimiter="\n")
#print review_text.shape
review_text = review_text[3:]# Removing the unnecessary lines
print "Length = ", len(review_text)
print review_text


# In[3]:

# Just to understand the structure of review_text
for i in review_text:
    print i
    print "----------------------------------------------------"


# In[4]:

# To find whether the string is a rating
def is_number(string):
    try:
        float(string)
        return True
    except:
        return False
    
def is_color(string):
    return re.match(r'Colour: ', string)

def is_review_date(string):
    return re.match(r'By(.)+on ', string)

def is_comment(string):
    return re.match('Comment| ', string)


# In[5]:

ratings = []
colors = []
dates_of_review = []
comments = []
reviews = []

cnt = 1
for line in review_text:
    
    #Ratings list
    if is_number(line[:3]):
        rating = float(line[:3])
        ratings.append(rating)
        review_added = 0
        
    #Review date list
    elif is_review_date(line) :
        dates_of_review.append(line[is_review_date(line).end():])
        review_added = 0
        
    #Phone color list
    elif is_color(line):
        result2 = re.findall(r'^\w+', line[is_color(line).end():])
        colors.append(result2[0])
        review_added = 0
        
    #Comments List
    elif is_comment(line):
        review_added = 0
        #do nothing
        pass
     
    #Reviews list
    else:
        if review_added:
            reviews[-1] = reviews[-1] + line
        else:
            reviews.append(line)
            review_added = 1
        
    cnt += 1
        


# In[6]:

print "Number of ratings : ", len(ratings)
print "Average Rating : %.1f" % np.nanmean(ratings)
print "\nRatings : ", ratings 
print "\nColors : ", colors
print "\nReview Dates : ", dates_of_review
print "\nReviews : ", reviews
print "Length of ratings list ", len(ratings) 
print "Length of colors list ", len(colors) 
print "Length of review dates list ", len(dates_of_review) 
print "Length of reviews list ", len(reviews) 


# In[7]:

#Creating Data frames
reviews_lot = [('Review_Date', dates_of_review),
              ('Color', colors),
              ('5_Star_Rating', ratings),
              ('Review', reviews)] 
reviews_df = pd.DataFrame.from_items(reviews_lot)


# ## Result 1.1

# In[8]:

print reviews_df.head()
#reviews_df.to_csv("GalaxyOn5Reviews.csv")


# In[9]:

print reviews_df['Review'].head(10)


# In[10]:

# Creating corpus
nltk.download('stopwords')
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
ps = PorterStemmer() # For converting into root words


# In[11]:

corpus = []

#Text Cleaning
for i in range(len(reviews_df['Review'])):
    review = reviews_df['Review'][i]
    review = re.sub('[^a-zA-z]', " ", review)
    review = review.lower()
    review = review.split()
    review = [ps.stem(word) for word in review if not word in set(stopwords.words('english'))]
    review = " ".join(review)
    #reviews_df['Review'][i] = review
    corpus.append(review)
    
print reviews_df['Review'].head()


# ## Result 1.2

# In[12]:

for i in range(10):
    print corpus[i]


# # 2. Building TF-idf Matrix

# In[13]:

#Building bag of words model
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features=250)
X = cv.fit_transform(corpus).toarray()
y = reviews_df.iloc[:, 2].values
print "Shape : ", X.shape
for i in X:
    print i


# In[14]:

print cv.get_feature_names()


# In[15]:

# Building tf-idf matrix
from sklearn.feature_extraction.text import TfidfTransformer
transformer = TfidfTransformer(smooth_idf=False)
print transformer


# ## Result 2

# In[16]:

tfidf = transformer.fit_transform(X).toarray()
for i in tfidf:
    print i


# # 3. PoS Tagging

# <a href = "http://www.nltk.org/book/ch05.html">PoS Tutorial</a>

# In[17]:

new_corpus = ""
for review in corpus:
    new_corpus = new_corpus + " " + review 


# In[18]:

#nltk.download('punkt')
#nltk.download('averaged_perceptron_tagger')


# ## Result 3

# In[19]:

new_corpus_tokenized = nltk.word_tokenize(new_corpus)
text = nltk.pos_tag(new_corpus_tokenized)
print "Word => PartOfSpeech"
print "--------------------"
for i in text:
    print i[0]," => ", i[1]


# # 4. Building Word Cloud from corpus
# ### --- Galaxy on 5

# In[20]:

from wordcloud import WordCloud
wordcloud = WordCloud(background_color='white',
                      width=3000,
                      height=3000
                     ).generate(new_corpus)


plt.imshow(wordcloud)
plt.axis('off')


# ## Result 4

# In[21]:

plt.show()


# # 5. Application of Statistical concepts
# ###  --- Naive Bayes Classification algorithm
# ---
# ### Prediction of 5 Star rating from the Customer review

# In[22]:

print reviews_df['5_Star_Rating'].value_counts()


# In[23]:

# Splitting the dataset into the Training set and Test set
# For simplicity, I classified with count vector instead of TF-idf vector
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 0)

# Fitting Naive Bayes to the Training set
from sklearn.naive_bayes import GaussianNB
classifier = GaussianNB()
classifier.fit(X_train, y_train)

# Predicting the Test set results
#print X_test
y_pred = classifier.predict(X_test)


# ## Result 5

# In[24]:

print "Actual Predicted"
for i in range(len(y_test)):
    print int(y_test[i]), "      ", int(y_pred[i])


# In[25]:

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)

print "Confusion Matrix\n", cm


# In[26]:

#Example
new_reviews = ["Performance is Good..........Average camera", 
           "1) restarts frequently 2) slow multi tasking 3) Heating issues while charging  ",
           "Awesome camera quality. UI is appealing. Better than other phones in this price range" ]

def to_root_sentence(review):
    review = re.sub('[^a-zA-z]', " ", review)
    review = review.lower()
    review = review.split()
    review = [ps.stem(word) for word in review if not word in set(stopwords.words('english'))]
    review = " ".join(review)
    return review
    
def build_feature_vector(review):
    X = cv.transform([review]).toarray()
    return X

for review in new_reviews:
    print review
    review = to_root_sentence(review)
    X = build_feature_vector(review)
    print "-----   Predicted Rating :", classifier.predict(X), "  -----\n"


# ## Additional Inferences

# In[27]:

print "Number of ratings : ", len(reviews_df["5_Star_Rating"])
print "Average Rating : %.1f" % np.nanmean(reviews_df["5_Star_Rating"])


# In[28]:

reviews_df.Color.value_counts().plot(kind = 'pie')
plt.show()


# * Many of the reviews has the word Amazon => The dataset is extracted from **www.amazon.com**
# * Average rating = **4.4 (170 ratings)** => Comparatively very Good rating 
# * **Gold** color phones are popular among the people
