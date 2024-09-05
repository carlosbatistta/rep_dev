import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from reserve import Reserve
from automate_insertion_pk import AutoIncrementPk


class LayoutReserve:

    def __init__(self):
        """layout para fazer pagamento"""
        self.layout = [
            [sg.Text('Quantidade Hóspede:', size=(23, 1)), sg.InputText(key='quant_hospede', size=(50,1))],
            [sg.Text('Antecipação:', size=(23, 1)), sg.InputText(key='antecipacao', size=(50,1))],
            [sg.Text('Entrada Prevista:', size=(23, 1)), sg.InputText(key='entrada_prevista', size=(50,1))],
            [sg.Text('Saida Prevista:', size=(23, 1)), sg.InputText(key='saida_prevista', size=(50,1))],
            [sg.Text('N° Quarto:', size=(23, 1)), sg.InputText(key='n_quarto', size=(50,1))],
            [sg.Text('N° Categoria:', size=(23, 1)), sg.InputText(key='n_categoria', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Fazer Reserva', self.layout, size=(580,250))

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'REGISTRAR':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                automate_pk = AutoIncrementPk(model)
                #Validações
                #Logica
                register = Reserve(values['n_categoria'], values['n_quarto'], values['quant_hospede'], values['entrada_prevista'],
                values['saida_prevista'], model, values['antecipacao'])
                register.register_reserve(automate_pk)
                sg.popup('Reserva Feita')
        self.window.close()
