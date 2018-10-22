#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 16:02:20 2017

@author: gokul
"""

import pandas as pd
from statsmodels.tsa.arima_model import ARIMA

def parser(x):
	return pd.datetime.strptime(x, '%Y%m%d%H')

series = pd.read_csv('train.csv', header=0, parse_dates=[0], index_col=0, squeeze=True, date_parser=parser)
series = series.astype(float)
X = series.values

model = ARIMA(X, order=(0,0,0))
model_fit = model.fit(disp=0)

new_dataset = pd.read_csv('test.csv')

output = model_fit.forecast(len(new_dataset))[0]

result = pd.DataFrame(new_dataset['ID'])
result['Count'] = output
result['Count'] = result['Count'].apply(int)

result.to_csv("result_reg.csv", index = False)
