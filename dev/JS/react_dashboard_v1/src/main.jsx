import React from 'react';
import ReactDOM from 'react-dom/client';
import AppRouter from './Router';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')).render(
/**
Procura o elemento HTML com o ID root no documento. Esse é o contêiner onde a aplicação React será montada.
Geralmente, no arquivo HTML da aplicação (como index.html), existe uma tag <div id="root"></div>.
Cria a "raiz" da aplicação React no elemento identificado.
Esse método, introduzido no React 18, substitui o antigo ReactDOM.render.
 */

    <React.StrictMode>
        <AppRouter />
    </React.StrictMode>

/**
 <React.StrictMode>:
Um componente que ativa verificações adicionais e ajuda a identificar potenciais problemas no código durante o desenvolvimento (não afeta a produção).
<AppRouter />:
Renderiza o componente principal da aplicação, responsável por gerenciar as rotas e páginas.
 */
);

/**
Fluxo Completo
O arquivo HTML contém um <div id="root"></div>.
O React encontra o elemento com o ID root e o usa como ponto de entrada.
O componente principal da aplicação (AppRouter 'Router') é renderizado dentro do <div id="root">, e a aplicação ganha vida.
 */