# 1. Objetivo - Criar uma API que disponibiliza a consulta, criação, edição e exclusão de livros
# 2. URL Base - localhost
# 3. Endpoint - localhost/livros (GET) - localhost/livros (POST) - localhost/livros/id (GET) - localhost/livros/id (PUT) - localhost/livros (DELETE)
# 4. Quais recursos
from flask import Flask, jsonify, request

app = Flask(__name__)

#arry com um dicionário dentro, existe a forma de arquivos verificar posteriormente
#aprender usando Django
livros = [ 
    {
        'id': 1,
        'título': 'O Senhor dos Anéis - A Sociedade do Anel',
        'autor': 'J.R.R Tolkien'
    },
    {
        'id': 2,
        'título': 'Harry Potter e a Pedra Filosofal',
        'autor': 'J.K Howling'
    },
    {
        'id': 3,
        'título': 'James Clear',
        'autor': 'Hábitos Atômicos'
    },
]

# Consultar(todos)
# o @app irá definir que essa consulta é uma consulta via api o \livros irá completar o link do servidor e o methods sempre será o GET para essa consulta
@app.route('/livros',methods=['GET']) #definição da rota
def obter_livros():
    return jsonify(livros)

# Consultar(id)
@app.route('/livros/<int:id>',methods=['GET']) # /livros/<int:id> espera receber um inteiro, o def irá receber esse inteiro.
def obter_livro_por_id(id):
    for livro in livros: #pesquisa um livro no array de livros
        if livro.get('id') == id:
            return jsonify(livro)
# Editar
@app.route('/livros/<int:id>',methods=['PUT'])
def editar_livro_por_id(id):
    livro_alterado = request.get_json()
    for indice,livro in enumerate(livros):
        if livro.get('id') == id:
            livros[indice].update(livro_alterado)
            return jsonify(livros[indice])
# Criar
@app.route('/livros',methods=['POST'])
def incluir_novo_livro():
    novo_livro = request.get_json()
    livros.append(novo_livro)
    
    return jsonify(livros)
# Excluir
@app.route('/livros/<int:id>',methods=['DELETE'])
def excluir_livro(id):
    for indice, livro in enumerate(livros):
        if livro.get('id') == id:
            del livros[indice]

    return jsonify(livros)

app.run(port=5000,host='localhost',debug=True)
