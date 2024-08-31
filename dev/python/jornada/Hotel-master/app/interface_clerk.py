import PySimpleGUI as sg
from layout_client import RegisterClient
from layout_client_service import LayoutService
from layout_checkout import LayoutCheckout
from layout_cancel import LayoutCancel
from layout_query import LayoutQueryCpf, LayoutQueryRoom, LayoutQueryPaid, LayoutQueryCheckin
from layout_reserve import LayoutReserve
from layout_checkin import LayoutCheckin
from model import Model, FileAuthentication, Databases
from clerk import AttendantQuery
from layout_calculate_checkout import LayoutCalculate
from layout_release_room import LayoutRelease


class ApplicationClerk:

    def __init__(self) -> None:
        """interface do atendente"""
        menu_def = [['&Menu', ['&Cadastrar Hóspede', '&Reservar Hóspede', '&checkin' ,'&Serviço', 
        '&Calcular Checkout','&Checkout', '&Cancelar Reserva', '&Liberar Quarto']],
        ['&Ajuda', ['&Sobre']],
        ['&Configuração',['&Sair']]]
        self.layout = [
            [sg.Menu(menu_def)],
            [sg.Text('Hotel borde', font=('Helvetica', 16), justification='center')],
            [sg.Button('Listar Todos os Clientes', key='listar_all'), 
            sg.Button('Consulta um Cliente', key='une_client'), 
            sg.Button('Consultar Cliente por Quarto', key='client_room'), 
            sg.Button('Consulta Hóspede que já pago', key='client_checkout'),
            sg.Button('Listar Quartos Disponível', key='available_room'), 
            sg.Button('Listar Tipos de Serviços', key='list_service')],
            [sg.Button('Listar Categorias de Quartos', key='list room category'), 
            sg.Button('Consultar Hóspede que tenha Reserva', key='guest_who_has_reservation')],
            [sg.Column([[sg.Text('Área de Exibição')],[sg.Output(size=(150, 100), key='exibir')],], 
            vertical_alignment='center', justification='center')]
        ]

        self.window = sg.Window('Sistema de hotel', self.layout, element_justification='center',
        resizable=True, size=(1060, 640))


    def result(self, result):
        self.window['exibir'].update(f'{result}')

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED:
                break
            # Menu
            elif event == 'Cadastrar Hóspede':
                layout_client = RegisterClient()
                layout_client.run()
            elif event == 'Reservar Hóspede':
                layout_reserve = LayoutReserve()
                layout_reserve.run()
            elif event == 'checkin':
                layout_checkin = LayoutCheckin()
                layout_checkin.run()
            elif event == 'Serviço':
                layout_client_service = LayoutService()
                layout_client_service.run()
            elif event == 'Calcular Checkout':
                calculate = LayoutCalculate()
                calculate.run()
            elif event == 'Checkout':
                layout_checkout = LayoutCheckout()
                layout_checkout.run()
            elif event == 'Cancelar Reserva':
                layout_cancel = LayoutCancel()
                layout_cancel.run()
            elif event == 'Liberar Quarto':
                relase = LayoutRelease()
                relase.run()
            elif event == 'Sobre':
                sg.popup('Sobre', 'Desenvolvido por: Wenderson Oscar Santos Silva')
            elif event == 'Sair':
                self.window.close()
            # Consultas
            if event == 'listar_all':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                consult = AttendantQuery('username', 'password', model)
                query = consult._list_all_guests()
                self.result(query if query else 'Não Consta')
            if event == 'une_client':
                layout_query1 = LayoutQueryCpf()
                self.result(layout_query1.run() if layout_query1.run()  else 'Não existe cliente com o cpf apresentado' )
            if event == 'client_room':
                layout_query2 = LayoutQueryRoom()
                layout_query2.run()
                self.result(layout_query2.run() if layout_query2.run() else 'Não existe cliente nesse quarto')
            if event == 'client_checkout':
                layout_query3 = LayoutQueryPaid()
                layout_query3.run()
                self.result(layout_query3.run() if layout_query3.run() else 'CPF Invalido ou Cliente ainda não pagou')
            if event == 'available_room':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                consult_query = AttendantQuery('username','password',model)
                query_dis = consult_query._search_for_available_rooms()
                self.result(query_dis if query_dis else 'Não existe Quarto Disponivel')
            if event == 'list_service':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                consult_query1 = AttendantQuery('username','passwor',model)
                query_list_service = consult_query1._search_types_of_services()
                self.result(query_list_service if query_list_service else 'Não existe Serviços')
            if event == 'list room category':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                query_room = AttendantQuery('username', 'password', model)
                consult = query_room._list_room_categories()
                self.result(consult if consult else 'Não Existe Categorias de Quartos')
            if event == 'guest_who_has_reservation':
                layout_query4 = LayoutQueryCheckin()
                query_checkin = layout_query4.run()
                self.result(query_checkin if query_checkin else 'Não existe Reserva ou nome Incorreto')

        self.window.close()
