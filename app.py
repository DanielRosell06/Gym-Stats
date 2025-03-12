from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Realizando testes para conectar a minha API no meu aplicativo

@app.route('/api/palavra', methods=['GET']) 
def getPalavra():
    return "tijolo"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)  # Porta 3000