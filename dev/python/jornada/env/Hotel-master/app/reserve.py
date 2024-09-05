from model import Model, FileAuthentication, Databases
from datetime import datetime
from automate_insertion_pk import AutoIncrementPk


class Reserve:

    def __init__(self, type_category: int, number_room: int, quant_hospedes: int, entrada_prevista: str,
                 saida_prevista: str, model: Model, antecipacao: float = None) -> None:
        self.type_category = type_category
        self.number_room = number_room
        self.quant_hospedes = quant_hospedes
        self.entrada_prevista = entrada_prevista
        self.saida_prevista = saida_prevista
        self.antecipacao = antecipacao
        self.model = model

    
    def register_reserve(self, automate_pk: AutoIncrementPk):
        """inserir reserva do cliente no banco"""
        count_client_pk = automate_pk.count_client()
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO reserva (quant_hospedes, antecipacao, entrada_prevista, saida_prevista,
        data_criacao, pk_hospede, pk_quarto, pk_quarto_categoria) VALUES (:quant_hospedes,:antecipacao,
        :entrada_prevista,:saida_prevista,:data_criacao,:pk_hospede,:pk_quarto,:pk_quarto_categoria)""", 
        (self.quant_hospedes, self.antecipacao, self.entrada_prevista, self.saida_prevista, datetime.today(),
        count_client_pk, self.number_room, self.type_category))
        conn.commit()
        conn.close()
        return 'Registrado com Sucesso'
    
