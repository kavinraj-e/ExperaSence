import requests
import pandas as pd
import time

# Load dataset
try:
    df = pd.read_csv("../data/nlem_medicines.csv")  
    print(f"Dataset Loaded: {df.shape[0]} rows")
except FileNotFoundError:
    print("CSV file not found. Check the path!")
    exit()

# **API Configuration**
RXNORM_BASE_URL = "https://rxnav.nlm.nih.gov/REST"

def get_rxcui(medicine_name):
    """Fetch RxCUI (RxNorm Concept Unique Identifier) for the given medicine"""
    url = f"{RXNORM_BASE_URL}/rxcui.json?name={medicine_name}"
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        data = response.json()

        if "idGroup" in data and "rxnormId" in data["idGroup"]:
            return data["idGroup"]["rxnormId"][0]  
    except requests.exceptions.RequestException as e:
        print(f"⚠️ Error fetching RxCUI for {medicine_name}: {e}")
    
    return None

def get_drug_category(rxcui):
    """Fetch the drug category using RxNorm API"""
    if not rxcui:
        return "Unknown"

    url = f"{RXNORM_BASE_URL}/rxcui/{rxcui}/property.json?propName=ATC"
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        data = response.json()

        # ✅ **Fix: Check if the key exists before accessing**
        if "propConceptGroup" in data and "propConcept" in data["propConceptGroup"]:
            concepts = data["propConceptGroup"]["propConcept"]
            if isinstance(concepts, list) and len(concepts) > 0:
                return concepts[0].get("name", "Unknown")
        
        print(f"⚠️ No category found for RxCUI {rxcui}")
    except requests.exceptions.RequestException as e:
        print(f"⚠️ Error fetching category for RxCUI {rxcui}: {e}")
    
    return "Unknown"

# **Categorization Logic**
for i, row in df.iterrows():
    medicine_name = row["MedicineName"]
    print(f"🔍 Processing: {medicine_name}")  

    rxcui = get_rxcui(medicine_name)
    category = get_drug_category(rxcui)

    df.at[i, "RxCUI"] = rxcui
    df.at[i, "Category"] = category

    time.sleep(0.2)  # **Prevent API rate limiting**

# Save results
df.to_csv("categorized_medicines_api.csv", index=False)
print("✅ API-based Categorization Completed!")
