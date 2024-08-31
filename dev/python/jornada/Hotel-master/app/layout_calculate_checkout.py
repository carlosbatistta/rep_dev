import PySimpleGUI as sg
from model import FileAuthentication, Databases, Model
from checkout import CalculateValueClient


class LayoutCalculate:

    def __init__(self):
        """Interface para calcular o checkout"""
        self.layout = [
            [sg.Text('N° Hóspede:', size=(12, 1)), sg.InputText(key='n_hospede', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('CALCULAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Calcular Total a Pagar', self.layout, size=(580,100))

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'CALCULAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                #Validações
                #Logica
                calculate = CalculateValueClient(values['n_hospede'], model)
                sg.popup('Valor Total',calculate.calculate_value_total())
        self.window.close()

