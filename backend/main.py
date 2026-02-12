from fastapi import FastAPI, UploadFile, File
from fastapi import FastAPI, UploadFile, File
import os, shutil, sys, re, joblib


# -------------------------------------------------
# Path setup
# -------------------------------------------------
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, BASE_DIR)


# -------------------------------------------------
# Project imports
# -------------------------------------------------
from ocr.text import extract_text
from .llm_service import generate_summary, negotiation_chat
from .fairness import calculate_fairness_score
from .vin_service import get_vehicle_details
from .price_estimation import estimate_vehicle_price


# -------------------------------------------------
# App init
# -------------------------------------------------
app = FastAPI(title="Car Lease AI Assistant")

# -------------------------------------------------
# Uploads directory
# -------------------------------------------------
UPLOAD_DIR = os.path.join(BASE_DIR, "backend", "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

# -------------------------------------------------
# Load ML model (classifier pipeline)
# -------------------------------------------------
MODEL_PATH = os.path.join(BASE_DIR, "models", "clause_classifier.pkl")

print("📦 Loading clause classification model...")
model = joblib.load(MODEL_PATH)
print("✅ Model loaded successfully")

# -------------------------------------------------
# Helpers
# -------------------------------------------------
def split_into_sentences(text: str):
    sentences = re.split(r'(?<=[.!?])\s+', text)
    return [s.strip() for s in sentences if len(s.strip()) > 5]

# =================================================
# 🟢 Health Check
# =================================================
@app.get("/")
def root():
    return {"status": "Car Lease AI Backend is running"}

# =================================================
# 📄 ANALYZE PDF (MAIN PIPELINE)
# =================================================
@app.post("/analyze-pdf")
async def analyze_pdf(
    file: UploadFile = File(...),
    vin: str | None = None
):
    # -----------------------------
    # 1️⃣ Save PDF
    # -----------------------------
    pdf_path = os.path.join(UPLOAD_DIR, file.filename)
    with open(pdf_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # -----------------------------
    # 2️⃣ OCR
    # -----------------------------
    text = extract_text(pdf_path)
    sentences = split_into_sentences(text)

    if not sentences:
        return {"error": "No readable text found in PDF"}

    # -----------------------------
    # 3️⃣ ML Clause Classification
    # -----------------------------
    predictions = model.predict(sentences)

    clauses = {}
    for sent, label in zip(sentences, predictions):
        clauses.setdefault(label, []).append(sent)

    # -----------------------------
    # 4️⃣ Fairness Score
    # -----------------------------
    fairness = calculate_fairness_score(clauses)

    # -----------------------------
    # 5️⃣ LLaMA Summary
    # -----------------------------
    ai_summary = generate_summary(clauses)

    # -----------------------------
    # 6️⃣ VIN + Price Estimation (optional)
    # -----------------------------
    vehicle_info = None
    price_estimation = None

    if vin:
        vehicle_info = get_vehicle_details(vin)

        if isinstance(vehicle_info, dict) and "Make" in vehicle_info and "ModelYear" in vehicle_info:
            price_estimation = estimate_vehicle_price(vehicle_info)

    # -----------------------------
    # Final Response
    # -----------------------------
    return {
        "filename": file.filename,
        "total_sentences": len(sentences),
        "clauses": clauses,
        "fairness": fairness,
        "vehicle_info": vehicle_info,
        "price_estimation": price_estimation,
        "ai_summary": ai_summary
    }

# =================================================
# 🤝 NEGOTIATION CHATBOT
# =================================================
@app.post("/negotiate")
async def negotiate(payload: dict):
    """
    payload example:
    {
      "clauses": {...},
      "question": "What should I negotiate?"
    }
    """

    clauses = payload.get("clauses")
    question = payload.get("question")

    if not clauses or not question:
        return {"error": "Both clauses and question are required"}

    advice = negotiation_chat(clauses, question)

    return {
        "question": question,
        "negotiation_advice": advice
    }

# =================================================
# 🚗 VIN API (Standalone)
# =================================================
@app.get("/vin/{vin}")
def decode_vin(vin: str):
    return get_vehicle_details(vin)

# =================================================
# 💰 PRICE ESTIMATION (Standalone)
# =================================================
@app.post("/price-estimate")
def price_estimate(vehicle: dict):
    return estimate_vehicle_price(vehicle)
