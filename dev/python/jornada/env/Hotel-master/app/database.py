import sqlite3


class DataBase:

  def __init__(self) -> None:
    self.connect = sqlite3.connect("sqlite3.db")
    self.cursor = self.connect.cursor()
    self.__create_tables()


  def __create_tables(self) -> str:
    """criação do banco de dados"""
    self.cursor.execute("""CREATE TABLE IF NOT EXISTS hospede 
    (
      id_hospede INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      nome VARCHAR(100),
      cpf VARCHAR(11), 
      email VARCHAR(100), 
      telefone VARCHAR(30),
      sexo CHAR(1), 
      data_nascimento DATE, 
      dados_bancarios VARCHAR(100),
      senha_bancaria VARCHAR(50), 
      data_criacao DATETIME
    )
    """)
    self.cursor.execute("""CREATE TABLE IF NOT EXISTS funcionario
    (
      id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      nome VARCHAR(100),
      cpf VARCHAR(11), 
      email VARCHAR(100), 
      telefone VARHCAR(30), 
      sexo CHAR(1),
      data_nascimento DATE, 
      endereco VARCHAR(100), 
      matricula VARCHAR(100),
      dados_bancario VARCHAR(100), 
      nivel_acesso CHAR(1), 
      senha_acesso VARCHAR(100),
      cargo VARCHAR(100), 
      data_adimissao DATETIME, 
      data_criacao DATETIME
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS categoria
    (
      id_categoria INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      descricao VARCHAR(100),
      valor FLOAT
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS servico
    (
      id_servico INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      descricao VARCHCAR(100),
      preco FLOAT,
      status VARCHAR(45),
      pk_funcionario INTEGER NOT NULL,
      CONSTRAINT pk_funcionario_idfuncionario
      FOREIGN KEY (pk_funcionario)
      REFERENCES funcionario(id_funcionario)
      ON DELETE CASCADE
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS reservar_servico
    (
      id_reservar_servico INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      data_criacao DATE,
      pk_servico INTEGER NOT NULL,
      pk_categoria INTEGER NOT NULL,
      CONSTRAINT pk_servico_pk_categoria_ids
      FOREIGN KEY (pk_servico)
      REFERENCES servico(id_servico)
      ON DELETE CASCADE
      FOREIGN KEY (pk_categoria)
      REFERENCES categoria(id_categoria)
      ON DELETE CASCADE
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS quarto
    (
      id_quarto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      descricao VARCHAR(100),
      numero_quarto INTEGER,
      capacidade INTEGER,
      observacao VARCHAR(200),
      status VARCHAR(50),
      pk_categoria INTEGER NOT NULL,
      CONSTRAINT pk_categoria_id_categoria
      FOREIGN KEY (pk_categoria)
      REFERENCES categoria(id_categoria)
      ON DELETE CASCADE
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS reserva
    (
      id_reserva INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      quant_hospedes INTEGER,
      antecipacao FLOAT,
      entrada_prevista DATETIME,
      saida_prevista DATETIME,
      data_criacao DATETIME,
      pk_hospede INTEGER NOT NULL,
      pk_quarto INTEGER NOT NULL,
      pk_quarto_categoria INTEGER NOT NULL,
      CONSTRAINT pk_hospode_id_hospede
      FOREIGN KEY (pk_hospede)
      REFERENCES hospede (id_hospede)
      ON DELETE CASCADE
      CONSTRAINT pk_quarto_id_quarto
      FOREIGN KEY (pk_quarto)
      REFERENCES quarto(id_quarto)
      ON DELETE CASCADE
      CONSTRAINT pk_quarto_categoria_pk_categoria
      FOREIGN KEY (pk_quarto_categoria)
      REFERENCES quarto(pk_categoria)
      ON DELETE CASCADE
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS checkin
    (
      id_checkin INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      data_criacao DATETIME,
      pk_funcionario INTEGER NOT NULL,
      pk_reserva INTEGER NOT NULL,
      pk_reserva_hospede INTEGER NOT NULL,
      pk_reserva_quarto INTEGER NOT NULL,
      pk_reserva_categoria INTEGER NOT NULL,
      CONSTRAINT pk_funcionario_id_funcionario
      FOREIGN KEY(pk_funcionario)
      REFERENCES funcionario (id_funcionario)
      ON DELETE CASCADE
      CONSTRAINT pk_reserva_reservahospede_reservaquarto_reservacategoria_in
      FOREIGN KEY (
        pk_reserva,
        pk_reserva_hospede,
        pk_reserva_quarto, 
        pk_reserva_categoria
      )
      REFERENCES reserva (id_reserva, pk_hospede, pk_quarto, pk_categoria)
      ON DELETE CASCADE
    )
    """)
    self.cursor.execute(""" CREATE TABLE IF NOT EXISTS checkout 
    (
      id_checkout INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      valor_consumo FLOAT,
      valor_pago FLOAT,
      data_criacao DATETIME,
      pk_funcionario INTEGER NOT NULL,
      pk_reserva INTEGER NOT NULL,
      pk_reserva_hospede INTEGER NOT NULL,
      pk_reserva_quarto INTEGER NOT NULL,
      pk_reserva_categoria INTEGER NOT NULL,
      CONSTRAINT pk_funcionario_id_funcionario_out
      FOREIGN KEY (pk_funcionario)
      REFERENCES funcionario (id_funcionario)
      ON DELETE CASCADE
      CONSTRAINT pk_funcionario_reserva_reservahospede_reservaquarto_reservacategoria_out
      FOREIGN KEY (
        pk_reserva,
        pk_reserva_hospede,
        pk_reserva_quarto,
        pk_reserva_categoria
        )
      REFERENCES reserva (id_reserva, pk_hospede, pk_quarto, pk_cateogira)
      ON DELETE CASCADE
    )
    """)
    self.connect.commit()
    self.cursor.close()
