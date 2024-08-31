from database import DataBase
import json
from abc import ABC, abstractmethod


class AuthenticationInterface(ABC):
    
    @abstractmethod
    def authenticate(self, username: str, password: str) -> bool:
        pass


class DatabaseInterface(ABC):
    
    @abstractmethod
    def connect(self):
        pass

    
class FileAuthentication(AuthenticationInterface):

    """Classe responsavel por ler o arquivo de autenticação / autorizar o acesso"""
    
    def __init__(self, file_path: str):
        self.file_path = file_path


    def authenticate(self, username: str = None, password: str = None) -> bool:
        """ler arquivo de autenticação e comparar o valores"""
        with open(self.file_path) as f:
            authenticade = json.load(f)
        for row in authenticade.values():
            if username == row.get('username') and password == row.get('password'):
                return True
        return False
    

class Databases(DatabaseInterface):
    
    def __init__(self):
        self.con = DataBase()


    def connect(self):
        """Implementação da conexão com o banco de dados"""
        return self.con.connect


# essa classe gerencia o acesso 
class Model:

    """Classe responsável por gerenciar o acesso dos usuários no banco"""

    def __init__(self, authentication: AuthenticationInterface, database: DatabaseInterface):
        self.authentication = authentication
        self.database = database

    def login(self, username: str, password: str) -> bool:
        """login de identificação de funcionario"""
        if self.authentication.authenticate(username, password):
            return self.database.connect
        else:
            return 'Acesso Negado'
