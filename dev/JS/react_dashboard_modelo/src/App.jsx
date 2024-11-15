/**O arquivo define um componente principal App, que configura o tema, contexto e layout para a aplicação.
 * -- Modelo para dashboard --
 * | app_v1 por Carlos Batista
 * | Histórico de alterações:
 * | -Mapeamento de classes, métodos e atributos
 */

import React, { createContext, useState } from "react";
/**React, { createContext, useState }: React é usado para construir componentes; 
 * createContext é usado para criar um contexto global para estado; 
 * useState é um hook para gerenciar estados locais. */
import { Box, CssBaseline, ThemeProvider } from "@mui/material";
/**Componentes do Material-UI:
Box, CssBaseline, ThemeProvider: São componentes da biblioteca Material-UI.
Box: Um contêiner estilizado para layout.
CssBaseline: Normaliza o CSS para compatibilidade entre navegadores.
ThemeProvider: Aplica temas personalizados para os componentes. */
import { ColorModeContext, useMode } from "./theme";
/**ColorModeContext, useMode: Vêm do arquivo ./theme. Provavelmente, gerenciam o tema claro/escuro da aplicação. */
import { Navbar, SideBar } from "./scenes";
/**Navbar, SideBar: São componentes de interface vindos de ./scenes. Representam a barra de navegação e o menu lateral. */
import { Outlet } from "react-router-dom";
/**Outlet: Parte da biblioteca react-router-dom. Renderiza o conteúdo da rota correspondente. */

export const ToggledContext = createContext(null);
/**ToggledContext:
Contexto global criado com createContext e exportado para uso em outros componentes.
Ele compartilha os estados toggled e setToggled com componentes filhos.
 */

function App() {
  const [theme, colorMode] = useMode();
  /**useMode:
Retorna dois valores: o tema atual (theme) e um modo de alternância (colorMode).
Esse hook deve estar configurado no arquivo ./theme. */
  const [toggled, setToggled] = useState(false);
  /**useState(false):
Define um estado inicial para toggled como false. O valor pode ser alternado usando setToggled. */
  const values = { toggled, setToggled };
  /**values:
Um objeto com { toggled, setToggled }, compartilhado via o contexto ToggledContext. */
  return (
    /**3. Renderização do Layout
O JSX organiza o layout principal:
1) ColorModeContext.Provider:
Envolve toda a aplicação e fornece o controle de tema via colorMode.
2) ThemeProvider:
Aplica o tema configurado (theme) aos componentes filhos.
3) CssBaseline:
Normaliza os estilos básicos.
4) ToggledContext.Provider:
Compartilha o estado toggled com os componentes filhos.
Estrutura do layout com Box:
5) O Box é usado para estruturar visualmente:
SideBar: Representa o menu lateral.
Navbar: Uma barra de navegação na parte superior.
Outlet: Renderiza o conteúdo das rotas específicas.
Propriedade sx: Usada para estilização inline com Material-UI. */
    <ColorModeContext.Provider value={colorMode}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <ToggledContext.Provider value={values}>
          <Box sx={{ display: "flex", height: "100vh", maxWidth: "100%" }}>
            <SideBar />
            <Box
              sx={{
                flexGrow: 1,
                display: "flex",
                flexDirection: "column",
                height: "100%",
                maxWidth: "100%",
              }}
            >
              <Navbar />
              <Box sx={{ overflowY: "auto", flex: 1, maxWidth: "100%" }}>
                <Outlet />
              </Box>
            </Box>
          </Box>
        </ToggledContext.Provider>
      </ThemeProvider>
    </ColorModeContext.Provider>
  );
}

export default App;
