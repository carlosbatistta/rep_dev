from model import Model, FileAuthentication, Databases
from datetime import datetime, date


class Checkout:

    def __init__(self, number_employee: int, number_room: int, type_category: int,
                  valor_consumo: float, valor_pago: float, numero_reserva: int,
                   numero_client: int, model: Model) -> None:
        self.number_employee = number_employee
        self.number_room = number_room
        self.type_category = type_category
        self.valor_consumo = valor_consumo
        self.valor_pago = valor_pago
        self.numero_reserva = numero_reserva
        self.numero_client = numero_client
        self.model = model


    def register_checkout(self):
        """Insere os dados no checkout"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""INSERT INTO checkout (valor_consumo, valor_pago, data_criacao, pk_funcionario,
        pk_reserva, pk_reserva_hospede, pk_reserva_quarto, pk_reserva_categoria) VALUES (:valor_consumo,
        :valor_pago,:data_criacao,:pk_funcionario,:pk_reserva,:pk_reserva_hospede,:pk_reserva_quarto,
        :pk_reserva_categoria)""",
        (self.valor_consumo, self.valor_pago, datetime.today(), self.number_employee, self.numero_reserva, 
        self.numero_client, self.number_room, self.type_category))
        conn.commit()
        conn.close()
        return 'Dados Inseridos'


class CalculateValueClient:

    def __init__(self, numero_hospede: int, model: Model):
        self.numero_hospede = numero_hospede
        self.model = model

    
    def calculate_value_total(self):
        """faz o calculo de pagamento total considerando diaria, multa, serviço"""
        conn = self.model.database.connect()
        cursor = conn.cursor()
        cursor.execute("""
        SELECT 
            r.quant_hospedes * c.valor + COALESCE(serv.preco, 0) AS preco_total,
            strftime('%s', r.saida_prevista) - strftime('%s', r.entrada_prevista) AS num_dias,
            CASE 
                WHEN ? > strftime('%s', r.saida_prevista, 'localtime')
                THEN (strftime('%s', r.saida_prevista, 'localtime')
            - strftime('%s', r.entrada_prevista, 'localtime')) / 86400 * (c.valor * 0.1)
            ELSE 0 
            END AS multa
        FROM reserva r
        INNER JOIN quarto q ON q.id_quarto = r.pk_quarto
        INNER JOIN categoria c ON c.id_categoria = q.pk_categoria
        LEFT JOIN reservar_servico rs ON c.id_categoria = rs.pk_categoria
        LEFT JOIN servico serv ON serv.id_servico = rs.pk_servico
        WHERE r.pk_hospede = :id_param """, (date.today(), self.numero_hospede))
        result = cursor.fetchone()
        conn.close()
        if result is not None:
            return result[0]
        else:
            return 'Número do Hóspede Inexistente!'

