import PySimpleGUI as sg
from interface_clerk import ApplicationClerk
from layout_employee import RegisterEmployee
from layout_category import RegisterCategory
from layout_room import RegisterRoom
from layout_service import RegisterService


class ApplicationAdmin:

    def __init__(self) -> None:
        """interface do admin"""
        menu_def = [['&Ajuda', ['&Sobre']], ['&Configuração', ['&Sair']]
        ]
        self.layout = [
            [sg.Menu(menu_def)],
            [sg.Text('Hotel borde', justification='center')],
            [sg.Button('Cadastrar Funcionario', key='register_employee'),
            sg.Button('Cadastrar Categoria', key='register_category'),
            sg.Button('Cadastrar Quarto', key='register_room'),
            sg.Button('Cadastrar Serviços', key='register_service'),
            sg.Button('Consultas')],
            [sg.Column([[sg.Text('Área de Exibição')],[sg.Output(size=(150, 100), key='exibir')],], 
            vertical_alignment='center', justification='center')]
        ]

        self.window = sg.Window('Sistema de hotel', self.layout, element_justification='center',
        resizable=True, size=(1060, 640))


    def result(self, result):
        """exibir resultado"""
        self.window['exibir'].update(f'{result}')

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED:
                break
            # Menu
            elif event == 'Sobre':
                sg.popup('Sobre', 'Desenvolvido por: Wenderson Oscar Santos Silva')
            elif event == 'Sair':
                self.window.close()
            # Cadastro
            if event == 'register_category':
                layout_category = RegisterCategory()
                layout_category.run()
            if event == 'register_room':
                layout_room = RegisterRoom()
                layout_room.run()
            if event == 'register_employee':
                layout_employee = RegisterEmployee()
                layout_employee.run()
            if event == 'register_service':
                layout_service = RegisterService()
                layout_service.run()
            # Mudar de Janela
            if event == 'Consultas':
                consult = ApplicationClerk()
                self.window.close()
                consult.run()

        self.window.close()

