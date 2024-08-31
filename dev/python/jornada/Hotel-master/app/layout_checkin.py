import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from checkin import Checkin
from automate_insertion_pk import AutoIncrementPk


class LayoutCheckin:

    def __init__(self):
        """layout para registrar checkin"""
        self.layout = [
            [sg.Text('Ṇ° Funcionario Responsavel', size=(10, 1)), sg.InputText(key='n_funcionario', size=(50,1))],
            [sg.Text('N° Quarto:', size=(10, 1)), sg.InputText(key='n_quarto', size=(50,1))],
            [sg.Text('N° Categoria:', size=(10, 1)), sg.InputText(key='n_categoria', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Registrar Check-in', self.layout, size=(580,140), finalize=True)

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'REGISTRAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                automate = AutoIncrementPk(model)
                # Validações
                # Lógica
                register = Checkin(values['n_funcionario'], values['n_quarto'], values['n_categoria'], model)
                register.register_checkin(automate)
                sg.popup('Check-in Realizado!')
        self.window.close()


