import sys
import pickle
import pandas as pd

# Load Model
with open('ml/medicine_model.pkl', 'rb') as file:
    model = pickle.load(file)

# Input Data
medicine_name = sys.argv[1]
storage_temp = float(sys.argv[2])
humidity = float(sys.argv[3])
expiry_days = int(sys.argv[4])

# Prepare Input for Prediction
data = pd.DataFrame([[storage_temp, humidity, expiry_days]],
                    columns=['StorageTemp', 'Humidity', 'ExpiryDays'])

# Predict Spoilage Risk
prediction = model.predict(data)[0]
print(prediction)
