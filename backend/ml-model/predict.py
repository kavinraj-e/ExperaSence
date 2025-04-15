from flask import Flask, request, jsonify
import joblib
import re

app = Flask(__name__)

tfidf = joblib.load('tfidf_vectorizer.pkl')
mlb = joblib.load('mlb.pkl')
model = joblib.load('svm_model.pkl')  # Best model

def clean_composition(text):
    text = re.sub(r'\(\d*\.?\d*mg[/ml]*\)', '', text)  # Remove dosages like (500mg)
    text = text.replace('+', ' ').lower().strip()
    return text

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        composition = data.get('composition', '')
        if not composition:
            return jsonify({'error': 'No composition provided'}), 400

        cleaned = clean_composition(composition)
        transformed = tfidf.transform([cleaned])
        prediction = model.predict(transformed)
        side_effects = mlb.inverse_transform(prediction)[0]

        return jsonify({'sideEffects': list(side_effects)})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=7000)
