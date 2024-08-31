import PySimpleGUI as sg
from model import FileAuthentication, Model, Databases
from service import BookRoomService


class LayoutService:

    def __init__(self):
        """layout para fazer pedido de serviço"""
        self.layout = [
            [sg.Text('N° Serviço:', size=(12, 1)), sg.InputText(key='n_servico', size=(50,1))],
            [sg.Text('N° Categoria:', size=(12, 1)), sg.InputText(key='n_categoria', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('REGISTRAR', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Fazer Pedido', self.layout, size=(580,150))

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
                register = BookRoomService(values['n_categoria'], values['n_servico'], model)
                register.book_order()
                sg.popup('Pedido Realizado')
        self.window.close()

