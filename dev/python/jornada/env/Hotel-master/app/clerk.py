from model import Model, Databases, FileAuthentication
from typing import Tuple, List


class AttendantQuery:
  # Read Function 

  def __init__(self, username: str, passwod: str, model: Model):
    self.username = username
    self.password = passwod
    self.model = model


  def _list_all_guests(self) -> List[Tuple[str, str, str]]:
    """Lista todos os hospedes que tenham feito uma reserva"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT 
    *
    FROM hospede 
    INNER JOIN reserva ON hospede.id_hospede = reserva.pk_hospede""")
    rows = cursor.fetchall()
    result = []
    for row in rows:
      result.append(row)
    return result

  def _search_guest(self, cpf: str) -> str:
    """Consulta de um cliente específico. pelo cpf """
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(f"""
    SELECT 
    hospede.nome, hospede.cpf, hospede.sexo, hospede.email, 
    hospede.telefone, hospede.data_criacao, quarto.numero_quarto
    FROM hospede
    INNER JOIN reserva ON hospede.id_hospede = reserva.pk_hospede 
    INNER JOIN quarto ON quarto.id_quarto = reserva.pk_quarto
    WHERE hospede.cpf = {cpf}""")
    for row in cursor.fetchall():
      return row

  def _search_customer_by_room_number(self, numero: int) -> str:
    """Consultar cliente pelo número do quarto"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(f"""
    SELECT 
    hospede.nome, hospede.sexo, hospede.telefone, quarto.descricao, 
    quarto.capacidade, quarto.observacao, quarto.status, quarto.numero_quarto,
    categoria.descricao, categoria.valor
    FROM hospede 
    INNER JOIN reserva ON hospede.id_hospede = reserva.pk_hospede 
    INNER JOIN quarto ON quarto.id_quarto = reserva.pk_quarto 
    INNER JOIN categoria ON categoria.id_categoria = quarto.pk_categoria
    WHERE quarto.numero_quarto = {numero}""")
    for row in cursor.fetchall():
      return row

  def _check_the_customer_total_payable(self, cpf: str) -> str:
    """hospedes que já pagaram"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(f"""
    SELECT 
    hospede.nome, hospede.cpf, quarto.numero_quarto, quarto.observacao, 
    categoria.descricao, categoria.valor, reserva.data_criacao,
    reserva.entrada_prevista, reserva.saida_prevista, 
    checkin.data_criacao, checkout.valor_consumo,
    checkout.valor_pago, checkout.data_criacao
    FROM hospede
    INNER JOIN reserva ON hospede.id_hospede = reserva.pk_hospede 
    INNER JOIN quarto ON quarto.id_quarto = reserva.pk_quarto 
    INNER JOIN categoria ON categoria.id_categoria = quarto.pk_categoria 
    INNER JOIN checkin ON reserva.id_reserva = checkin.pk_reserva_hospede 
    INNER JOIN checkout ON reserva.id_reserva = checkout.pk_reserva_hospede
    WHERE hospede.cpf = {cpf}""")
    for row in cursor.fetchall():
      return row

  def _search_for_available_rooms(self) -> str:
    """procura os quartos disponível"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT 
    quarto.status, quarto.numero_quarto, quarto.descricao, categoria.descricao,
    categoria.valor 
    FROM quarto
    INNER JOIN categoria ON categoria.id_categoria = quarto.pk_categoria
    WHERE quarto.status = 'Disponível'""")
    rows = cursor.fetchall()
    result = []
    for row in rows:
      result.append(row)
    return result

  def _search_types_of_services(self) -> str:
    """Procura os serviços que existe """
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT 
    servico.descricao, servico.preco, servico.status,
    funcionario.nome, funcionario.cargo
    FROM servico
    INNER JOIN funcionario ON funcionario.id_funcionario = servico.pk_funcionario""")
    rows = cursor.fetchall()
    result = []
    for row in rows:
      result.append(row)
    return result

  def _list_room_categories(self) -> str:
    """lista todos as categorias de quartos"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT 
    quarto.descricao, quarto.numero_quarto, quarto.capacidade,
    quarto.status, categoria.descricao, categoria.valor
    FROM quarto
    INNER JOIN categoria ON categoria.id_categoria = quarto.pk_categoria""")
    rows = cursor.fetchall()
    result = []
    for row in rows:
      result.append(row)
    return result

  def _search_person_by_checkin(self, nome: str) -> str:
    """Procura o hospede que tenha feito o checkin"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(f"""
    SELECT 
    hospede.nome, reserva.entrada_prevista, reserva.saida_prevista, 
    reserva.data_criacao, checkin.data_criacao
    FROM hospede
    INNER JOIN reserva ON hospede.id_hospede = reserva.pk_hospede
    INNER JOIN checkin ON reserva.id_reserva = checkin.pk_reserva
    WHERE hospede.nome = '{nome}'""")
    for row in cursor.fetchall():
      return row
