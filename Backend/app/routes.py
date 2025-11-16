# app/routes.py
from flask import request, jsonify
from app import app, models
from app.utils import preprocess_image, generate_pdf_report
from app.model import predict_disease
from app.gen_ai import generate_text
import os
import datetime
import math

# ==========================================================
# ABSOLUTE PATH FIX
# ==========================================================
APP_ROOT = os.path.dirname(os.path.abspath(__file__))      # app/
UPLOAD_FOLDER = os.path.join(APP_ROOT, "static", "uploads")  # app/static/uploads
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


# ==========================================================
# PREDICTION API
# ==========================================================
@app.route('/predict', methods=['POST'])
def predict_route():

    # Validate image
    if 'mri_image' not in request.files:
        return jsonify({'error': 'MRI image is missing'}), 400

    # Get form inputs
    disease = request.form.get('disease', '').lower()
    patient_name = request.form.get('name', "Unknown")
    age = request.form.get('age', "N/A")

    if not disease:
        return jsonify({'error': 'Disease name missing'}), 400
    if disease not in models:
        return jsonify({'error': f'Model for \"{disease}\" not available'}), 400

    # Read & preprocess image
    image_file = request.files['mri_image']
    processed_img = preprocess_image(image_file.read())

    # ==========================================================
    # RAW MODEL OUTPUT (DO NOT MODIFY THIS)
    # ==========================================================
    raw_pred = predict_disease(models[disease], processed_img)

    # ==========================================================
    # Decision mapping for different diseases
    # Alzheimers & Multiple Sclerosis: raw_pred < 0.5 -> disease
    # Tumors & Stroke:               raw_pred >= 0.5 -> disease
    # ==========================================================
    # normalize common variants
    disease_key = disease.strip().lower()

    alz_ms_keys = {"alzheimers", "alzheimer", "multiple sclerosis", "multiple_sclerosis", "ms"}
    tumor_stroke_keys = {"tumors", "tumor", "stroke"}

    if disease_key in alz_ms_keys:
        # original rule: raw_pred < 0.5 => disease
        if raw_pred < 0.5:
            final_label = disease
            confidence = (1 - raw_pred) * 100
        else:
            final_label = "normal"
            confidence = raw_pred * 100

    elif disease_key in tumor_stroke_keys:
        # opposite rule: raw_pred >= 0.5 => disease
        if raw_pred >= 0.5:
            final_label = disease
            confidence = raw_pred * 100
        else:
            final_label = "normal"
            confidence = (1 - raw_pred) * 100

    else:
        # Fallback: keep the original mapping (same as your comment in file)
        if raw_pred < 0.5:
            final_label = disease
            confidence = (1 - raw_pred) * 100
        else:
            final_label = "normal"
            confidence = raw_pred * 100

    # ==========================================================
    # AI EXPLANATION (Gemini) and the rest of your code stays same
    # ==========================================================
    prompt = f"""
Explain this MRI result in simple and safe language.

Prediction: {final_label}
Confidence: {confidence:.2f}%

Write:
1. A short explanation (2–3 lines).
2. 3 general wellness tips (non-medical).
3. End with: "This is not a medical diagnosis."
"""

    ai_response = generate_text(prompt)

    if not ai_response:
        ai_response = (
            f"The model predicts {final_label} with {confidence:.2f}% confidence. "
            "This result is based on visible patterns learned during training. "
            "Please consult a medical professional for accurate diagnosis. "
            "This is not a medical diagnosis."
        )

    # (rest unchanged: generate PDF, return JSON...)
    safe_name = patient_name.replace(" ", "_")
    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    pdf_filename = f"{safe_name}_{timestamp}.pdf"
    pdf_path = os.path.join(UPLOAD_FOLDER, pdf_filename)

    generate_pdf_report(
        pdf_path,
        patient_name,
        age,
        final_label,
        confidence,
        ai_response
    )

    return jsonify({
        "status": "success",
        "disease": final_label,
        "confidence": round(confidence, 2),
        "ai_explanation": ai_response,
        "pdf_url": f"/static/uploads/{pdf_filename}"
    })
