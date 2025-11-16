import requests, os, json

KEY = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

url = f"https://generativelanguage.googleapis.com/v1/models?key={KEY}"

print("URL:", url)

res = requests.get(url)
print("STATUS:", res.status_code)
print("RESPONSE:")
print(json.dumps(res.json(), indent=2))
