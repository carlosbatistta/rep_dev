import { createTheme } from "@mui/material";
import { useMemo } from "react";
import { useState } from "react";
import { createContext } from "react";

// Color Design Tokens

/**
Função que define um conjunto de cores para o tema, dependendo do modo (dark ou light).
As cores estão organizadas em categorias como:
gray (tons de cinza),
primary (cor principal do tema),
greenAccent, redAccent, e blueAccent (cores de destaque).
Cada categoria tem diferentes níveis de intensidade (100 a 900), permitindo uma paleta flexível para usar em elementos variados.
 */
export const tokens = (mode) => ({
  ...(mode === "dark"
    ? {
      gray: { //Objeto com atributos chave: valor
        100: "#e0e0e0",
        200: "#c2c2c2",
        300: "#a3a3a3",
        400: "#858585",
        500: "#666666",
        600: "#525252",
        700: "#3d3d3d",
        800: "#292929",
        900: "#141414",
      },
      primary: {
        100: "#d0d1d5",
        200: "#a1a4ab",
        300: "#727681",
        400: "#434957",
        500: "#141b2d",
        600: "#101624",
        700: "#0c101b",
        800: "#080b12",
        900: "#040509",
      },
      greenAccent: {
        100: "#dbf5ee",
        200: "#b7ebde",
        300: "#94e2cd",
        400: "#70d8bd",
        500: "#4cceac",
        600: "#3da58a",
        700: "#2e7c67",
        800: "#1e5245",
        900: "#0f2922",
      },
      redAccent: {
        100: "#f8dcdb",
        200: "#f1b9b7",
        300: "#e99592",
        400: "#e2726e",
        500: "#db4f4a",
        600: "#af3f3b",
        700: "#832f2c",
        800: "#58201e",
        900: "#2c100f",
      },
      blueAccent: {
        100: "#e1e2fe",
        200: "#c3c6fd",
        300: "#a4a9fc",
        400: "#868dfb",
        500: "#6870fa",
        600: "#535ac8",
        700: "#3e4396",
        800: "#2a2d64",
        900: "#151632",
      },
    }
    : {
      gray: {
        100: "#141414",
        200: "#292929",
        300: "#3d3d3d",
        400: "#525252",
        500: "#666666",
        600: "#858585",
        700: "#a3a3a3",
        800: "#c2c2c2",
        900: "#e0e0e0",
      },
      primary: {
        100: "#040509",
        200: "#080b12",
        300: "#0c101b",
        400: "#fcfcfc",
        500: "#f2f0f0",
        600: "#434957",
        700: "#727681",
        800: "#a1a4ab",
        900: "#d0d1d5",
      },
      greenAccent: {
        100: "#0f2922",
        200: "#1e5245",
        300: "#2e7c67",
        400: "#3da58a",
        500: "#4cceac",
        600: "#70d8bd",
        700: "#94e2cd",
        800: "#b7ebde",
        900: "#dbf5ee",
      },
      redAccent: {
        100: "#2c100f",
        200: "#58201e",
        300: "#832f2c",
        400: "#af3f3b",
        500: "#db4f4a",
        600: "#e2726e",
        700: "#e99592",
        800: "#f1b9b7",
        900: "#f8dcdb",
      },
      blueAccent: {
        100: "#e1e2fe",
        200: "#c3c6fd",
        300: "#a4a9fc",
        400: "#868dfb",
        500: "#6870fa",
        600: "#535ac8",
        700: "#3e4396",
        800: "#2a2d64",
        900: "#151632",
      },
    }),
});

// Mui Theme Settings
export const themeSettings = (mode) => {
  //relação de cores é atribuida dependendo se é dark ou light
  const colors = tokens(mode);
  /**
Função que gera as configurações do tema para o Material-UI, utilizando as cores definidas por tokens(mode):
palette: Configura o esquema de cores com base no modo selecionado.
primary, secondary, neutral (cores neutras), e background.
Apenas recebe o tipo de cor (MODE) e determina qual o padrão de cor usar
   */
  return {
    palette: {
      mode: mode,
      ...(mode === "dark"
        ? {
          primary: {
            main: colors.primary[500],
          },
          secondary: {
            main: colors.greenAccent[500],
          },
          neutral: {
            dark: colors.gray[700],
            main: colors.gray[500],
            light: colors.gray[100],
          },
          background: {
            default: colors.primary[500],
          },
        }
        : {
          primary: {
            main: colors.primary[100],
          },
          secondary: {
            main: colors.greenAccent[500],
          },
          neutral: {
            dark: colors.gray[700],
            main: colors.gray[500],
            light: colors.gray[100],
          },
          background: {
            default: colors.primary[500],
          },
        }),
    },
    /**
    typography: Define a fonte e tamanhos de texto para cabeçalhos (h1 a h6) e o texto base.
     */
    typography: {
      fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
      fontSize: 12,
      h1: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 40,
      },
      h2: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 32,
      },
      h3: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 24,
      },
      h4: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 20,
      },
      h5: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 16,
      },
      h6: {
        fontFamily: ["Source Sans Pro", "sans-serif"].join(","),
        fontSize: 14,
      },
    },
  };
};

// aaqui
export const ColorModeContext = createContext({ //O prefixo export torna essa constante disponível para outros arquivos. Isso significa que outros módulos (arquivos) podem importar themeSettings e utilizá-la.
  /**
createContext é uma função fornecida pelo React que cria um Contexto.
Um contexto é uma ferramenta usada para compartilhar valores (como estado ou funções) entre componentes em uma árvore, sem precisar passar esses valores manualmente por meio de props.
Por que usar contextos?
Facilita o compartilhamento de dados "globais" em um aplicativo React, como o tema (dark/light), o idioma do usuário, ou configurações de autenticação.
   */
  //recebe se é dark ou light
  toggleColorMode: () => { },
});

export const useMode = () => {

  const [mode, setMode] = useState("dark");
  //O estado inicial é "dark".

  const colorMode = useMemo(() => ({
    //Esta função altera o estado para o outro modo quando acionada.
    toggleColorMode: () =>
      setMode((prev) => (prev === "light" ? "dark" : "light")),
  }));

  //na mesma função chama o themeSettings definindo as cores de acordo com o mode
  const theme = useMemo(() => createTheme(themeSettings(mode), [mode]));
  //Usa o createTheme do Material-UI para gerar o tema baseado nas configurações de themeSettings(mode).

  return [theme, colorMode];
};
