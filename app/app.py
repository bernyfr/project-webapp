from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    env = os.getenv("ENVIRONMENT", "unknown")
    return f"Hello, World! Environment: {env}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
