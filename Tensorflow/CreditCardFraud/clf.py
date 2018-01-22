# coding: utf-8
# In[1]:
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import keras

"""
URL: https://github.com/DakshMiglani/Credit-Card-Fraud/blob/master/clf.py
"""
# In[2]:

df = pd.read_csv('data/creditcard.csv')
df.head(1)


# In[3]:

df['Class'].unique() # 0 = no fraud, 1 = fraudulent


# In[4]:

# selecciona todos los registros y sus valores del dataframe, mete todas las columnas menos la última que es "Class"
X = df.iloc[:, :-1].values
# mete todos los rows y solo se queda con la última columna "Class"
y = df.iloc[:, -1].values


X_train, X_test, Y_train, Y_test = train_test_split(X, y, test_size=0.1, random_state=1)

sc = StandardScaler() #  quita la media y escala los datos a la varianza de la unidad
X_train = sc.fit_transform(X_train)
X_test = sc.transform (X_test)



from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout

clf = Sequential([
    Dense(units=16, kernel_initializer='uniform', input_dim=30, activation='relu'),
    Dense(units=18, kernel_initializer='uniform', activation='relu'),
    Dropout(0.25),
    Dense(20, kernel_initializer='uniform', activation='relu'),
    Dense(24, kernel_initializer='uniform', activation='relu'),
    Dense(1, kernel_initializer='uniform', activation='sigmoid')
])

clf.summary()