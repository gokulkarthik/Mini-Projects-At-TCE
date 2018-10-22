
# coding: utf-8

# # Assignment 4
# 
# Before working on this assignment please read these instructions fully. In the submission area, you will notice that you can click the link to **Preview the Grading** for each step of the assignment. This is the criteria that will be used for peer grading. Please familiarize yourself with the criteria before beginning the assignment.
# 
# This assignment requires that you to find **at least** two datasets on the web which are related, and that you visualize these datasets to answer a question with the broad topic of **sports or athletics** (see below) for the region of **Ann Arbor, Michigan, United States**, or **United States** more broadly.
# 
# You can merge these datasets with data from different regions if you like! For instance, you might want to compare **Ann Arbor, Michigan, United States** to Ann Arbor, USA. In that case at least one source file must be about **Ann Arbor, Michigan, United States**.
# 
# You are welcome to choose datasets at your discretion, but keep in mind **they will be shared with your peers**, so choose appropriate datasets. Sensitive, confidential, illicit, and proprietary materials are not good choices for datasets for this assignment. You are welcome to upload datasets of your own as well, and link to them using a third party repository such as github, bitbucket, pastebin, etc. Please be aware of the Coursera terms of service with respect to intellectual property.
# 
# Also, you are welcome to preserve data in its original language, but for the purposes of grading you should provide english translations. You are welcome to provide multiple visuals in different languages if you would like!
# 
# As this assignment is for the whole course, you must incorporate principles discussed in the first week, such as having as high data-ink ratio (Tufte) and aligning with Cairo’s principles of truth, beauty, function, and insight.
# 
# Here are the assignment instructions:
# 
#  * State the region and the domain category that your data sets are about (e.g., **Ann Arbor, Michigan, United States** and **sports or athletics**).
#  * You must state a question about the domain category and region that you identified as being interesting.
#  * You must provide at least two links to available datasets. These could be links to files such as CSV or Excel files, or links to websites which might have data in tabular form, such as Wikipedia pages.
#  * You must upload an image which addresses the research question you stated. In addition to addressing the question, this visual should follow Cairo's principles of truthfulness, functionality, beauty, and insightfulness.
#  * You must contribute a short (1-2 paragraph) written justification of how your visualization addresses your stated research question.
# 
# What do we mean by **sports or athletics**?  For this category we are interested in sporting events or athletics broadly, please feel free to creatively interpret the category when building your research question!
# 
# ## Tips
# * Wikipedia is an excellent source of data, and I strongly encourage you to explore it for new data sources.
# * Many governments run open data initiatives at the city, region, and country levels, and these are wonderful resources for localized data sources.
# * Several international agencies, such as the [United Nations](http://data.un.org/), the [World Bank](http://data.worldbank.org/), the [Global Open Data Index](http://index.okfn.org/place/) are other great places to look for data.
# * This assignment requires you to convert and clean datafiles. Check out the discussion forums for tips on how to do this from various sources, and share your successes with your fellow students!
# 
# ## Example
# Looking for an example? Here's what our course assistant put together for the **Ann Arbor, MI, USA** area using **sports and athletics** as the topic. [Example Solution File](./readonly/Assignment4_example.pdf)

# In[58]:


#import the library used to query a website
import urllib2

#specify the url
wiki_12 = "https://en.wikipedia.org/wiki/United_States_at_the_2012_Summer_Olympics"
wiki_16 = "https://en.wikipedia.org/wiki/United_States_at_the_2016_Summer_Olympics"

#Query the website and return the html to the variable 'page'
page_12 = urllib2.urlopen(wiki_12)
page_16 = urllib2.urlopen(wiki_16)


# In[59]:


#import the Beautiful soup functions to parse the data returned from the website
from bs4 import BeautifulSoup

#Parse the html in the 'page' variable, and store it in Beautiful Soup format
soup_12 = BeautifulSoup(page_12, "lxml")
soup_16 = BeautifulSoup(page_16, "lxml")


# In[60]:


print (soup_12.prettify())


# In[61]:


print(soup_12.title.text)
print(soup_16.title.text)


# In[62]:


all_tables_12 = soup_12.find_all('table')
for table in all_tables_12:
    try:
        print table.th.b.text
        print table.get("class")
        print "="*100
    except:
        None


# In[63]:


all_tables_16 = soup_16.find_all('table')
for table in all_tables_16:
    try:
        print table.th.b.text
        print table.get("class")
        print "="*100
    except:
        None


# In[64]:


tables_12 = soup_12.find_all("table", class_="wikitable")
#right_table = soup.find_all("table", {class:"wikitable sortable plainrowheaders"})
right_table_12 =  tables_12[1]
print(right_table_12)


# In[65]:


tables_16 = soup_16.find_all("table", class_="wikitable")
#right_table = soup.find_all("table", {class:"wikitable sortable plainrowheaders"})
right_table_16 =  tables_16[1]
print(right_table_16)


# In[66]:


#Generate lists for 2012
A=[]
B=[]
C=[]
D=[]
E=[]

for row in right_table_12.findAll("tr"):
    cells = row.findAll('td')
    if len(cells)==5: #Only extract table body not heading
        A.append(cells[0].find(text=True))
        B.append(cells[1].find(text=True))
        C.append(cells[2].find(text=True))
        D.append(cells[3].find(text=True))
        E.append(cells[4].find(text=True))
        
print(A[:5])
print(B[:5])
print(C[:5])
print(D[:5])
print(E[:5])


# In[157]:


#import pandas to convert list to data frame
import pandas as pd
df_12 = pd.DataFrame(A,columns=['Sport'])
df_12['Gold.12'] = B
df_12['Silver.12'] = C
df_12['Bronze.12'] = D
df_12['Total.12'] = E 
df_12 = df_12[1:] # Removing first row
df_12 = df_12.reset_index()
df_12 = df_12.iloc[:,1:] # Removing index column
df_12


# In[68]:


#Generate lists for 2016
A_=[]
B_=[]
C_=[]
D_=[]
E_=[]

for row in right_table_16.findAll("tr"):
    cells = row.findAll('td')
    if len(cells)==5: #Only extract table body not heading
        A_.append(cells[0].find(text=True))
        B_.append(cells[1].find(text=True))
        C_.append(cells[2].find(text=True))
        D_.append(cells[3].find(text=True))
        E_.append(cells[4].find(text=True))
        
print(A_[:5])
print(B_[:5])
print(C_[:5])
print(D_[:5])
print(E_[:5])


# In[158]:


df_16 = pd.DataFrame(A_,columns=['Sport'])
df_16['Gold.16'] = B_
df_16['Silver.16'] = C_
df_16['Bronze.16'] = D_
df_16['Total.16'] = E_
df_16 = df_16[1:] # Removing first row
df_16 = df_16.reset_index()
df_16 = df_16.iloc[:,1:] # Removing index column
df_16


# In[160]:


# To reduce the time of scraping every time
df_12.to_csv("us_olympic_data_12.csv", index=False)
df_16.to_csv("us_olympic_data_16.csv", index=False)


# In[155]:


df_12 = pd.read_csv("us_olympic_data_12.csv")
df_16 = pd.read_csv("us_olympic_data_16.csv")


# In[150]:


#df_12 = df_12.set_index("Sport")
#df_16 = df_16.set_index("Sport")


# In[161]:


print(len(df_12))
df_12.head()


# In[162]:


print(len(df_16))
df_16.head()


# In[164]:


df = pd.merge(df_12,df_16, how="inner")
print(len(df))
df.head()


# In[166]:


print(df)


# Analysis of US Olympic Medals by Sport in 2012 and 2016
# YES
# Region : United States
# Domain : Olympics
# Research Question :
# Which sports have got more medals in 2016 that 2012?
# Which sports have got less medals in 2016 that 2012?
# Sources:
# https://en.wikipedia.org/wiki/United_States_at_the_2012_Summer_Olympics
# https://en.wikipedia.org/wiki/United_States_at_the_2016_Summer_Olympics

# In[115]:


import numpy as np
import matplotlib.pyplot as plt

#get_ipython().magic(u'matplotlib inline')
plt.figure()
sports = df_12["Sport"]
y_pos = np.arange(len(sports))
performance = [10,8,6,4,2,1]
 
p1 = plt.bar(y_pos, df_12["Gold.12"], align='center', alpha=0.6, color='yellow')
p2 = plt.bar(y_pos, df_12["Silver.12"], bottom=df_12["Gold.12"], align='center', alpha=0.6, color='grey')
p3 = plt.bar(y_pos, df_12["Bronze.12"], bottom=df_12["Gold.12"]+df_12["Silver.12"],align='center', alpha=0.7, color='brown')
plt.xticks(y_pos, sports, rotation='vertical')
plt.ylabel('Number of Medals')
plt.title('Analysis of US Olympic Medals by Sport in 2012')
plt.legend((p1[0], p2[0], p3[0]), ('Gold', 'Silver', 'Bronze'))
 
plt.show()


# In[170]:


import numpy as np
import matplotlib.pyplot as plt

bar_width = 0.30
df_16 = df_16[:19]


#get_ipython().magic(u'matplotlib inline')
plt.figure()
sports = df["Sport"]
y_pos = np.arange(len(sports))

p1_12 = plt.bar(y_pos, df["Gold.12"], bar_width, align='center', alpha=0.4, color='yellow')
p1_16 = plt.bar(y_pos+bar_width+0.05, df["Gold.16"], bar_width, align='center', alpha=1, color='yellow')
p2_12 = plt.bar(y_pos, df["Silver.12"], bar_width, bottom=df["Gold.12"].values.astype(np.float64), align='center', alpha=0.4, color='grey')
p2_16 = plt.bar(y_pos+bar_width+0.05, df["Silver.16"], bar_width, bottom=df["Gold.16"].values.astype(np.float64), align='center', alpha=1, color='grey')
p3_12 = plt.bar(y_pos, df["Bronze.12"], bar_width, bottom=df["Gold.12"].values.astype(np.float64)+df["Silver.12"].values.astype(np.float64),align='center', alpha=0.4, color='brown')
p3_16 = plt.bar(y_pos+bar_width+0.05, df["Bronze.16"], bar_width, bottom=df["Gold.16"].values.astype(np.float64)+df["Silver.16"].values.astype(np.float64),align='center', alpha=1, color='brown')

plt.xticks(y_pos + bar_width/2, sports, rotation='vertical')
plt.ylabel('Number of Medals')
plt.title('Analysis of US Olympic Medals by Sport in 2012 and 2016')
plt.legend((p1_12[0], p2_12[0], p3_12[0],p1_16[0], p2_16[0], p3_16[0] ), ("Gold '12", "Silver '12", "Bronze '12", "Gold '16", "Silver '16", "Bronze '16"))
 
plt.show()


