import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import pickle

# Load dataset
data = pd.read_csv('ml/medicine_dataset_extended.csv')

# Feature Selection
X = data[['StorageTemp', 'Humidity', 'ExpiryDays']]
y = data['SpoilageRisk']

# Split Data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Model Training
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Save Model
with open('ml/medicine_model.pkl', 'wb') as file:
    pickle.dump(model, file)

print('Model trained and saved successfully!')
