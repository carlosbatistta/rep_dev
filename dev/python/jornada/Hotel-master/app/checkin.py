from model import Model, FileAuthentication, Databases
from automate_insertion_pk import AutoIncrementPk
from datetime import datetime


class Checkin:

    def __init__(self, number_employee: int, number_room: int, type_category: int, model: Model) -> None:
        self.number_employee = number_employee
        self.number_room = number_room
        self.type_category = type_category
        self.model = model


    def register_checkin(self, automate_pk: AutoIncrementPk):
        """Inserir checkin no banco"""
        count_reserve_pk = automate_pk.count_reserve()
        count_client_pk = automate_pk.count_client()
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO checkin (data_criacao, pk_funcionario, pk_reserva, pk_reserva_hospede,
        pk_reserva_quarto, pk_reserva_categoria) VALUES (:data_criacao,:pk_funcionario,:pk_reserva,
        :pk_reserva_hospede,:pk_reserva_quarto,:pk_reserva_categoria)""", (datetime.today(), 
        self.number_employee, count_reserve_pk, count_client_pk, self.number_room, self.type_category))
        conn.commit()
        conn.close()
        return 'Dados Inseridos'
    