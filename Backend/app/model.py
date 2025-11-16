# app/model.py
import numpy as np

def predict_disease(model, processed_image):
    pred = model.predict(processed_image)[0][0]

    # return probability (0–1)
    return float(pred)
