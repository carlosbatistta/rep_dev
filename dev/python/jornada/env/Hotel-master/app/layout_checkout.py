import PySimpleGUI as sg
from model import Model, FileAuthentication, Databases
from checkout import Checkout
from layout_cancel import LayoutCancel


class LayoutCheckout:

    def __init__(self):
        """layout para fazer pagamento"""
        self.layout = [
            [sg.Text('Valor de Consumo:', size=(23, 1)), sg.InputText(key='consumo_valor', size=(50,1))],
            [sg.Text('Valor Pago:', size=(23, 1)), sg.InputText(key='valor_pago', size=(50,1))],
            [sg.Text('Funcionario Responsavel:', size=(23, 1)), sg.InputText(key='funcionario', size=(50,1))],
            [sg.Text('N° Categoria:', size=(23, 1)), sg.InputText(key='n_categoria', size=(50,1))],
            [sg.Text('N° Quarto:', size=(23, 1)), sg.InputText(key='n_quarto', size=(50,1))],
            [sg.Text('N° Reserva:', size=(23, 1)), sg.InputText(key='n_reserve', size=(50,1))],
            [sg.Text('N° Hóspede:', size=(23, 1)), sg.InputText(key='n_client', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Fazer Checkout', self.layout, size=(580,250))

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
                register = Checkout(values['funcionario'], values['n_quarto'] ,values['n_categoria'], values['consumo_valor'], 
                values['valor_pago'],values['n_reserve'], values['n_client'], model)
                register.register_checkout()
                sg.popup('Checkout Realizado')
                cancel = LayoutCancel()
                cancel.run()
        self.window.close()


