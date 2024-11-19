import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import App from "./App";
import {
  Dashboard,
  Team,
  Invoices,
  Contacts,
  Form,
  Bar,
  Line,
  Pie,
  FAQ,
  Geography,
  Calendar,
  Stream,
} from "./scenes";

/**
react-router-dom: Biblioteca usada para implementar navegação e roteamento em aplicações React.
Router: Componente que envolve toda a aplicação para habilitar o roteamento.
Routes: Container para todas as rotas definidas.
Route: Define uma rota específica (um caminho e o componente associado).
App: Componente principal da aplicação.
Outros componentes: Importa vários componentes de diferentes cenas (Dashboard, Team, etc.) para exibir o conteúdo de cada rota.
 */

const AppRouter = () => {
  /**Aqui, AppRouter é uma constante que armazena uma função.*/
  return (
    <Router>
      <Routes>
        <Route path="/" element={<App />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/team" element={<Team />} />
          <Route path="/contacts" element={<Contacts />} />
          <Route path="/invoices" element={<Invoices />} />
          <Route path="/form" element={<Form />} />
          <Route path="/calendar" element={<Calendar />} />
          <Route path="/bar" element={<Bar />} />
          <Route path="/pie" element={<Pie />} />
          <Route path="/stream" element={<Stream />} />
          <Route path="/line" element={<Line />} />
          <Route path="/faq" element={<FAQ />} />
          <Route path="/geography" element={<Geography />} />
        </Route>
      </Routes>
    </Router>
    /**
     <Router>:
Envolve a aplicação para ativar a navegação entre rotas.
Garante que as URLs mapeiem corretamente para os componentes.

<Routes>:
Agrupa todas as rotas (URLs) e seus componentes.

<Route>:
Define as rotas:
path: URL correspondente à rota.
element: Componente a ser renderizado quando o caminho é acessado.

Quando a rota / é acessada:
O componente App é renderizado.
Dentro do App, as subrotas renderizam componentes específicos (como Dashboard, Team, etc.).
     */
  );
};

export default AppRouter;

/**
 O AppRouter:

Configura o sistema de navegação e define o mapeamento entre URLs e componentes.
Usa roteamento aninhado para encapsular as subrotas dentro do componente App.
Facilita a separação de diferentes partes da aplicação, permitindo que cada rota tenha seu próprio componente associado.
 */