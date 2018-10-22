#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 15:36:22 2017

@author: gokul

import os
os.chdir("/media/gokul/Academic/!.Events/Student Hunt '17 - AV")
os.getcwd()
"""

from pandas import read_csv
from pandas import datetime
from matplotlib import pyplot

def parser(x):
	return datetime.strptime(x, '%Y%m%d%H')

series = read_csv('train.csv', header=0, parse_dates=[0], index_col=0, squeeze=True, date_parser=parser)
series = series.astype(float)
print(series.head())
series.plot()
pyplot.show()

from pandas.tools.plotting import autocorrelation_plot
autocorrelation_plot(series)
pyplot.show()


from statsmodels.tsa.arima_model import ARIMA
from pandas import DataFrame
# fit model
model = ARIMA(series, order=(5,1,0))
model_fit = model.fit(disp=0)
print(model_fit.summary())
# plot residual errors
residuals = DataFrame(model_fit.resid)
residuals.plot()
pyplot.show()
residuals.plot(kind='kde')
pyplot.show()
print(residuals.describe())


from sklearn.metrics import mean_squared_error
X = series.values
size = int(len(X) * 0.66)
train, test = X[0:size], X[size:len(X)]
history = [x for x in train]
predictions = list()

model = ARIMA(X, order=(5,1,0))
model_fit = model.fit(disp=0)
output = model_fit.forecast(steps=500)[0]

