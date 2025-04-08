import requests
import pickle
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Google Drive direct download links
vectorizer_url = "https://drive.google.com/uc?export=download&id=1i2S80-td3j7EeDYYgNDo9wd83LgYSbd_"
model_url = "https://drive.google.com/uc?export=download&id=1lZPtoIwWThuFoL9ljT_lf1rlRBfn4P-O"

# Download and load the model
def download_file(url, filename):
    response = requests.get(url)
    with open(filename, "wb") as file:
        file.write(response.content)

# Download model & vectorizer
download_file(model_url, "model.pkl")
download_file(vectorizer_url, "vectorizer.pkl")

# Load model & vectorizer
model = pickle.load(open("model.pkl", "rb"))
vectorizer = pickle.load(open("vectorizer.pkl", "rb"))

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    ingredients = data['ingredients']

    # Transform input
    input_features = vectorizer.transform([" ".join(ingredients)])
    
    # Predict
    prediction = model.predict(input_features)

    return jsonify({"sideEffects": prediction.tolist()})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
