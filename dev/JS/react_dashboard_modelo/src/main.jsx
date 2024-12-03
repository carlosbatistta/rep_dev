import React from 'react';
import ReactDOM from 'react-dom/client';
import AppRouter from './Router';
import './index.css';

/**import React from 'react': Importa a biblioteca React, necessária para criar componentes e trabalhar com JSX (JavaScript XML).
import ReactDOM from 'react-dom/client': Importa o módulo ReactDOM, que é usado para manipular o DOM (Document Object Model)
e renderizar a aplicação React na página.
import AppRouter from './Router': Importa o componente AppRouter que provavelmente gerencia as rotas da aplicação 
(baseado na nomenclatura). Esse é o componente principal que será renderizado.
import './index.css': Importa um arquivo de estilo CSS global, aplicando estilos básicos para toda a aplicação.
 */

ReactDOM.createRoot(document.getElementById('root')).render(
/**document.getElementById('root'): Localiza o elemento HTML com o ID root. Esse elemento é o "container" 
onde a aplicação React será renderizada.
Normalmente, no arquivo public/index.html, há algo como:
<div id="root"></div>
ReactDOM.createRoot(): Inicializa o novo método de renderização do React (a partir do React 18), 
criando a "raiz" para a aplicação React.
.render(): Renderiza o conteúdo JSX dentro do elemento HTML selecionado.
 */
    <React.StrictMode>
        <AppRouter />
    </React.StrictMode>
/**<React.StrictMode>: Um componente especial do React que verifica possíveis problemas no código durante
o desenvolvimento (como práticas obsoletas). Não afeta o funcionamento em produção.
<AppRouter />: O componente principal da aplicação. Geralmente, um roteador que define as páginas e as rotas, 
fornecendo navegação dinâmica dentro da aplicação. 
*/

/**
 * Resumo do fluxo
1) HTML básico: No arquivo HTML principal (index.html), existe um elemento <div id="root"></div>, que serve como 
o ponto de montagem da aplicação.

2) ReactDOM: Usa o método createRoot para conectar o React a esse elemento HTML.

3) Renderização: O React renderiza o componente AppRouter (que gerencia as rotas) dentro do <React.StrictMode>, garantindo boas práticas e verificações de erros em desenvolvimento.

4) Estilos: O arquivo CSS global (index.css) define estilos que se aplicam a toda a aplicação.
 */
);