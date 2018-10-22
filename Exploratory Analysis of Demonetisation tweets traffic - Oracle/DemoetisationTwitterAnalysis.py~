import numpy as np 
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt

import seaborn as sns

sns.set(style="whitegrid")

#Load CSV data
df_tweets = pd.read_csv('~/Desktop/A6/demonetization-tweets.csv', header=0, encoding="ISO-8859-1")
print ('Head of Loaded Data')
print '------------------------------------------------------'
print df_tweets.head(10)

#Pre-process Data
#create new columns namely hour, date & count for our analysis
df_tweets['hour'] = pd.DatetimeIndex(df_tweets['created']).hour
df_tweets['date'] = pd.DatetimeIndex(df_tweets['created']).date
df_tweets['count'] = 1
df_tweets_filtered = df_tweets[['hour', 'date', 'count', 'retweetCount']]
df_tweets_filtered.head(2)

#Get number of tweets and re-tweets per hour
df_tweets_hourly = df_tweets_filtered.groupby(["hour"]).sum().reset_index()
print 'number of tweets and re-tweets per hour'
print '------------------------------------------------------'
print df_tweets_hourly.head(10)


#Plot graph for number of Tweets/Re-Tweets per hour
f, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 8))

ax1.title.set_text("Number of tweets per hour")
df_tweets_hourly["count"].plot.bar(ax=ax1, color='#999966')
df_tweets_hourly["count"].plot(ax=ax1)

ax2.title.set_text("Number of re-tweets per hour")
df_tweets_hourly["retweetCount"].plot.bar(ax=ax2)
df_tweets_hourly["retweetCount"].plot(ax=ax2, color='#999966')


#Get number of tweets and re-tweets per hour on various dates
print 'Number of tweets and re-tweets per hour on various dates'
print '------------------------------------------------------'
pivot_df = df_tweets_filtered.pivot_table(df_tweets_filtered, index=["date", "hour"], aggfunc=np.sum)
print(pivot_df)
dates = pivot_df.index.get_level_values(0).unique()



#Plot the graph
f, ax = plt.subplots(2, 1, figsize=(8, 10))
plt.setp(ax, xticks=list(range(0,24)))

ax[0].title.set_text("Number of tweets per hour")
ax[1].title.set_text("Number of re-tweets per hour")

for date in dates:
    split = pivot_df.xs(date)
    
    split["count"].plot(ax=ax[0], legend=True, label='' + str(date))
    split["retweetCount"].plot(ax=ax[1], legend=True, label='' + str(date))    