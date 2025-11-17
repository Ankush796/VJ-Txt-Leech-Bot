from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Tech VJ'

@app.route('/health')
def health():
    return jsonify(status="ok"), 200

if __name__ == "__main__":
    # For local testing: bind to 0.0.0.0 so container and external requests can reach it.
    app.run(host="0.0.0.0", port=5000, debug=False)
