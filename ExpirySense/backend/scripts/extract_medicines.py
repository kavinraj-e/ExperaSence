import re
import pandas as pd
from PyPDF2 import PdfReader

# Path to the input PDF and output CSV
pdf_path = "../data/NLEM.pdf"
csv_path = "../data/nlem_medicines.csv"

# Regex to match common medicine name patterns
medicine_pattern = re.compile(r'\b([A-Z][a-z]+(?:\s[A-Z][a-z]+)?)\b')

# Extract text from PDF
def extract_text_from_pdf(pdf_path):
    pdf_reader = PdfReader(pdf_path)
    all_text = ""
    for page in pdf_reader.pages:
        all_text += page.extract_text()
    return all_text

# Extract medicines using regex
def extract_medicine_names(text):
    matches = re.findall(medicine_pattern, text)
    medicines = list(set(matches))  # Remove duplicates
    return medicines

# Save extracted data to CSV
def save_to_csv(medicines, csv_path):
    df = pd.DataFrame({"MedicineName": medicines})
    df.to_csv(csv_path, index=False)
    print(f"✅ Medicines extracted and saved to: {csv_path}")

# Main function
def main():
    text = extract_text_from_pdf(pdf_path)
    medicines = extract_medicine_names(text)
    save_to_csv(medicines, csv_path)

if __name__ == "__main__":
    main()
