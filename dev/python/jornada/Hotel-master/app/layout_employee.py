import PySimpleGUI as sg
from employee import Employee
from model import FileAuthentication, Model, Databases


class RegisterEmployee:

    def __init__(self):
        """layout para registrar funcionario"""
        self.layout = [
            [sg.Text('NOME:', size=(20, 1)), sg.InputText(key='nome', size=(50,1))],
            [sg.Text('CPF:', size=(20, 1)), sg.InputText(key='cpf', size=(50,1))],
            [sg.Text('E-MAIL:', size=(20, 1)), sg.InputText(key='email', size=(50,1))],
            [sg.Text('TELEFONE:', size=(20, 1)), sg.InputText(key='telefone', size=(50,1))],
            [sg.Text('SEXO:', size=(20, 1)), sg.Radio('Masculino', 'sexo', key='sexo_m', default=True), sg.Radio('Feminino', 'sexo', key='sexo_f')],
            [sg.Text('DATA NASCIMENTO:', size=(20, 1)), sg.Input(key='data_nascimento', size=(50,1))],
            [sg.Text('ENDEREÇO:', size=(20, 1)), sg.InputText(key='endereco', size=(50,1))],
            [sg.Text('DADOS BANCÁRIOS:', size=(20, 1)), sg.InputText(key='dados_bancarios', size=(50,1))],
            [sg.Text('MATRICULA:', size=(20, 1)), sg.InputText(key='matricula', size=(50,1))],
            [sg.Text('CARGO:', size=(20, 1)), sg.InputText(key='cargo', size=(50,1))],
            [sg.Text('NÍVEL DE ACESSO:', size=(20, 1)), sg.Combo(['Administrador', 'Usuário'], key='nivel_acesso')],
            [sg.Text('SENHA DE ACESSO:', size=(20, 1)), sg.InputText(key='senha_acesso', size=(50,1), password_char='*')],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Registrar Funcionário', self.layout, size=(580,380))

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'REGISTRAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                register = Employee(values['nome'], values['cpf'], values['telefone'], values['email'], 
                'M' if values['sexo_m'] else 'F',
                values['data_nascimento'], values['dados_bancarios'], values['cargo'], values['matricula'],model,
                values['nivel_acesso'], values['senha_acesso'])
                register.employee_registration()
                sg.popup('Registrado com Sucesso')
        self.window.close()


