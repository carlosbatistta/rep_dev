#Include 'Protheus.ch
#Include 'RwMake.ch'
#Include 'TopConn.ch'

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MA410MNU                                                                                      |
 | Desc:  Adição de opção no menu de ações relacionadas do Pedido de Vendas                             |
 | Links: http://tdn.totvs.com/display/public/mp/MA410MNU                                               |
 *------------------------------------------------------------------------------------------------------*/

User Function MA410MNU()
    Local xArea := GetArea()

    // Define a constante VK_F2 para a tecla F2, se não existir
    #ifndef VK_F2
        #define VK_F2 113 // Código ASCII para a tecla F2
    #endif

    // Exibe mensagem para verificar se o ponto de entrada está sendo ativado
    // MsgInfo("Ponto de Entrada A410CONS ativado", "Confirmação")

    // Define a tecla de at,alho F2 para chamar a rotina MATR730
    SetKey(VK_F2, { || u_ChamaRelatorioMATR730() } )

 // Adiciona a opção ao menu de ações relacionadas do Pedido de Vendas
    // AAdd(aRotina, {"Relatório Pré-Nota", { || u_ChamaRelatorioMATR730() }, 0, 4, 0, Nil})

    RestArea(xArea)
    Return aRotina

// Função que chama a rotina MATR730
Static Function u_ChamaRelatorioMATR730()
    MATR730()
    Return
