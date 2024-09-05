import PySimpleGUI as sg
from model import FileAuthentication, Databases, Model
from release_room import ReleaseRoom


class LayoutRelease:

    def __init__(self):
        """Interface para Disponibilizar o Quarto"""
        self.layout = [
            [sg.Text('N° Quarto:', size=(12, 1)), sg.InputText(key='n_quarto', size=(50,1))],
            [sg.T()],
            [sg.T(size=(23,1)), sg.Button('Disponibilizar', bind_return_key=True), sg.T(size=(2,1)), sg.Button('CANCELAR')]
        ]

        self.window = sg.Window('Liberar Quarto', self.layout, size=(580,100))

    def run(self):
        while True:
            event, values = self.window.read()
            if event == sg.WINDOW_CLOSED or event == 'CANCELAR':
                break
            elif event == 'Disponibilizar':
                file = FileAuthentication('authenticade.json')
                db = Databases()
                model = Model(file, db)
                #Validações
                #Logica
                release = ReleaseRoom(values['n_quarto'], model)
                sg.popup('Alterado',release.update_release())
        self.window.close()

