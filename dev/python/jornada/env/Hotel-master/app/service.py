from model import Model, FileAuthentication, Databases
from datetime import date


class Service:

    def __init__(self, descricao: str, preco: float, status: str, responsible_official: int, model: Model):
        self.descricao = descricao
        self.preco = preco
        self.status = status
        self.responsible_official = responsible_official

        self.model = model


    def register_service(self):
        """inserir serviço no banco"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO servico (descricao, preco, status, pk_funcionario) VALUES (?,?,?,?)""", 
        (self.descricao, self.preco, self.status, self.responsible_official))
        conn.commit()
        conn.close()
        return 'Dados Inseridos'
    

class BookRoomService:

    def __init__(self, number_room: int, type_service: int, model: Model):
        self.number_room = number_room
        self.type_service = type_service
        self.model = model


    def book_order(self):
        """serviço de quarto"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO reservar_servico (data_criacao, pk_servico, pk_categoria) VALUES 
        (?,?,?)""", (date.today(), self.type_service, self.number_room))
        conn.commit()
        conn.close()
        return 'Dados Inseridos'
