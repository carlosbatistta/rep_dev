from clerk import AttendantQuery
from model import FileAuthentication, Databases, Model


class AdminQuery(AttendantQuery):

  # CRUD / ADM
  def __create(self, txt: str) -> str:
    """criação"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(txt)
    conn.commit()
    conn.close()

  def get_create(self, txt: str):
    return self.__create(txt)

  def __read(self, txt: str) -> str:
    """leitura"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(txt)
    for row in cursor.fetchall():
      return row

  def get_read(self, txt: str):
    return self.__read(txt)

  def __update(self, txt: str) -> str:
    """atualização"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(txt)
    conn.commit()
    conn.close()

  def get_update(self, txt):
    return self.__update(txt)

  def __delete(self, txt: str) -> str:
    """deletação"""
    conn = self.model.database.connect()
    cursor = conn.cursor()
    cursor.execute(txt)
    self.conn.commit()
    self.conn.close()

  def get_delete(self, txt):
    return self.__delete(txt)
