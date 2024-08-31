from model import Model, FileAuthentication, Databases


class CancelHosting:

    def __init__(self, nome: str, cpf: str, numero_reserva: int, model: Model) -> None:
        self.nome = nome
        self.cpf = cpf
        self.numero_reserva = numero_reserva
        self.model = model


    def cancel_client(self):
        """Cancelar hospede e tudo relacionado"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        sql = """DELETE FROM hospede
        WHERE hospede.nome = :nome_param AND hospede.cpf = :cpf_param"""
        parametros = {'nome_param': self.nome, 'cpf_param': self.cpf}
        cursor.execute(sql, parametros)
        conn.commit()
    #    conn.close()
        self.__cancel_reserve()
        return 'HOSPEDE DELETADO, ASSIM COMO TUDO RELACIONADO AO CLIENTE!'
    
    def __cancel_reserve(self):
        conn = self.model.database.connect()
        cursor = conn.cursor()
        sql = """DELETE FROM reserva
        WHERE reserva.id_reserva = :id_param"""
        parametros = {'id_param': self.numero_reserva}
        cursor.execute(sql, parametros)
     #   conn.close()
        conn.commit()
        conn.close()
        return 'Reserva Deletada!'
