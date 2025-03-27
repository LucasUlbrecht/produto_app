import sqlite3

from flask import Flask, request, jsonify
from db_operations import create_database, find_product_by_barcode, add_product, create_user_table, get_all_users, get_user_products

app = Flask(__name__)

# Inicializa o banco de dados (cria a tabela se não existir)
create_database()

@app.route('/barcode', methods=['POST'])
def barcode():
    data = request.json
    barcode = data.get('barcode')
    user_id = data.get('userId')

    # Verifica se o código de barras está no banco de dados do usuário
    product = find_product_by_barcode(barcode, user_id)

    if product:
        # Produto encontrado
        return jsonify({"status": "success", "message": f"Produto encontrado: {product[0]}"})
    else:
        # Produto não encontrado, solicita o nome do produto
        return jsonify({"status": "not_found", "message": "Produto não encontrado. Envie o nome do produto."})


@app.route('/add_product', methods=['POST'])
def add_product_route():
    data = request.json
    barcode = data.get('barcode')
    product_name = data.get('product_name')
    user_id = data.get('userId')
    # Adiciona o produto ao banco de dados
    add_product(barcode, product_name, user_id)
    return jsonify({"status": "success", "message": f"Produto {product_name} cadastrado com sucesso!"})
@app.route('/users', methods=['GET'])
def get_users():
    users = get_all_users()
    return jsonify({"users": users}), 200

@app.route('/products/<user_id>', methods=['GET'])
def get_products(user_id):
    products = get_user_products(user_id)
    return jsonify({"products": products}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
