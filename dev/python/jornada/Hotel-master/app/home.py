import PySimpleGUI as sg
from interface_clerk import ApplicationClerk
from interface_admin import ApplicationAdmin
from model import Model, FileAuthentication, Databases


class HotelSystem:

    def __init__(self):
        self.layout_main = [
            [[sg.T()] for i in range(6)],
            [sg.T(size=(7,1)),sg.Text('Sistema de Login', font=('Helvetica', 20), justification='center')],
            [sg.Text('Usuário:', size=(8,1)), sg.Input(key='usuario', size=(30,1))],
            [sg.Text('Senha:', size=(8,1)), sg.Input(key='senha', password_char='*', size=(30,1))],
            [sg.T(size=(7,1)),sg.Button('Entrar', size=(10,1), button_color=('white', '#4B8BBE')),
            sg.Button('Sair', size=(10,1), button_color=('white', '#B02B2C'))]
            ]

        self.window = sg.Window('Sistema de hotel', self.layout_main, element_justification='center',
        resizable=True, size=(1060, 540))


    def run(self):
        authen = FileAuthentication('authenticade.json')
        db = Databases()
        model = Model(authen, db)
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'Sair':
                break
            elif authen.authenticate(values['usuario'], values['senha']):
                if values['usuario'] == 'admin':
                    interface_admin = ApplicationAdmin()
                    self.window.close()
                    interface_admin.run()  
                elif values['usuario'] == 'clerk':
                    app = ApplicationClerk()
                    self.window.close()
                    app.run() 
            else:
                sg.popup_auto_close('Usuário ou senha inválidos!')

        self.window.close()

if __name__ == "__main__":
    oj = HotelSystem()
    oj.run()