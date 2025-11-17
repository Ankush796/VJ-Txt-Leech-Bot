from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Tech VJ'

@app.route('/health')
def health():
    return jsonify(status="ok"), 200
