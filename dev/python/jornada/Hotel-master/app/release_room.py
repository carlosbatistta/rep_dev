from model import FileAuthentication, Model, Databases

class ReleaseRoom:

    def __init__(self, numero_quarto: int, model: Model):
        self.numero_quarto = numero_quarto
        self.model = model


    def update_release(self):
        """Troca o status do quarto para Disponivel"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""UPDATE quarto SET status = 'Disponível'  WHERE numero_quarto = :numero_quarto""",
        {'numero_quarto': self.numero_quarto})
        conn.commit()
        conn.close()
        return 'alteração feita'
    
