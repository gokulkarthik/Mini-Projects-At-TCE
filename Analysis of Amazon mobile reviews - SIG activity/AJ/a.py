import numpy as np

original_text1 = np.loadtxt('lenovo_raw.txt', dtype = 'str', delimiter = '\n')
original_text2 = np.genfromtxt('lenovo_raw.txt', dtype = 'str', delimiter = '\n')

print original_text1
print original_text2
