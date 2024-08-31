import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from register import ReserveClient
from layout_reserve import LayoutReserve
from layout_checkin import LayoutCheckin


class RegisterClient:

    def __init__(self):
        """layout para fazer cadastro do hóspede"""
        self.layout = [
            [sg.Text('NOME:', size=(20, 1)), sg.InputText(key='nome', size=(50,1))],
            [sg.Text('CPF:', size=(20, 1)), sg.InputText(key='cpf', size=(50,1))],
            [sg.Text('E-MAIL:', size=(20, 1)), sg.InputText(key='email', size=(50,1))],
            [sg.Text('TELEFONE:', size=(20, 1)), sg.InputText(key='telefone', size=(50,1))],
            [sg.Text('SEXO:', size=(20, 1)), sg.Radio('Masculino', 'sexo', key='sexo_m', default=True), sg.Radio('Feminino', 'sexo', key='sexo_f')],
            [sg.Text('DATA NASCIMENTO:', size=(20, 1)), sg.Input(key='data_nascimento', size=(50,1))],
            [sg.Text('DADOS BANCÁRIOS:', size=(20, 1)), sg.InputText(key='dados_bancarios', size=(50,1))],
            [sg.Text('SENHA BANCARIA:', size=(20, 1)), sg.InputText(key='senha_bancaria', size=(50,1), password_char='*')],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Registrar Hóspede', self.layout, size=(580,280))

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'REGISTRAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                #Validações
                #Logica
                register = ReserveClient(values['nome'], values['cpf'], values['telefone'], values['email'],
                'M' if values['sexo_m'] else 'F', values['data_nascimento'], values['dados_bancarios'], values['senha_bancaria'],
                model)
                register.guest_registration()
                sg.popup('Hóspede Cadastrado com Sucesso')
                reserve = LayoutReserve()
                reserve.run()
                checkin = LayoutCheckin()
                checkin.run()
        self.window.close()


