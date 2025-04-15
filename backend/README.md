# ExpiraSense 💊🧠

A smart expiration and side-effect prediction system that analyzes medicine compositions to predict potential side effects and checks expiry.

---

## 🌍 Environment Variables

```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/expirasensev1
JWT_SECRET=expirasense
FLASK_API=http://localhost:7000/predict
```

---

## 🚀 Getting Started

### 📦 Before Starting the Project

1. Navigate to the Node.js backend and install dependencies:

```bash
cd Expense-Tracker/backend
npm install
```

2. Navigate to the ML model directory and install Python dependencies:

```bash
cd Expense-Tracker/backend/ml-model
pip install -r requirements.txt
```

---

## ▶️ To Run the Project

### 🔧 Start Node.js Backend

```bash
cd Expense-Tracker/backend
node server.js
```

### 🧠 Start the ML Prediction API

```bash
cd Expense-Tracker/backend/ml-model
python predict.py
```

---

## 🔗 Node.js API Endpoint

```
http://localhost:5000/api/predict
```

---

## 📤 Sample JSON Request

```json
{
    "userId": "$2b$10$owL.lXGLauOhtfO2mtiRNO1eFZm1cGGNFd32rbn0TuWjadEL.rJzy",
    "name": "Amoxicillin",
    "ingredients": ["Amoxycillin (500mg)", "Clavulanic Acid (125mg)"],
    "expiryDate": "2025-01-10"
}
```

---

## 📥 Sample JSON Response

```json
{
    "status": "expired",
    "sideEffects": [
        "diarrhea",
        "nausea"
    ]
}
```

---

## 🛠 Tech Stack

- Node.js
- Express
- MongoDB
- Python (Flask, Scikit-learn)
- Machine Learning (Multi-label classification using SVM)