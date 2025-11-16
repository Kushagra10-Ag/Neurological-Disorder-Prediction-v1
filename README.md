# Neurological-Disorder-Prediction
AI-Powered Classification of Alzheimer’s, Brain Tumor, Stroke, and Multiple Sclerosis (MS)

📌 Overview

This project presents an AI-based system designed to assist with early screening of neurological disorders using 2D brain MRI images.
A custom-built Convolutional Neural Network (CNN) analyzes MRI scans and predicts the presence of one of four disorders. The system is integrated with a Flask backend and a Flutter frontend, offering real-time predictions and downloadable reports.


🚀 Key Features:

1.Custom deep learning model (CNN built from scratch)

2.MRI preprocessing: resizing, normalization, augmentation

3.Multi-class prediction across 4 major neurological disorders

4.Fast inference using Flask API

5.Clean and modern UI built with Flutter

6.Downloadable PDF report with prediction + basic advice using Gen Ai (Gemini)

7.Lightweight AI module for simple, non-medical recommendations



🔧 Tech Stack

Python, Flask – Backend & model inference

TensorFlow / Keras – Deep learning model

NumPy – Image preprocessing

Matplotlib, Seaborn – Data visualization

Flutter, Dart – Frontend UI

sklearn – Metrics & evaluation



📊 Dataset

Public MRI datasets were used for Tumor, Alzheimer’s, Stroke, and MS.

Dataset link:


🧠 Model

A custom CNN architecture with:Convolution + ReLU ,MaxPooling, Dropout ,Dense layers

Trained Model Link: https://drive.google.com/drive/folders/1sHut-OPTe_-oBqMb4qX2C2O_zsoixaTx?usp=sharing
(this is a drive link ,download the models and save it in app folder in backend by making new folder named models)
(backend -> app -> models -> here your ai models)


▶️ How to Run

Backend (Flask)
cd backend
python app.py

Frontend (Flutter)
cd frontend
flutter pub get
flutter run


📌 Disclaimer

This system is meant strictly for educational and research purposes.
It is not a medical diagnostic tool.

🤝 Contributors

Vishva Chauvisa
Kushagra Agrawal
Viduit Dev Raj Saini
