# app/gen_ai.py

import os
import requests
import json

API_KEY = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

print("🔍 Loaded API KEY:", API_KEY)

MODEL = "models/gemini-2.5-flash"   # <= YOUR ACCOUNT HAS THIS MODEL

def generate_text(prompt: str):
    url = f"https://generativelanguage.googleapis.com/v1/{MODEL}:generateContent?key={API_KEY}"

    headers = {"Content-Type": "application/json"}

    data = {
        "contents": [
            {
                "parts": [{"text": prompt}]
            }
        ]
    }

    try:
        res = requests.post(url, headers=headers, data=json.dumps(data))
        res_json = res.json()

        print("🔍 RAW AI RESPONSE:", res_json)

        if "candidates" in res_json:
            return res_json["candidates"][0]["content"]["parts"][0]["text"]

        print("⚠️ No output text from Gemini")
        return None

    except Exception as e:
        print("❌ ERROR calling Gemini:", e)
        return None
