from model import Model
from datetime import datetime
from model import FileAuthentication, Databases


class ReserveClient:

    def __init__(self, nome: str, cpf: str, telefone: int, email: str,
        sexo: str, nascimento: str, dados_bancario: str, senha: str, model: Model) -> str:
        self.nome = nome
        self.cpf = cpf
        self.telefone = telefone
        self.email = email
        self.sexo = sexo
        self.nascimento = nascimento
        self.dados_bancarios = dados_bancario
        self.senha = senha
        self.model = model


    def guest_registration(self):
        """inserir hospede no banco"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""
        INSERT INTO hospede (nome, cpf, telefone, email, sexo, data_nascimento, dados_bancarios, senha_bancaria,
        data_criacao) VALUES (:nome,:cpf,:telfone,:email,:sexo,:data_nascimento,:dados_bancarios,
        :senha_bancaria,:data_criacao)""",
        (self.nome, self.cpf, self.telefone, self.email, self.sexo, self.nascimento, self.dados_bancarios, 
        self.senha, datetime.today()))
        conn.commit()
        conn.close()
        return 'reservado com sucesso'

