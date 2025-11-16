# app/__init__.py
from flask import Flask
from flask_cors import CORS
import os
import tensorflow as tf
from tensorflow.keras.models import load_model

os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

app = Flask(__name__)
CORS(app)

models = {}
models_dir = os.path.join(os.path.dirname(__file__), 'models')

for file in os.listdir(models_dir):
    if file.endswith('.h5'):
        disease = file.replace('.h5', '').lower()
        path = os.path.join(models_dir, file)
        try:
            models[disease] = load_model(path)
            print(f"✅ Loaded model for: {disease}")
        except Exception as e:
            print(f"❌ Failed to load {file}: {e}")

from app import routes
