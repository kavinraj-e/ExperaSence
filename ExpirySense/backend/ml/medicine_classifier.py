import sys
import pandas as pd
from fuzzywuzzy import process

# Load dataset
data = pd.read_csv('ml/medicine_dataset.csv')
medicine_names = data['MedicineName'].tolist()

# Get input text
input_text = sys.argv[1]

# Fuzzy matching to find closest match
match, score = process.extractOne(input_text, medicine_names)

# Set confidence threshold (e.g., 80%)
if score >= 80:
    print(match)
else:
    print('Unknown')
