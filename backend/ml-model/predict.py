import requests
import pickle
from flask import Flask, request, jsonify
import os
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import MultiLabelBinarizer
import numpy as np

app = Flask(__name__)

# === Google Drive Links (Updated for direct download) ===
vectorizer_url = "https://drive.google.com/uc?export=download&id=1EOrdqvUGPC-ksoT1V8GDoPOM_lyihj0P"
model_url = "https://drive.google.com/uc?export=download&id=1TLYqyPHC8UxziLYwldw8q2KA2ZQ7IVdD"
mlb_url = "https://drive.google.com/uc?export=download&id=1MpmjbHK_mqvaH2mw9oxp3P8TpIcBDUBg"

# === File names for storage ===
VECTOR_PATH = "vectorizer.pkl"
MODEL_PATH = "model.pkl"
MLB_PATH = "mlb.pkl"

# === Download utility ===
def download_file(url, filename):
    if not os.path.exists(filename):
        print(f"Downloading {filename}...")
        r = requests.get(url)
        with open(filename, "wb") as f:
            f.write(r.content)
        print(f"{filename} downloaded.")

# Download all necessary files
download_file(vectorizer_url, VECTOR_PATH)
download_file(model_url, MODEL_PATH)
download_file(mlb_url, MLB_PATH)

# === Load models ===
vectorizer = pickle.load(open(VECTOR_PATH, "rb"))
model = pickle.load(open(MODEL_PATH, "rb"))
mlb = pickle.load(open(MLB_PATH, "rb"))

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        ingredients = data.get("ingredients", [])
        
        if not ingredients:
            return jsonify({"error": "No ingredients provided"}), 400

        # Transform ingredients to string format and vectorize
        input_text = [" ".join(ingredients)]
        vectorized_input = vectorizer.transform(input_text)

        # Predict
        prediction = model.predict(vectorized_input)
        predicted_labels = mlb.inverse_transform(prediction)

        return jsonify({"sideEffects": predicted_labels[0]})

    except Exception as e:
        print("Error during prediction:", e)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 7000)))
