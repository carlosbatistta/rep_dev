import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from cancel_hosting import CancelHosting


class LayoutCancel:

    def __init__(self):
        """layout para cancelar reserva"""
        self.layout = [
            [sg.Text('Nome:', size=(12, 1)), sg.InputText(key='nome', size=(50,1))],
            [sg.Text('CPF:', size=(12, 1)), sg.InputText(key='cpf', size=(50,1))],
            [sg.Text('N° Reserva:', size=(12, 1)), sg.InputText(key='n_reserva', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Cancelar Reserva', self.layout, size=(580,150))

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
                register = CancelHosting(values['nome'], values['cpf'],values['n_reserva'], model)
                register.cancel_client()
                sg.popup('Hóspede Excluido!')
        self.window.close()



