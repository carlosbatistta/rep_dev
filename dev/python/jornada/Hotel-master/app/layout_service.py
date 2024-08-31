import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from service import Service


class RegisterService:

    def __init__(self):
        """layout para registar os serviços"""
        self.layout = [
            [sg.Text('Descrição:', size=(20, 1)), sg.InputText(key='descricao', size=(50,1))],
            [sg.Text('Preco:', size=(20, 1)), sg.InputText(key='preco', size=(50,1))],
            [sg.Text('Status:', size=(20, 1)), sg.Radio('Disponível', 'status', key='status_d', default=True),
             sg.Radio('Indisponível', 'status', key='status_i')],
            [sg.Text('Número do Funcionario:', size=(20, 1)), sg.InputText(key='number_funcionario', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Registrar Serviços', self.layout, size=(580,200), finalize=True)

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'REGISTRAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                # Validações
                # Lógica
                register = Service(values['descricao'], values['preco'], 'Disponível' if values['status_d'] else 
                'Indisponível', values['number_funcionario'], model)
                register.register_service()
                sg.popup('Serviço registrada com sucesso!')
        self.window.close()

