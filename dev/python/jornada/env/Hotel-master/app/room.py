from model import Model, FileAuthentication, Databases


class Room:

    def __init__(self, room_cateogy: int, descricao: str, numero_quarto: int, capacidade: int,
    observacao: str, status: str, model: Model):
        self.room_category = room_cateogy
        self.descricao = descricao
        self.numero_quarto = numero_quarto
        self.capacidade = capacidade
        self.observacao = observacao
        self.status =  status
        self.model = model

    
    def register_room(self):
        """inserir quarto no banco"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO quarto (descricao, numero_quarto, capacidade, observacao, status, 
        pk_categoria) VALUES (:descricao,:numero_quarto,:capacidade,:observacao,:status,:pk_categoria)""", 
        (self.descricao, self.numero_quarto, self.capacidade, self.observacao, self.status, self.room_category))
        conn.commit()
        self.__update_room()
        return 'Dados Inseridos'
    
    def __update_room(self):
        """Troca o status do quarto"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""UPDATE quarto SET status = 'Indisponível'  WHERE numero_quarto = :numero_quarto""",
        {'numero_quarto': self.numero_quarto})
        conn.commit()
        conn.close()
        return 'alteração feita'


